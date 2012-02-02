div id: 'container', ->
	div id: 'menu', ->
		a href: "/", -> 'Home'
		a href:"#", -> 'Billing'
		a href: "#", -> 'DNS'
	div id: 'manageMenu', -> 
		a href: "start", -> 'Start'
		a href: "stop", -> 'Stop'
		a href: "redeploy", -> 'Redeploy'
	div ->
		@kvm.hostname
