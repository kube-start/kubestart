// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/download/v2.2.3/install.yaml

package v1beta3

import "strings"

// Alert is the Schema for the alerts API
#Alert: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "notification.toolkit.fluxcd.io/v1beta3"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Alert"
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

	// AlertSpec defines an alerting rule for events involving a list
	// of objects.
	spec!: #AlertSpec
}

// AlertSpec defines an alerting rule for events involving a list
// of objects.
#AlertSpec: {
	// EventMetadata is an optional field for adding metadata to
	// events dispatched by the controller. This can be used for
	// enhancing the context of the event. If a field would override
	// one already present on the original event as generated by the
	// emitter, then the override doesn't happen, i.e. the original
	// value is preserved, and an info log is printed.
	eventMetadata?: {
		[string]: string
	}

	// EventSeverity specifies how to filter events based on severity.
	// If set to 'info' no events will be filtered.
	eventSeverity?: "info" | "error" | *"info"

	// EventSources specifies how to filter events based on the
	// involved object kind, name and namespace.
	eventSources: [...{
		// API version of the referent
		apiVersion?: string

		// Kind of the referent
		kind: "Bucket" | "GitRepository" | "Kustomization" | "HelmRelease" | "HelmChart" | "HelmRepository" | "ImageRepository" | "ImagePolicy" | "ImageUpdateAutomation" | "OCIRepository"

		// MatchLabels is a map of {key,value} pairs. A single {key,value}
		// in the matchLabels map is equivalent to an element of
		// matchExpressions, whose key field is "key", the operator is
		// "In", and the values array contains only "value". The
		// requirements are ANDed. MatchLabels requires the name to be
		// set to `*`.
		matchLabels?: {
			[string]: string
		}

		// Name of the referent If multiple resources are targeted `*` may
		// be set.
		name: strings.MaxRunes(53) & strings.MinRunes(1)

		// Namespace of the referent
		namespace?: strings.MaxRunes(53) & strings.MinRunes(1)
	}]

	// ExclusionList specifies a list of Golang regular expressions to
	// be used for excluding messages.
	exclusionList?: [...string]

	// InclusionList specifies a list of Golang regular expressions to
	// be used for including messages.
	inclusionList?: [...string]
	providerRef: {
		// Name of the referent.
		name: string
	}

	// Summary holds a short description of the impact and affected
	// cluster.
	summary?: strings.MaxRunes(255)

	// Suspend tells the controller to suspend subsequent events
	// handling for this Alert.
	suspend?: bool
}
