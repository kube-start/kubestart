package holos

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	ksv1 "kustomize.toolkit.fluxcd.io/kustomization/v1"
	corev1 "k8s.io/api/core/v1"
	rbacv1 "k8s.io/api/rbac/v1"
	batchv1 "k8s.io/api/batch/v1"
	es "external-secrets.io/externalsecret/v1beta1"
	ss "external-secrets.io/secretstore/v1beta1"
	"encoding/yaml"
)

// #ClusterName is the cluster name for cluster scoped resources.
#ClusterName: #InputKeys.cluster

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
#Role:               #NamespaceObject & rbacv1.#Role
#RoleBinding:        #NamespaceObject & rbacv1.#RoleBinding
#ConfigMap:          #NamespaceObject & corev1.#ConfigMap
#ServiceAccount:     #NamespaceObject & corev1.#ServiceAccount
#Pod:                #NamespaceObject & corev1.#Pod
#Job:                #NamespaceObject & batchv1.#Job
#CronJob:            #NamespaceObject & batchv1.#CronJob

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
		suspend?:         bool
		targetNamespace?: string
		timeout:          string | *"3m0s"
		wait:             bool | *true
	}
}

// External Secrets CRDs
#ExternalSecret: #NamespaceObject & es.#ExternalSecret & {
	_name: string
	metadata: {
		namespace: #TargetNamespace
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
		data: [{
			remoteRef: key: _name
			secretKey: _name
		}]
	}
}

#SecretStore: #NamespaceObject & ss.#SecretStore & {
	metadata: {
		name:      string | *"default"
		namespace: #TargetNamespace
	}
	spec: provider: {
		kubernetes: {
			remoteNamespace: #TargetNamespace
			auth: token: bearerToken: {
				name: string | *"eso-reader"
				key:  string | *"token"
			}
			server: {
				caBundle: #InputKeys.provisionerCABundle
				url:      #InputKeys.provisionerURL
			}
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
	gcpProjectNumber: int    @tag(gcpProjectNumber, type=int)

	// Same as cluster certificate-authority-data field in ~/.holos/kubeconfig.provisioner
	provisionerCABundle: string @tag(provisionerCABundle, type=string)
	// Same as the cluster server field in ~/.holos/kubeconfig.provisioner
	provisionerURL: string @tag(provisionerURL, type=string)
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
	// content holds the rendered yaml text stream of kubernetes api objects.
	content:     yaml.MarshalStream(objects)
	contentType: "application/yaml"
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

// #ChartValues represent the values provided to a helm chart.  Existing values may be imorted using cue import values.yaml -p holos then wrapping the values.cue content in #Values: {}
#ChartValues: {...}

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
	values: #ChartValues
	// valuesContent holds the values yaml
	valuesContent: yaml.Marshal(values)
	// platform returns the platform data structure for visibility / troubleshooting.
	platform: #Platform
	// instance returns the key values of the holos component instance.
	instance: #InputKeys
	// objects holds a list of the kubernetes api objects to configure.
	objects: [...metav1.#TypeMeta] | *[]
	// content holds the rendered yaml text stream of kubernetes api objects.
	content:     yaml.MarshalStream(objects)
	contentType: "application/yaml"
}

// #PlatformSpec is the output schema of a platform specification.
#PlatformSpec: {
	#OutputTypeMeta
	kind: "PlatformSpec"
}

#Output: #PlatformSpec | #KubernetesObjects | #HelmChart

// Holos component name
metadata: name: #InstanceName

// #SecretName is the name of a Secret, ususally coupling a Deployment to an ExternalSecret
#SecretName: string
