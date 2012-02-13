doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "#{@title} - Dash"
		link rel: 'stylesheet', href: '/reset.css'
		link rel: 'stylesheet', href: '/style.css'
		link rel: 'stylesheet', href: '/fonts/functioncaps_medium_macroman/stylesheet.css'
		link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=Lato'
	body ->
		@body
