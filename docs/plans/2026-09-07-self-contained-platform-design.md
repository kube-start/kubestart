# Self-contained Holos platform design

## Goal

Make a freshly initialized v1beta1 platform render Helm, raw Kubernetes, and
existing Kustomize bases without a copied CUE SDK, a matching external Go
toolchain, or component-local Kustomize wrappers.

## Runtime schemas

`holos init platform v1beta1` will seed a compact local runtime schema owned by
Holos rather than import the unpublishable `api/author` CUE packages. The
runtime schema expresses the TaskSet assembly directly using ordinary CUE maps.
It intentionally validates Holos task structure and chart inputs but leaves
optional Kubernetes/CRD schemas to explicit user imports. This preserves a
small, self-contained generated platform and avoids coupling initialization to
`cue get go`.

## Kustomize bases

The v1beta1 author API gains a declarative Kustomize base input. Its source is
resolved relative to the platform root, not the component root. The renderer
runs Kustomize in that existing directory and writes only the rendered result
to Holos artifacts. `loadRestrictor: none` is an explicit generic setting; the
default remains restrictive. Resolved paths and symlinks must remain inside the
platform root.

## Toolchain

Update the repository to Go 1.26 and compatible CUE/x-tools dependencies.
Tests cover `cue get go` against the current Go version, but platform init and
normal rendering no longer depend on that optional operation.

## Evidence

Integration tests must prove: a fresh v1beta1 platform writes a Helm artifact;
no `cue.mod/pkg` or `cue.mod/gen` tree is needed; an in-repository Kustomize
base outside a component root renders with the generic base input; traversal
outside the platform root is rejected.
