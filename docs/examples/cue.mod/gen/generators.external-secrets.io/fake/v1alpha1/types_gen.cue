// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f /home/jeff/workspace/holos-run/holos-infra/deploy/clusters/k2/components/prod-secrets-eso/prod-secrets-eso.gen.yaml

package v1alpha1

import "strings"

// Fake generator is used for testing. It lets you define
// a static set of credentials that is always returned.
#Fake: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "generators.external-secrets.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Fake"
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

	// FakeSpec contains the static data.
	spec!: #FakeSpec
}

// FakeSpec contains the static data.
#FakeSpec: {
	// Used to select the correct ESO controller (think:
	// ingress.ingressClassName)
	// The ESO controller is instantiated with a specific controller
	// name and filters VDS based on this property
	controller?: string

	// Data defines the static data returned
	// by this generator.
	data?: {
		[string]: string
	}
}
