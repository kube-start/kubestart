package holos

import "encoding/yaml"

// Produce a kubernetes objects build plan.
(#Kubernetes & Objects).BuildPlan

let ContainerPort = _Component.spec.port

let Objects = {
	Name:      "\(_Component.metadata.name)-backend"
	Namespace: _Component.metadata.namespace

	Resources: [_]: [_]: metadata: namespace: Namespace

	let MatchLabels = {
		"app.kubernetes.io/name":      _Component.metadata.name
		"app.kubernetes.io/instance":  _Component.metadata.name
		"app.kubernetes.io/component": Name
	}

	Resources: {
		// Grant the Gateway ns the ability to refer to the Service from HTTPRoutes.
		ReferenceGrant: (#IstioGatewaysNamespace): #ReferenceGrant

		// For the Github integration.
		ExternalSecret: [_]: #ExternalSecret & {metadata: namespace: Namespace}
		ExternalSecret: githubAppCredentials: metadata: name: "github-app-credentials"

		// Primary configuration for backstage to pull unified config data.
		ConfigMap: config: {
			metadata: namespace: Namespace
			metadata: name:      Name
			data: {
				"app-config.yaml":            yaml.Marshal(_BackstageAppConfig)
				"app-config.production.yaml": yaml.Marshal(_BackstageProductionConfig)
				"iam.yaml": yaml.MarshalStream([for x in _BackstageIAMConfig {x}])
			}
		}

		Deployment: backstage: {
			metadata: labels: MatchLabels
			spec: {
				selector: matchLabels: MatchLabels

				template: {
					metadata: labels: "sidecar.istio.io/inject": "true"
					metadata: labels: MatchLabels
					spec: {
						securityContext: seccompProfile: type: "RuntimeDefault"
						serviceAccountName: "default"
						containers: [{
							name:            "backstage-backend"
							image:           "quay.io/holos-run/portal:latest"
							imagePullPolicy: "Always"
							// https://github.com/backstage/backstage/blob/v1.27.6/packages/create-app/templates/default-app/packages/backend/Dockerfile#L52
							command: [
								"node",
								"packages/backend",
								"--config",
								"/config/app-config.yaml",
								"--config",
								"/config/app-config.production.yaml",
							]
							// Refer to https://backstage.io/docs/conf/writing#environment-variable-overrides
							//
							// Individual configuration values can be overridden using
							// environment variables prefixed with APP_CONFIG_. Everything
							// following that prefix in the environment variable name will be
							// used as the config key, with _ replaced by .. For example, to
							// override the app.baseUrl value, set the APP_CONFIG_app_baseUrl
							// environment variable to the desired value.
							//
							// The value of the environment variable is parsed as JSON, but it will fall back
							// to being interpreted as a string if it fails to parse. Note that if you for
							// example want to pass on the string "false", you need to wrap it in double
							// quotes, e.g. export APP_CONFIG_example='"false"'.
							env: [
								{
									name:  "BASE_URL"
									value: "https://" + _Component.spec.hostname
								},
								{
									name:  "ORG_DOMAIN"
									value: _Platform.Model.org.domain
								},
								{
									name: "POSTGRES_HOST"
									valueFrom: secretKeyRef: {
										name:     "\(_DBName)-pguser-\(_DBName)-admin"
										key:      "pgbouncer-host"
										optional: false
									}
								},
								{
									name: "POSTGRES_PORT"
									valueFrom: secretKeyRef: {
										name:     "\(_DBName)-pguser-\(_DBName)-admin"
										key:      "pgbouncer-port"
										optional: false
									}
								},
								{
									name: "POSTGRES_USER"
									valueFrom: secretKeyRef: {
										name:     "\(_DBName)-pguser-\(_DBName)-admin"
										key:      "user"
										optional: false
									}
								},
								{
									name: "POSTGRES_PASSWORD"
									valueFrom: secretKeyRef: {
										name:     "\(_DBName)-pguser-\(_DBName)-admin"
										key:      "password"
										optional: false
									}
								},
								{
									name: "PGBOUNCER_CA_ROOT"
									valueFrom: secretKeyRef: {
										name:     "\(_DBName)-pgbouncer"
										key:      "pgbouncer-frontend.ca-roots"
										optional: false
									}
								},
							]
							ports: [{
								name:          "backend"
								containerPort: ContainerPort
								protocol:      "TCP"
							}]
							volumeMounts: [
								{
									name:      "config"
									mountPath: "/config"
								},
								{
									name:      "github-app-credentials"
									mountPath: "/secrets/github-app-credentials"
								},
							]
						}]
						volumes: [
							{
								name: "config"
								configMap: name: ConfigMap.config.metadata.name
							},
							{
								name: "github-app-credentials"
								secret: secretName: ExternalSecret.githubAppCredentials.metadata.name
							},
						]
					}
				}
			}
		}

		Service: backstage: {
			metadata: labels: MatchLabels
			spec: {
				selector: MatchLabels
				_ports: http: {
					port:       ContainerPort
					targetPort: ContainerPort
					protocol:   "TCP"
					name:       "http"
				}
				ports: [for x in _ports {x}]
			}
		}
	}
}
