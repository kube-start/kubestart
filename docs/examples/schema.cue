package holos

import "strings"

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	rbacv1 "k8s.io/api/rbac/v1"
	batchv1 "k8s.io/api/batch/v1"
	es "external-secrets.io/externalsecret/v1beta1"
	ss "external-secrets.io/secretstore/v1beta1"
	is "cert-manager.io/issuer/v1"
	ci "cert-manager.io/clusterissuer/v1"
	crt "cert-manager.io/certificate/v1"
	gw "networking.istio.io/gateway/v1beta1"
	vs "networking.istio.io/virtualservice/v1beta1"
	ra "security.istio.io/requestauthentication/v1"
	ap "security.istio.io/authorizationpolicy/v1"
	pg "postgres-operator.crunchydata.com/postgrescluster/v1beta1"
)

// _apiVersion is the version of this schema.  Defines the interface between CUE output and the holos cli.
_apiVersion: "holos.run/v1alpha1"

// #ComponentName is the name of the holos component.
// TODO: Refactor to support multiple components per BuildPlan
#ComponentName: #InputKeys.component

// #StageName is prod, dev, stage, etc...  Usually prod for platform components.
#StageName: #InputKeys.stage

// #TargetNamespace is the target namespace for a holos component.
#TargetNamespace: string

#ClusterObject: {
	_description: string | *""
	metadata: metav1.#ObjectMeta & {
		// labels: #CommonLabels
		annotations: #Description & {
			_Description: _description
			...
		}
	}
	...
}

#Description: {
	_Description:            string | *""
	"holos.run/description": _Description
	...
}

#NamespaceObject: #ClusterObject & {
	metadata: name:      string
	metadata: namespace: string
	...
}

// Kubernetes API Objects
#Namespace: corev1.#Namespace & {
	metadata: name: string
	metadata: labels: "kubernetes.io/metadata.name": metadata.name
}

#ClusterRole:        #ClusterObject & rbacv1.#ClusterRole
#ClusterRoleBinding: #ClusterObject & rbacv1.#ClusterRoleBinding
#ClusterIssuer: #ClusterObject & ci.#ClusterIssuer & {...}

#Issuer:                #NamespaceObject & is.#Issuer
#Role:                  #NamespaceObject & rbacv1.#Role
#RoleBinding:           #NamespaceObject & rbacv1.#RoleBinding
#ConfigMap:             #NamespaceObject & corev1.#ConfigMap
#ServiceAccount:        #NamespaceObject & corev1.#ServiceAccount
#Pod:                   #NamespaceObject & corev1.#Pod
#Service:               #NamespaceObject & corev1.#Service
#Job:                   #NamespaceObject & batchv1.#Job
#CronJob:               #NamespaceObject & batchv1.#CronJob
#Deployment:            #NamespaceObject & appsv1.#Deployment
#VirtualService:        #NamespaceObject & vs.#VirtualService
#RequestAuthentication: #NamespaceObject & ra.#RequestAuthentication
#AuthorizationPolicy:   #NamespaceObject & ap.#AuthorizationPolicy
#Certificate:           #NamespaceObject & crt.#Certificate
#PostgresCluster:       #NamespaceObject & pg.#PostgresCluster

#Gateway: #NamespaceObject & gw.#Gateway & {
	metadata: namespace: string | *"istio-ingress"
	spec: selector: istio: string | *"ingressgateway"
}

// #HTTP01Cert defines a http01 certificate.
#HTTP01Cert: {
	_name:      string
	_secret:    string | *_name
	SecretName: _secret
	Host:       _name + "." + #ClusterDomain
	object: #Certificate & {
		metadata: {
			name:      _secret
			namespace: string | *#TargetNamespace
		}
		spec: {
			commonName: Host
			dnsNames: [Host]
			secretName: _secret
			issuerRef: kind: "ClusterIssuer"
			issuerRef: name: "letsencrypt"
		}
	}
}

// External Secrets CRDs
#ExternalSecret: #NamespaceObject & es.#ExternalSecret & {
	_name: string
	metadata: {
		name:      _name
		namespace: string | *#TargetNamespace
	}
	spec: {
		refreshInterval: string | *"1h"
		secretStoreRef: {
			kind: string | *"SecretStore"
			name: string | *"default"
		}
		target: {
			name:           _name
			creationPolicy: string | *"Owner"
			deletionPolicy: string | *"Retain"
		}
		// Copy fields 1:1 from external Secret to target Secret.
		dataFrom: [{extract: key: _name}]
	}
}

