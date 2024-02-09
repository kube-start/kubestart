// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/download/v2.2.3/install.yaml

package v1beta1

import "strings"

// ImageUpdateAutomation is the Schema for the
// imageupdateautomations API
#ImageUpdateAutomation: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "image.toolkit.fluxcd.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "ImageUpdateAutomation"
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

	// ImageUpdateAutomationSpec defines the desired state of
	// ImageUpdateAutomation
	spec!: #ImageUpdateAutomationSpec
}

// ImageUpdateAutomationSpec defines the desired state of
// ImageUpdateAutomation
#ImageUpdateAutomationSpec: {
	// GitSpec contains all the git-specific definitions. This is
	// technically optional, but in practice mandatory until there
	// are other kinds of source allowed.
	git?: {
		checkout?: {
			// Reference gives a branch, tag or commit to clone from the Git
			// repository.
			ref: {
				// Branch to check out, defaults to 'master' if no other field is
				// defined.
				branch?: string

				// Commit SHA to check out, takes precedence over all reference
				// fields.
				// This can be combined with Branch to shallow clone the branch,
				// in which the commit is expected to exist.
				commit?: string

				// Name of the reference to check out; takes precedence over
				// Branch, Tag and SemVer.
				// It must be a valid Git reference:
				// https://git-scm.com/docs/git-check-ref-format#_description
				// Examples: "refs/heads/main", "refs/tags/v0.1.0",
				// "refs/pull/420/head", "refs/merge-requests/1/head"
				name?: string

				// SemVer tag expression to check out, takes precedence over Tag.
				semver?: string

				// Tag to check out, takes precedence over Branch.
				tag?: string
			}
		}

		// Commit specifies how to commit to the git repository.
		commit: {
			// Author gives the email and optionally the name to use as the
			// author of commits.
			author: {
				// Email gives the email to provide when making a commit.
				email: string

				// Name gives the name to provide when making a commit.
				name?: string
			}

			// MessageTemplate provides a template for the commit message,
			// into which will be interpolated the details of the change
			// made.
			messageTemplate?: string
			signingKey?: {
				secretRef?: {
					// Name of the referent.
					name: string
				}
			}
		}

		// Push specifies how and where to push commits made by the
		// automation. If missing, commits are pushed (back) to
		// `.spec.checkout.branch` or its default.
		push?: {
			// Branch specifies that commits should be pushed to the branch
			// named. The branch is created using `.spec.checkout.branch` as
			// the starting point, if it doesn't already exist.
			branch?: string

			// Options specifies the push options that are sent to the Git
			// server when performing a push operation. For details, see:
			// https://git-scm.com/docs/git-push#Documentation/git-push.txt---push-optionltoptiongt
			options?: {
				[string]: string
			}

			// Refspec specifies the Git Refspec to use for a push operation.
			// If both Branch and Refspec are provided, then the commit is
			// pushed to the branch and also using the specified refspec. For
			// more details about Git Refspecs, see:
			// https://git-scm.com/book/en/v2/Git-Internals-The-Refspec
			refspec?: string
		}
	}

	// Interval gives an lower bound for how often the automation run
	// should be attempted.
	interval: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"

	// SourceRef refers to the resource giving access details to a git
	// repository.
	sourceRef: {
		// API version of the referent.
		apiVersion?: string

		// Kind of the referent.
		kind: "GitRepository" | *"GitRepository"

		// Name of the referent.
		name: string

		// Namespace of the referent, defaults to the namespace of the
		// Kubernetes resource object that contains the reference.
		namespace?: string
	}

	// Suspend tells the controller to not run this automation, until
	// it is unset (or set to false). Defaults to false.
	suspend?: bool

	// Update gives the specification for how to update the files in
	// the repository. This can be left empty, to use the default
	// value.
	update?: {
		// Path to the directory containing the manifests to be updated.
		// Defaults to 'None', which translates to the root path of the
		// GitRepositoryRef.
		path?: string

		// Strategy names the strategy to be used.
		strategy: "Setters" | *"Setters"
	} | *{
		strategy: "Setters"
	}
}
