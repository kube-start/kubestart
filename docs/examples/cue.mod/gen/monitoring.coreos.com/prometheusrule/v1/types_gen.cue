// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f /home/jeff/workspace/holos-run/holos-infra/deploy/clusters/k2/components/prod-platform-monitoring/prod-platform-monitoring.gen.yaml

package v1

import "strings"

// PrometheusRule defines recording and alerting rules for a
// Prometheus instance
#PrometheusRule: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "monitoring.coreos.com/v1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "PrometheusRule"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// Specification of desired alerting rule definitions for
	// Prometheus.
	spec!: #PrometheusRuleSpec
}
#PrometheusRuleSpec: {
	// Content of Prometheus rule file
	groups?: [...{
		// Interval determines how often rules in the group are evaluated.
		interval?: =~"^(0|(([0-9]+)y)?(([0-9]+)w)?(([0-9]+)d)?(([0-9]+)h)?(([0-9]+)m)?(([0-9]+)s)?(([0-9]+)ms)?)$"

		// Limit the number of alerts an alerting rule and series a
		// recording rule can produce. Limit is supported starting with
		// Prometheus >= 2.31 and Thanos Ruler >= 0.24.
		limit?: int

		// Name of the rule group.
		name: strings.MinRunes(1)

		// PartialResponseStrategy is only used by ThanosRuler and will be
		// ignored by Prometheus instances. More info:
		// https://github.com/thanos-io/thanos/blob/main/docs/components/rule.md#partial-response
		partial_response_strategy?: =~"^(?i)(abort|warn)?$"

		// List of alerting and recording rules.
		rules?: [...{
			// Name of the alert. Must be a valid label value. Only one of
			// `record` and `alert` must be set.
			alert?: string

			// Annotations to add to each alert. Only valid for alerting
			// rules.
			annotations?: {
				[string]: string
			}

			// PromQL expression to evaluate.
			expr: (int | string) & {
				string
			}

			// Alerts are considered firing once they have been returned for
			// this long.
			for?: =~"^(0|(([0-9]+)y)?(([0-9]+)w)?(([0-9]+)d)?(([0-9]+)h)?(([0-9]+)m)?(([0-9]+)s)?(([0-9]+)ms)?)$"

			// KeepFiringFor defines how long an alert will continue firing
			// after the condition that triggered it has cleared.
			keep_firing_for?: strings.MinRunes(1) & {
				=~"^(0|(([0-9]+)y)?(([0-9]+)w)?(([0-9]+)d)?(([0-9]+)h)?(([0-9]+)m)?(([0-9]+)s)?(([0-9]+)ms)?)$"
			}

			// Labels to add or overwrite.
			labels?: {
				[string]: string
			}

			// Name of the time series to output to. Must be a valid metric
			// name. Only one of `record` and `alert` must be set.
			record?: string
		}]
	}]
}
