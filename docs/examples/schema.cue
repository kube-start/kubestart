package holos

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	ksv1 "kustomize.toolkit.fluxcd.io/kustomization/v1"
	corev1 "k8s.io/api/core/v1"
	rbacv1 "k8s.io/api/rbac/v1"
	es "external-secrets.io/externalsecret/v1beta1"
	ss "external-secrets.io/secretstore/v1beta1"
	"encoding/yaml"
)

_apiVersion: "holos.run/v1alpha1"

// #Name defines the name: string key value pair used all over the place.
#Name: name: string

// #TargetNamespace is the target namespace for a holos component.
#TargetNamespace: string

// #InstanceName is the name of the holos component instance being managed varying by stage, project, and component names.
#InstanceName: "\(#InputKeys.stage)-\(#InputKeys.project)-\(#InputKeys.component)"

// #InstancePrefix is the stage and project without the component name.  Useful for dependency management among multiple components for a project stage.
#InstancePrefix: "\(#InputKeys.stage)-\(#InputKeys.project)"

// TypeMeta indicates a kubernetes api object
#TypeMeta: metav1.#TypeMeta

// #CommonLabels are mixed into every kubernetes api object.
#CommonLabels: {
	"holos.run/stage.name":     #InputKeys.stage
	"holos.run/project.name":   #InputKeys.project
	"holos.run/component.name": #InputKeys.component
	...
}

#ClusterObject: {
	metadata: metav1.#ObjectMeta & {
		labels: #CommonLabels
	}
	...
}

#NamespaceObject: #ClusterObject & {
	metadata: namespace: string
}

// Kubernetes API Objects
#Namespace: corev1.#Namespace & #ClusterObject & {
	metadata: {
		name: string
		labels: "kubernetes.io/metadata.name": name
	}
}
#ClusterRole:        #ClusterObject & rbacv1.#ClusterRole
#ClusterRoleBinding: #ClusterObject & rbacv1.#ClusterRoleBinding
#ConfigMap:          #NamespaceObject & corev1.#ConfigMap
#ServiceAccount:     #NamespaceObject & corev1.#ServiceAccount
#Role:               #NamespaceObject & rbacv1.#Role
#RoleBinding:        #NamespaceObject & rbacv1.#RoleBinding

// Flux Kustomization CRDs
#Kustomization: #NamespaceObject & ksv1.#Kustomization & {
	metadata: {
		name:      #InstanceName
		namespace: string | *"flux-system"
	}
	spec: ksv1.#KustomizationSpec & {
		interval:      string | *"30m0s"
		path:          string | *"deploy/clusters/\(#InputKeys.cluster)/components/\(#InstanceName)"
		prune:         bool | *true
		retryInterval: string | *"2m0s"
		sourceRef: {
			kind: string | *"GitRepository"
			name: string | *"flux-system"
		}
		timeout: string | *"3m0s"
		wait:    bool | *true
	}
}

// External Secrets CRDs
#ExternalSecret: #NamespaceObject & es.#ExternalSecret & {
	_name: string
	metadata: {
		namespace: string | *"default"
		name:      _name
	}
	spec: {
		refreshInterval: string | *"1h"
		secretStoreRef: {
			kind: string | *"SecretStore"
			name: string | *"default"
		}
		target: {
			creationPolicy: string | *"Owner"
		}
	}
}

#SecretStore: #NamespaceObject & ss.#SecretStore & {
	metadata: {
		name:      string | *"default"
		namespace: string | *#TargetNamespace
	}
	spec: provider: {
		vault: {
			auth: kubernetes: {
				mountPath: #InputKeys.cluster
				role:      string | *"default"
				serviceAccountRef: name: string | *"default"
			}
			path:    string | *"kv/k8s"
			server:  "https://vault.core." + #Platform.org.domain
			version: string | *"v2"
		}
	}
}

