package holos

#TargetNamespace: "default"

#InputKeys: {
	project:   "secrets"
	component: "namespaces"
}

// #PlatformNamespaceObjects defines the api objects necessary for eso SecretStores in external clusters to access secrets in a given namespace in the provisioner cluster.
#PlatformNamespaceObjects: {
	_ns: #PlatformNamespace

	objects: [
		#Namespace & {
			metadata: name: _ns.name
		},
	]
}

#KubernetesObjects & {
	apiObjects: {
		for ns in #PlatformNamespaces {
			for obj in (#PlatformNamespaceObjects & {_ns: ns}).objects {
				let Kind = obj.kind
				let Name = obj.metadata.name
				"\(Kind)": "\(Name)": obj
			}
		}
	}
}
