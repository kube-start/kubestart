package kv

import (
	"flag"
	"fmt"
	"sort"

	"github.com/holos-run/holos/internal/cli/command"
	"github.com/holos-run/holos/internal/cli/secret"
	"github.com/holos-run/holos/internal/errors"
	"github.com/holos-run/holos/internal/holos"
	"github.com/holos-run/holos/internal/logger"
	"github.com/holos-run/holos/internal/util"
	"github.com/spf13/cobra"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

type getConfig struct {
	file *string
}

func newGetCmd(cfg *holos.Config) *cobra.Command {
	cmd := command.New("get")
	cmd.Args = cobra.MinimumNArgs(1)
	cmd.Short = "print secret data in txtar format"

	cf := getConfig{}
	flagSet := flag.NewFlagSet("", flag.ContinueOnError)
	cf.file = flagSet.String("file", "", "file to print to stdout")

	cmd.Flags().SortFlags = false
	cmd.Flags().AddGoFlagSet(cfg.ClusterFlagSet())
	cmd.Flags().AddGoFlagSet(flagSet)
	cmd.RunE = makeGetRunFunc(cfg, cf)

	return cmd
}

func makeGetRunFunc(cfg *holos.Config, cf getConfig) command.RunFunc {
	return func(cmd *cobra.Command, args []string) error {
		ctx := cmd.Context()
		log := logger.FromContext(ctx)

		cs, err := newClientSet(cfg)
		if err != nil {
			return err
		}

		for _, name := range args {
			nlog := log.With(secret.NameLabel, name)
			opts := metav1.ListOptions{
				LabelSelector: secret.NameLabel + "=" + name,
			}
			if name := cfg.ClusterName(); name != "" {
				opts.LabelSelector += fmt.Sprintf(",%s=%s", secret.ClusterLabel, name)
			}
			list, err := cs.CoreV1().Secrets(cfg.KVNamespace()).List(ctx, opts)
			if err != nil {
				return errors.Wrap(err)
			}
			nlog.DebugContext(ctx, "results", "len", len(list.Items))
			if len(list.Items) < 1 {
				continue
			}

			sort.Slice(list.Items, func(i, j int) bool {
				return list.Items[i].CreationTimestamp.Before(&list.Items[j].CreationTimestamp)
			})

			// most recent secret is the one we want.
			secret := list.Items[len(list.Items)-1]

			keys := make([]string, 0, len(secret.Data))
			for k, v := range secret.Data {
				keys = append(keys, k)
				nlog.DebugContext(ctx, "data", "name", secret.Name, "key", k, "len", len(v))
			}

			//  Print one file to stdout
			if key := *cf.file; key != "" {
				if data, found := secret.Data[key]; found {
					cfg.Write(util.EnsureNewline(data))
					return nil
				}
				return errors.Wrap(fmt.Errorf("not found: %s have %#v", key, keys))
			}

			if len(secret.Data) > 0 {
				cfg.Println(secret.Name)
			}

			for k, v := range secret.Data {
				cfg.Printf("-- %s --\n", k)
				cfg.Write(util.EnsureNewline(v))
			}
		}
		return nil
	}
}
