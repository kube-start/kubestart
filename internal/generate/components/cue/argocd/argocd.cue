package holos

// Produce a kubectl kustomize build plan.
(#Kustomize & {Name: "{{ .Name }}"}).BuildPlan