#SecretStore: #NamespaceObject & ss.#SecretStore & {
	_namespace: string
	metadata: {
		name:      string | *"default"
		namespace: _namespace
	}
	spec: provider: {
		kubernetes: {
			remoteNamespace: _namespace
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
	// service is usually set by the component.
	service: *component | string @tag(service, type=string)
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

// #ClusterSpec is the specification of a holos platform cluster member.
#ClusterSpec: {
	// name is the cluster name.
	name: string
	// pool is the optional ceph pool of the cluster.
	pool?: string
	// region is the geographic region of the cluster.
	region?: string
	// primary is true if the cluster is the primary cluster among a group of related clusters.
	primary: bool
}

// #Platform defines the primary lookup table for the platform.  Lookup keys should be limited to those defined in #KeyTags.
#Platform: {
	// org holds user defined values scoped organization wide.  A platform has one and only one organization.
	org: {
		// e.g. "example"
		name: string
		// e.g. "example.com"
		domain: string
		// e.g. "example.com"
		emailDomain: string | *domain
		// e.g. "Example"
		displayName: string
		// e.g. "platform@example.com"
		contact: email: string
		// e.g. "platform@example.com"
		cloudflare: email: string
		// e.g. "example"
		github: orgs: primary: name: string
	}
	// Only one cluster may be primary at a time.  All others are standby.
	// Refer to [repo based standby](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/backups-disaster-recovery/disaster-recovery#repo-based-standby)
	primaryCluster: {
		name: string
	}
	clusters: [Name=_]: #ClusterSpec & {
		name: string & Name
		if Name == primaryCluster.name {
			primary: true
		}
		if Name != primaryCluster.name {
			primary: false
		}
	}
	// TODO: Remove stages, they're in the subdomain of projects.
	stages: [ID=_]: {
		name: string & ID
		environments: [...{name: string}]
	}
	projects: [ID=_]: {
		name: string & ID
	}
	// TODO: Remove services, they're in the subdomain of projects.
	services: [ID=_]: {
		name: string & ID
	}

	// authproxy configures the auth proxy attached to the default ingress gateway in the istio-ingress namespace.
	authproxy: #AuthProxySpec & {
		namespace: "istio-ingress"
		provider:  "ingressauth"
	}

	oauthClients: [Name=_]: #OAuthClientSpec & {name: Name}
}

#OAuthClientSpec: {
	name:      string
	orgDomain: string | *#Platform.org.emailDomain
	spec: {
		issuer:   string | *"https://login.\(#Platform.org.domain)"
		clientID: string | *name
		scopes:   string | *strings.Join(scopesList, " ")
		scopesList: ["openid", "profile", "email", "groups", "urn:zitadel:iam:org:domain:primary:\(orgDomain)"]
		jwks_uri:               string | *"\(issuer)/oauth/v2/keys"
		authorization_endpoint: string | *"\(issuer)/oauth/v2/authorize"
		token_endpoint:         string | *"\(issuer)/oauth/v2/token"
		introspection_endpoint: string | *"\(issuer)/oauth/v2/introspect"
		userinfo_endpoint:      string | *"\(issuer)/oauth/v1/userinfo"
		revocation_endpoint:    string | *"\(issuer)/oauth/v2/revoke"
		end_session_endpoint:   string | *"\(issuer)/oauth/v1/end_session"
	}
}

#AuthProxySpec: {
	// projectID is the zitadel project resource id.
	projectID: number
	// clientID is the zitadel application client id.
	clientID: string
	// namespace is the namespace
	namespace: string
	// provider is the istio extension provider name in the mesh config.
	provider: string
	// orgDomain is the zitadel organization domain for logins.
	orgDomain: string | *#Platform.org.domain
	// issuerHost is the Host: header value of the oidc issuer
	issuerHost: string | *"login.\(#Platform.org.domain)"
	// issuer is the oidc identity provider issuer url
	issuer: string | *"https://\(issuerHost)"
	// path is the oauth2-proxy --proxy-prefix value.  The default callback url is the Host: value with a path of /holos/oidc/callback
	proxyPrefix: string | *"/holos/authproxy/\(namespace)"
	// idTokenHeader represents the header where the id token is placed
	idTokenHeader: string | *"x-oidc-id-token"
}

