package holos

// Copy this file to platform.site.cue and specify concrete values for your local site.
#Platform: org: {
	name:   string | *"example"
	domain: string | *"example.com"
}