// #InputKeys defines the set of cue tags required to build a cue holos component. The values are used as lookup keys into the #Platform data.
#InputKeys: {
	// cluster is usually the only key necessary when working with a component on the command line.
	cluster: string @tag(cluster, type=string)
	// stage is usually set by the platform or project.
	stage: *"prod" | string @tag(stage, type=string)
	// project is usually set by the platform or project.
	project: string @tag(project, type=string)
	// service is usually set by the component.
	service: string @tag(service, type=string)
	// component is the name of the component
	component: string @tag(component, type=string)

	// GCP Project Info used for the Provisioner Cluster
	gcpProjectID:     string @tag(gcpProjectID, type=string)
	gcpProjectNumber: string @tag(gcpProjectNumber, type=string)
}

// #Platform defines the primary lookup table for the platform.  Lookup keys should be limited to those defined in #KeyTags.
#Platform: {
	// org holds user defined values scoped organization wide.  A platform has one and only one organization.
	org: {
		name:   string
		domain: string
	}
	clusters: [ID=_]: {
		name:    string & ID
		region?: string
	}
	stages: [ID=_]: {
		name: string & ID
		environments: [...#Name]
	}
	projects: [ID=_]: {
		name: string & ID
	}
	services: [ID=_]: {
		name: string & ID
	}
}

// #OutputTypeMeta is shared among all output types
#OutputTypeMeta: {
	// apiVersion is the output api version
	apiVersion: _apiVersion
	// kind is a discriminator of the type of output
	kind: #PlatformSpec.kind | #KubernetesObjects.kind | #HelmChart.kind
	// name holds a unique name suitable for a filename
	metadata: name: string
	// contentType is the standard MIME type indicating the content type of the content field
	contentType: *"application/yaml" | "application/json"
	// content holds the content text output
	content: string | *""
	// debug returns arbitrary debug output.
	debug?: _
}

// #KubernetesObjectOutput is the output schema of a single component.
#KubernetesObjects: {
	#OutputTypeMeta

	// kind KubernetesObjects provides a yaml text stream of kubernetes api objects in the out field.
	kind: "KubernetesObjects"
	// objects holds a list of the kubernetes api objects to configure.
	objects: [...metav1.#TypeMeta] | *[]
	// out holds the rendered yaml text stream of kubernetes api objects.
	content: yaml.MarshalStream(objects)
	// ksObjects holds the flux Kustomization objects for gitops
	ksObjects: [...#Kustomization] | *[#Kustomization]
	// ksContent is the yaml representation of kustomization
	ksContent: yaml.MarshalStream(ksObjects)
	// platform returns the platform data structure for visibility / troubleshooting.
	platform: #Platform
}

// #Chart defines an upstream helm chart
#Chart: {
	name:    string
	version: string
	repository: {
		name: string
		url:  string
	}
}

// #HelmChart is a holos component which produces kubernetes api objects from cue values provided to the helm template command.
#HelmChart: {
	#OutputTypeMeta
	kind: "HelmChart"
	// ksObjects holds the flux Kustomization objects for gitops.
	ksObjects: [...#Kustomization] | *[#Kustomization]
	// ksContent is the yaml representation of kustomization.
	ksContent: yaml.MarshalStream(ksObjects)
	// namespace defines the value passed to the helm --namespace flag
	namespace: #TargetNamespace
	// chart defines the upstream helm chart to process.
	chart: #Chart
	// values represents the helm values to provide to the chart.
	values: {...}
	// valuesContent holds the values yaml
	valuesContent: yaml.Marshal(values)
	// platform returns the platform data structure for visibility / troubleshooting.
	platform: #Platform
	// instance returns the key values of the holos component instance.
	instance: #InputKeys
}

// #PlatformSpec is the output schema of a platform specification.
#PlatformSpec: {
	#OutputTypeMeta
	kind: "PlatformSpec"
}

#Output: #PlatformSpec | #KubernetesObjects | #HelmChart

// Holos component name
metadata: name: #InstanceName
