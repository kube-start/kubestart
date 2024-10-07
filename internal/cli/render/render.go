package render

import (
	"context"
	"flag"
	"runtime"

	"github.com/holos-run/holos/internal/builder"
	"github.com/holos-run/holos/internal/cli/command"
	"github.com/holos-run/holos/internal/client"
	"github.com/holos-run/holos/internal/errors"
	"github.com/holos-run/holos/internal/holos"
	"github.com/holos-run/holos/internal/logger"
	"github.com/holos-run/holos/internal/render"
	"github.com/spf13/cobra"
)

func New(cfg *holos.Config) *cobra.Command {
	cmd := command.New("render")
	cmd.Args = cobra.NoArgs
	cmd.Short = "render platforms and components into the deploy/ directory"
	cmd.AddCommand(NewComponent(cfg))
	cmd.AddCommand(NewPlatform(cfg))
	return cmd
}

// New returns the component subcommand for the render command
func NewComponent(cfg *holos.Config) *cobra.Command {
	cmd := command.New("component DIRECTORY [DIRECTORY...]")
	cmd.Args = cobra.MinimumNArgs(1)
	cmd.Short = "render specific components"
	cmd.Example = "  holos render component --cluster-name=aws2 ./components/monitoring/kube-prometheus-stack"
	cmd.Flags().AddGoFlagSet(cfg.WriteFlagSet())
	cmd.Flags().AddGoFlagSet(cfg.ClusterFlagSet())

	config := client.NewConfig(cfg)
	cmd.PersistentFlags().AddGoFlagSet(config.ClientFlagSet())
	cmd.PersistentFlags().AddGoFlagSet(config.TokenFlagSet())

	flagSet := flag.NewFlagSet("", flag.ContinueOnError)
	cmd.Flags().AddGoFlagSet(flagSet)

	cmd.RunE = func(cmd *cobra.Command, args []string) error {
		ctx := cmd.Root().Context()
		build := builder.New(builder.Entrypoints(args), builder.Cluster(cfg.ClusterName()))

		results, err := build.Run(ctx, config)
		if err != nil {
			return errors.Wrap(err)
		}
		// TODO: Avoid accidental over-writes if two or more holos component
		// instances result in the same file path. Write files into a blank
		// temporary directory, error if a file exists, then move the directory into
		// place.
		var result Result
		for _, result = range results {
			log := logger.FromContext(ctx).With(
				"cluster", cfg.ClusterName(),
				"name", result.Name(),
			)
			if result.Continue() {
				continue
			}
			// DeployFiles from the BuildPlan
			if err := result.WriteDeployFiles(ctx, cfg.WriteTo()); err != nil {
				return errors.Wrap(err)
			}

			// API Objects
			if result.SkipWriteAccumulatedOutput() {
				log.DebugContext(ctx, "skipped writing k8s objects for "+result.Name())
			} else {
				path := result.Filename(cfg.WriteTo(), cfg.ClusterName())
				if err := result.Save(ctx, path, result.AccumulatedOutput()); err != nil {
					return errors.Wrap(err)
				}
			}

			log.InfoContext(ctx, "rendered "+result.Name(), "status", "ok", "action", "rendered")
		}
		return nil
	}
	return cmd
}

func NewPlatform(cfg *holos.Config) *cobra.Command {
	cmd := command.New("platform DIRECTORY")
	cmd.Args = cobra.ExactArgs(1)
	cmd.Example = "  holos render platform ./platform"
	cmd.Short = "render an entire platform"

	config := client.NewConfig(cfg)
	cmd.PersistentFlags().AddGoFlagSet(config.ClientFlagSet())
	cmd.PersistentFlags().AddGoFlagSet(config.TokenFlagSet())

	var concurrency int
	cmd.Flags().IntVar(&concurrency, "concurrency", min(runtime.NumCPU(), 8), "number of components to render concurrently")

	cmd.RunE = func(cmd *cobra.Command, args []string) error {
		ctx := cmd.Root().Context()
		build := builder.New(builder.Entrypoints(args))
		log := logger.FromContext(ctx)

		log.DebugContext(ctx, "cue: building platform instance")
		bd, err := build.Unify(ctx, config)
		if err != nil {
			return errors.Wrap(err)
		}

		tm, err := bd.TypeMeta()
		if err != nil {
			return errors.Wrap(err)
		}

		if tm.Kind != "Platform" {
			return errors.Format("invalid kind: want: Platform have: %s", tm.Kind)
		}

		log.DebugContext(ctx, "discriminated "+tm.APIVersion+" "+tm.Kind)

		switch version := tm.APIVersion; version {
		case "v1alpha4":
			return errors.NotImplemented()
		// Legacy versions
		case "v1alpha3", "v1alpha2", "v1alpha1":
			platform, err := build.Platform(ctx, config)
			if err != nil {
				return errors.Wrap(err)
			}
			return render.LegacyPlatform(ctx, concurrency, platform, cmd.ErrOrStderr())
		default:
			return errors.Format("platform version not supported: %s", version)
		}
	}

	return cmd
}

type Result interface {
	Continue() bool
	Name() string
	Filename(writeTo string, cluster string) string
	KustomizationFilename(writeTo string, cluster string) string
	Save(ctx context.Context, path string, content string) error
	AccumulatedOutput() string
	SkipWriteAccumulatedOutput() bool
	WriteDeployFiles(ctx context.Context, writeTo string) error
	GetKind() string
	GetAPIVersion() string
}