// #Backups defines backup configuration.
// TODO: Consider the best place for this, possibly as part of the site platform config.  This represents the primary location for backups.
#Backups: {
	s3: {
		region:   string
		endpoint: string | *"s3.dualstack.\(region).amazonaws.com"
	}
}

// #Chart defines an upstream helm chart
#Chart: {
	name:    string
	version: string
	release: string | *name
	repository: {
		name?: string
		url?:  string
	}
}

// #ChartValues represent the values provided to a helm chart.  Existing values may be imorted using cue import values.yaml -p holos then wrapping the values.cue content in #Values: {}
#ChartValues: {...}

// #SecretName is the name of a Secret, ususally coupling a Deployment to an ExternalSecret
#SecretName: string

// Cluster Domain is the cluster specific domain
#ClusterDomain: #InputKeys.cluster + "." + #Platform.org.domain

// #SidecarInject represents the istio sidecar inject label
#IstioSidecar: {
	"sidecar.istio.io/inject": "true"
	...
}

// #DefaultSecurityContext is the holos default security context to comply with the restricted namespace policy.
// Refer to https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted
#DefaultSecurityContext: {
	securityContext: {
		allowPrivilegeEscalation: false
		runAsNonRoot:             true
		capabilities: drop: ["ALL"]
		seccompProfile: type: "RuntimeDefault"
	}
	...
}

// Certificate name should always match the secret name.
#Certificate: {
	metadata: name:   _
	spec: secretName: metadata.name
}

// #IsPrimaryCluster is true if the cluster being rendered is the primary cluster
// Used by the iam project to determine where https://login.example.com is active.
#IsPrimaryCluster: bool & #ClusterName == #Platform.primaryCluster.name

// #GatewayServer defines the value of the istio Gateway.spec.servers field.
#GatewayServer: {
	// The ip or the Unix domain socket to which the listener should
	// be bound to.
	bind?:            string
	defaultEndpoint?: string

	// One or more hosts exposed by this gateway.
	hosts: [...string]

	// An optional name of the server, when set must be unique across
	// all servers.
	name?: string

	// The Port on which the proxy should listen for incoming
	// connections.
	port: {
		// Label assigned to the port.
		name: string

		// A valid non-negative integer port number.
		number: int

		// The protocol exposed on the port.
		protocol:    string
		targetPort?: int
	}

	// Set of TLS related options that govern the server's behavior.
	tls?: {
		// REQUIRED if mode is `MUTUAL` or `OPTIONAL_MUTUAL`.
		caCertificates?: string

		// Optional: If specified, only support the specified cipher list.
		cipherSuites?: [...string]

		// For gateways running on Kubernetes, the name of the secret that
		// holds the TLS certs including the CA certificates.
		credentialName?: string

		// If set to true, the load balancer will send a 301 redirect for
		// all http connections, asking the clients to use HTTPS.
		httpsRedirect?: bool

		// Optional: Maximum TLS protocol version.
		maxProtocolVersion?: "TLS_AUTO" | "TLSV1_0" | "TLSV1_1" | "TLSV1_2" | "TLSV1_3"

		// Optional: Minimum TLS protocol version.
		minProtocolVersion?: "TLS_AUTO" | "TLSV1_0" | "TLSV1_1" | "TLSV1_2" | "TLSV1_3"

		// Optional: Indicates whether connections to this port should be
		// secured using TLS.
		mode?: "PASSTHROUGH" | "SIMPLE" | "MUTUAL" | "AUTO_PASSTHROUGH" | "ISTIO_MUTUAL" | "OPTIONAL_MUTUAL"

		// REQUIRED if mode is `SIMPLE` or `MUTUAL`.
		privateKey?: string

		// REQUIRED if mode is `SIMPLE` or `MUTUAL`.
		serverCertificate?: string

		// A list of alternate names to verify the subject identity in the
		// certificate presented by the client.
		subjectAltNames?: [...string]

		// An optional list of hex-encoded SHA-256 hashes of the
		// authorized client certificates.
		verifyCertificateHash?: [...string]

		// An optional list of base64-encoded SHA-256 hashes of the SPKIs
		// of authorized client certificates.
		verifyCertificateSpki?: [...string]
	}
}
