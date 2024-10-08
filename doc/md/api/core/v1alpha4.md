<!-- Code generated by gomarkdoc. DO NOT EDIT -->

# v1alpha4

```go
import "github.com/holos-run/holos/api/core/v1alpha4"
```

Package v1alpha4 contains the core API contract between the holos cli and CUE configuration code. Platform designers, operators, and software developers use this API to write configuration in CUE which \`holos\` loads. The overall shape of the API defines imperative actions \`holos\` should carry out to render the complete yaml that represents a Platform.

[Platform](<#Platform>) defines the complete configuration of a platform. With the holos reference platform this takes the shape of one management cluster and at least two workload clusters.

Each holos component path, e.g. \`components/namespaces\` produces exactly one [BuildPlan](<#BuildPlan>) which produces an [Artifact](<#Artifact>) collection. An [Artifact](<#Artifact>) is a fully rendered manifest produced from a [Transformer](<#Transformer>) sequence, which transforms a [Generator](<#Generator>) collection.

## Index

- [type Artifact](<#Artifact>)
- [type BuildPlan](<#BuildPlan>)
- [type BuildPlanSpec](<#BuildPlanSpec>)
- [type Chart](<#Chart>)
- [type Component](<#Component>)
- [type File](<#File>)
- [type FileContent](<#FileContent>)
- [type FileContentMap](<#FileContentMap>)
- [type FilePath](<#FilePath>)
- [type Generator](<#Generator>)
- [type Helm](<#Helm>)
- [type InternalLabel](<#InternalLabel>)
- [type Join](<#Join>)
- [type Kind](<#Kind>)
- [type Kustomization](<#Kustomization>)
- [type Kustomize](<#Kustomize>)
- [type Metadata](<#Metadata>)
- [type NameLabel](<#NameLabel>)
- [type Platform](<#Platform>)
- [type PlatformSpec](<#PlatformSpec>)
- [type Repository](<#Repository>)
- [type Resource](<#Resource>)
- [type Resources](<#Resources>)
- [type Transformer](<#Transformer>)
- [type Values](<#Values>)


<a name="Artifact"></a>
## type Artifact {#Artifact}

Artifact represents one fully rendered manifest produced by a [Transformer](<#Transformer>) sequence, which transforms a [Generator](<#Generator>) collection. A [BuildPlan](<#BuildPlan>) produces an [Artifact](<#Artifact>) collection.

Each Artifact produces one manifest file artifact. Generator Output values are used as Transformer Inputs. The Output field of the final [Transformer](<#Transformer>) should have the same value as the Artifact field.

When there is more than one [Generator](<#Generator>) there must be at least one [Transformer](<#Transformer>) to combine outputs into one Artifact. If there is a single Generator, it may directly produce the Artifact output.

An Artifact is processed concurrently with other artifacts in the same [BuildPlan](<#BuildPlan>). An Artifact should not use an output from another Artifact as an input. Each [Generator](<#Generator>) may also run concurrently. Each [Transformer](<#Transformer>) is executed sequentially starting after all generators have completed.

Output fields are write\-once. It is an error for multiple Generators or Transformers to produce the same Output value within the context of a [BuildPlan](<#BuildPlan>).

```go
type Artifact struct {
    Artifact     FilePath      `json:"artifact,omitempty"`
    Generators   []Generator   `json:"generators,omitempty"`
    Transformers []Transformer `json:"transformers,omitempty"`
    Skip         bool          `json:"skip,omitempty"`
}
```

<a name="BuildPlan"></a>
## type BuildPlan {#BuildPlan}

BuildPlan represents a build plan for holos to execute. Each [Platform](<#Platform>) component produces exactly one BuildPlan.

One or more [Artifact](<#Artifact>) files are produced by a BuildPlan, representing the fully rendered manifests for the Kubernetes API Server.

```go
type BuildPlan struct {
    // Kind represents the type of the resource.
    Kind string `json:"kind" cue:"\"BuildPlan\""`
    // APIVersion represents the versioned schema of the resource.
    APIVersion string `json:"apiVersion" cue:"string | *\"v1alpha4\""`
    // Metadata represents data about the resource such as the Name.
    Metadata Metadata `json:"metadata"`
    // Spec specifies the desired state of the resource.
    Spec BuildPlanSpec `json:"spec"`
}
```

<a name="BuildPlanSpec"></a>
## type BuildPlanSpec {#BuildPlanSpec}

BuildPlanSpec represents the specification of the [BuildPlan](<#BuildPlan>).

```go
type BuildPlanSpec struct {
    // Component represents the component that produced the build plan.
    // Represented as a path relative to the platform root.
    Component string `json:"component"`
    // Disabled causes the holos cli to disregard the build plan.
    Disabled bool `json:"disabled,omitempty"`
    // Artifacts represents the artifacts for holos to build.
    Artifacts []Artifact `json:"artifacts"`
}
```

<a name="Chart"></a>
## type Chart {#Chart}

Chart represents a [Helm](<#Helm>) Chart.

```go
type Chart struct {
    // Name represents the chart name.
    Name string `json:"name"`
    // Version represents the chart version.
    Version string `json:"version"`
    // Release represents the chart release when executing helm template.
    Release string `json:"release"`
    // Repository represents the repository to fetch the chart from.
    Repository Repository `json:"repository,omitempty"`
}
```

<a name="Component"></a>
## type Component {#Component}

Component represents the complete context necessary to produce a [BuildPlan](<#BuildPlan>) from a [Platform](<#Platform>) component.

All of these fields are passed to the holos render component command using flags, which in turn are injected to CUE using tags. Field names should be used consistently through the platform rendering process for readability.

```go
type Component struct {
    // Name represents the name of the component, injected as a tag to set the
    // BuildPlan metadata.name field.  Necessary for clear user feedback during
    // platform rendering.
    Name string `json:"name"`
    // Component represents the path of the component relative to the platform root.
    Component string `json:"component"`
    // Cluster is the cluster name to provide when rendering the component.
    Cluster string `json:"cluster"`
    // Environment for example, dev, test, stage, prod
    Environment string `json:"environment,omitempty"`
    // Model represents the platform model holos gets from from the
    // PlatformService.GetPlatform rpc method and provides to CUE using a tag.
    Model map[string]any `json:"model"`
    // Tags represents cue tags to inject when rendering the component.  The json
    // struct tag names of other fields in this struct are reserved tag names not
    // to be used in the tags collection.
    Tags []string `json:"tags,omitempty"`
}
```

<a name="File"></a>
## type File {#File}

File represents a simple single file copy [Generator](<#Generator>). Useful with a [Kustomize](<#Kustomize>) [Transformer](<#Transformer>) to process plain manifest files stored in the component directory. Multiple File generators may be used to transform multiple resources.

```go
type File struct {
    // Source represents a file sub-path relative to the component path.
    Source FilePath `json:"source"`
}
```

<a name="FileContent"></a>
## type FileContent {#FileContent}

FileContent represents file contents.

```go
type FileContent string
```

<a name="FileContentMap"></a>
## type FileContentMap {#FileContentMap}

FileContentMap represents a mapping of file paths to file contents.

```go
type FileContentMap map[FilePath]FileContent
```

<a name="FilePath"></a>
## type FilePath {#FilePath}

FilePath represents a file path.

```go
type FilePath string
```

<a name="Generator"></a>
## type Generator {#Generator}

Generator generates an intermediate manifest for a [Artifact](<#Artifact>).

Each Generator in a [Artifact](<#Artifact>) must have a distinct Output value for a [Transformer](<#Transformer>) to reference.

Refer to [Resources](<#Resources>), [Helm](<#Helm>), and [File](<#File>).

```go
type Generator struct {
    // Kind represents the kind of generator.  Must be Resources, Helm, or File.
    Kind string `json:"kind" cue:"\"Resources\" | \"Helm\" | \"File\""`
    // Output represents a file for a Transformer or Artifact to consume.
    Output FilePath `json:"output"`
    // Resources generator. Ignored unless kind is Resources.  Resources are
    // stored as a two level struct.  The top level key is the Kind of resource,
    // e.g. Namespace or Deployment.  The second level key is an arbitrary
    // InternalLabel.  The third level is a map[string]any representing the
    // Resource.
    Resources Resources `json:"resources,omitempty"`
    // Helm generator. Ignored unless kind is Helm.
    Helm Helm `json:"helm,omitempty"`
    // File generator. Ignored unless kind is File.
    File File `json:"file,omitempty"`
}
```

<a name="Helm"></a>
## type Helm {#Helm}

Helm represents a [Chart](<#Chart>) manifest [Generator](<#Generator>).

```go
type Helm struct {
    // Chart represents a helm chart to manage.
    Chart Chart `json:"chart"`
    // Values represents values for holos to marshal into values.yaml when
    // rendering the chart.
    Values Values `json:"values"`
    // EnableHooks enables helm hooks when executing the `helm template` command.
    EnableHooks bool `json:"enableHooks,omitempty"`
    // Namespace represents the helm namespace flag
    Namespace string `json:"namespace,omitempty"`
}
```

<a name="InternalLabel"></a>
## type InternalLabel {#InternalLabel}

InternalLabel is an arbitrary unique identifier internal to holos itself. The holos cli is expected to never write a InternalLabel value to rendered output files, therefore use a InternalLabel when the identifier must be unique and internal. Defined as a type for clarity and type checking.

```go
type InternalLabel string
```

<a name="Join"></a>
## type Join {#Join}

Join represents a [Join](<#Join>)\(https://pkg.go.dev/strings#Join\) [Transformer](<#Transformer>). Useful for the common case of combining the output of [Helm](<#Helm>) and [Resources](<#Resources>) [Generator](<#Generator>) into one [Artifact](<#Artifact>) when [Kustomize](<#Kustomize>) is otherwise unnecessary.

```go
type Join struct {
    Separator string `json:"separator" cue:"string | *\"---\\n\""`
}
```

<a name="Kind"></a>
## type Kind {#Kind}

Kind is a discriminator. Defined as a type for clarity and type checking.

```go
type Kind string
```

<a name="Kustomization"></a>
## type Kustomization {#Kustomization}

Kustomization represents a kustomization.yaml file for use with the [Kustomize](<#Kustomize>) [Transformer](<#Transformer>). Untyped to avoid tightly coupling holos to kubectl versions which was a problem for the Flux maintainers. Type checking is expected to happen in CUE against the kubectl version the user prefers.

```go
type Kustomization map[string]any
```

<a name="Kustomize"></a>
## type Kustomize {#Kustomize}

Kustomize represents a kustomization [Transformer](<#Transformer>).

```go
type Kustomize struct {
    // Kustomization represents the decoded kustomization.yaml file
    Kustomization Kustomization `json:"kustomization"`
    // Files holds file contents for kustomize, e.g. patch files.
    Files FileContentMap `json:"files,omitempty"`
}
```

<a name="Metadata"></a>
## type Metadata {#Metadata}

Metadata represents data about the resource such as the Name.

```go
type Metadata struct {
    // Name represents the resource name.
    Name string `json:"name"`
}
```

<a name="NameLabel"></a>
## type NameLabel {#NameLabel}

NameLabel is a unique identifier useful to convert a CUE struct to a list when the values have a Name field with a default value. NameLabel indicates the common use case of converting a struct to a list where the Name field of the value aligns with the outer struct field name.

For example:

```
Outer: [NAME=_]: Name: NAME
```

```go
type NameLabel string
```

<a name="Platform"></a>
## type Platform {#Platform}

Platform represents a platform to manage. A Platform resource informs holos which components to build. The platform resource also acts as a container for the platform model form values provided by the PlatformService. The primary use case is to collect the cluster names, cluster types, platform model, and holos components to build into one resource.

```go
type Platform struct {
    // Kind is a string value representing the resource.
    Kind string `json:"kind" cue:"\"Platform\""`
    // APIVersion represents the versioned schema of this resource.
    APIVersion string `json:"apiVersion" cue:"string | *\"v1alpha4\""`
    // Metadata represents data about the resource such as the Name.
    Metadata Metadata `json:"metadata"`

    // Spec represents the specification.
    Spec PlatformSpec `json:"spec"`
}
```

<a name="PlatformSpec"></a>
## type PlatformSpec {#PlatformSpec}

PlatformSpec represents the specification of a [Platform](<#Platform>). Think of a platform spec as a [Component](<#Component>) collection for multiple kubernetes clusters combined with the user\-specified Platform Model.

```go
type PlatformSpec struct {
    // Components represents a list of holos components to manage.
    Components []Component `json:"components"`
}
```

<a name="Repository"></a>
## type Repository {#Repository}

Repository represents a [Helm](<#Helm>) [Chart](<#Chart>) repository.

```go
type Repository struct {
    Name string `json:"name"`
    URL  string `json:"url"`
}
```

<a name="Resource"></a>
## type Resource {#Resource}

Resource represents one kubernetes api object.

```go
type Resource map[string]any
```

<a name="Resources"></a>
## type Resources {#Resources}

Resources represents a kubernetes resources [Generator](<#Generator>) from CUE.

```go
type Resources map[Kind]map[InternalLabel]Resource
```

<a name="Transformer"></a>
## type Transformer {#Transformer}

Transformer transforms [Generator](<#Generator>) manifests within a [Artifact](<#Artifact>).

```go
type Transformer struct {
    // Kind represents the kind of transformer. Must be Kustomize, or Join.
    Kind string `json:"kind" cue:"\"Kustomize\" | \"Join\""`
    // Inputs represents the files to transform. The Output of prior Generators
    // and Transformers.
    Inputs []FilePath `json:"inputs"`
    // Output represents a file for a subsequent Transformer or Artifact to
    // consume.
    Output FilePath `json:"output"`
    // Kustomize transformer. Ignored unless kind is Kustomize.
    Kustomize Kustomize `json:"kustomize,omitempty"`
    // Join transformer. Ignored unless kind is Join.
    Join Join `json:"join,omitempty"`
}
```

<a name="Values"></a>
## type Values {#Values}

Values represents [Helm](<#Helm>) Chart values generated from CUE.

```go
type Values map[string]any
```

Generated by [gomarkdoc](<https://github.com/princjef/gomarkdoc>)
