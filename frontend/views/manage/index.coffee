div ->
	h1 "Manage #{@kvm.hostname}"
	div id: "vmControls", ->
		a href: 'start', "Start"
		a href: 'stop', "Stop"
		a href: 'console', "Console"
