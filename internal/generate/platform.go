package generate

import (
	"bytes"
	"context"
	"embed"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/holos-run/holos/internal/client"
	"github.com/holos-run/holos/internal/errors"
	"github.com/holos-run/holos/internal/logger"
	platform "github.com/holos-run/holos/service/gen/holos/platform/v1alpha1"
	"google.golang.org/protobuf/encoding/protojson"
)

//go:embed all:platforms
var platforms embed.FS

// platformsRoot is the root path to copy platform cue code from.
const platformsRoot = "platforms"

// Platforms returns a slice of embedded platforms or nil if there are none.
func Platforms() []string {
	entries, err := fs.ReadDir(platforms, platformsRoot)
	if err != nil {
		return nil
	}
	dirs := make([]string, 0, len(entries))
	for _, entry := range entries {
		if entry.IsDir() && entry.Name() != "cue.mod" {
			dirs = append(dirs, entry.Name())
		}
	}
	return dirs
}

func initPlatformMetadata(ctx context.Context, name string) error {
	log := logger.FromContext(ctx)
	rpcPlatform := &platform.Platform{Name: name}
	// Write the platform data.
	encoder := protojson.MarshalOptions{Indent: "  "}
	data, err := encoder.Marshal(rpcPlatform)
	if err != nil {
		return errors.Wrap(err)
	}
	if len(data) > 0 {
		data = append(data, '\n')
	}

	if err := os.WriteFile(client.PlatformMetadataFile, data, 0644); err != nil {
		return errors.Wrap(fmt.Errorf("could not write platform metadata: %w", err))
	}
	log.DebugContext(ctx, "wrote "+client.PlatformMetadataFile, "path", filepath.Join(getCwd(ctx), client.PlatformMetadataFile))

	return nil
}

// GeneratePlatform writes the cue code for a platform to the local working
// directory.
func GeneratePlatform(ctx context.Context, name string) error {
	log := logger.FromContext(ctx)
	// Check for a valid platform
	platformPath := filepath.Join(platformsRoot, name)
	if !dirExists(platforms, platformPath) {
		return errors.Wrap(fmt.Errorf("cannot generate: have: [%s] want: %+v", name, Platforms()))
	}

	if _, err := os.Stat(client.PlatformMetadataFile); err == nil {
		log.DebugContext(ctx, fmt.Sprintf("skipped write %s: already exists", client.PlatformConfigFile))
	} else {
		if os.IsNotExist(err) {
			if err := initPlatformMetadata(ctx, name); err != nil {
				return errors.Wrap(err)
			}
		} else {
			return errors.Wrap(err)
		}
	}

	// Copy the cue.mod directory
	if err := copyEmbedFS(ctx, platforms, filepath.Join(platformsRoot, "cue.mod"), "cue.mod", bytes.NewBuffer); err != nil {
		return errors.Wrap(err)
	}

	// Copy the named platform
	if err := copyEmbedFS(ctx, platforms, platformPath, ".", bytes.NewBuffer); err != nil {
		return errors.Wrap(err)
	}

	log.DebugContext(ctx, "generated platform "+name, "path", getCwd(ctx))

	return nil
}
