doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "#{@title} - Dash"
		link rel: 'stylesheet', href: '/reset.css'
		link rel: 'stylesheet', href: '/style.css'
		link rel: 'stylesheet', href: '/fonts/functioncaps_medium_macroman/stylesheet.css'
		link rel: 'stylesheet', href: 'https://fonts.googleapis.com/css?family=Lato'
	body ->
		if @error
			div id: 'error', @error
		div id: 'container', ->
			div id: 'topBar', ->
				h1 class: 'logo', -> a href: '/', -> "dash"
				if @menu isnt false
					div id: 'topMenu', ->
						a href: '/billing/', -> 'Billing'
						a href: '#', -> 'DNS'
			div id: 'content', ->
				@body
