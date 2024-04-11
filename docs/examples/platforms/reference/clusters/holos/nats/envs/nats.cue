package holos

// for Project in _Projects {
// 	spec: components: resources: (#ProjectTemplate & {project: Project}).workload.resources
// }

spec: components: HelmChartList: [
	#HelmChart & {
		metadata: name: "jeff-holos-nats"
		namespace: "jeff-holos"
		_dependsOn: "prod-secrets-stores": _
		chart: {
			name:       "nats"
			version:    "1.1.10"
			repository: NatsRepository
		}
	},
	#HelmChart & {
		metadata: name: "jeff-holos-nack"
		namespace: "jeff-holos"
		_dependsOn: "jeff-holos-nats": _
		chart: {
			name:       "nack"
			version:    "0.25.2"
			repository: NatsRepository
		}
	},
]

let NatsRepository = {
	name: "nats"
	url:  "https://nats-io.github.io/k8s/helm/charts/"
}
