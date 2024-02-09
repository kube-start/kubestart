// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/download/v2.2.3/install.yaml

package v1

import "strings"

// Receiver is the Schema for the receivers API.
#Receiver: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "notification.toolkit.fluxcd.io/v1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Receiver"
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

	// ReceiverSpec defines the desired state of the Receiver.
	spec!: #ReceiverSpec
}

// ReceiverSpec defines the desired state of the Receiver.
#ReceiverSpec: {
	// Events specifies the list of event types to handle, e.g. 'push'
	// for GitHub or 'Push Hook' for GitLab.
	events?: [...string]

	// Interval at which to reconcile the Receiver with its Secret
	// references.
	interval?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$" | *"10m"

	// A list of resources to be notified about changes.
	resources: [...{
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
	secretRef: {
		// Name of the referent.
		name: string
	}

	// Suspend tells the controller to suspend subsequent events
	// handling for this receiver.
	suspend?: bool

	// Type of webhook sender, used to determine the validation
	// procedure and payload deserialization.
	type: "generic" | "generic-hmac" | "github" | "gitlab" | "bitbucket" | "harbor" | "dockerhub" | "quay" | "gcr" | "nexus" | "acr"
}
