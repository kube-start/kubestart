package holos

import corev1 "k8s.io/api/core/v1"

let Objects = {
	Name:      "{{ .Name }}"
	Namespace: "{{ .Namespace }}"

	Resources: {
		for ns in _Namespaces {
			Namespace: "\(ns.name)": corev1.#Namespace
		}
	}
}

// Produce a kubernetes objects build plan.
(#Kubernetes & Objects).Output
