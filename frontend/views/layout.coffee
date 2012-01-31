doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "My awesome website"
		link rel: 'stylesheet', href: '/stylesheets/app.css'
		style '''
			body {font-family: sans-serif}
			header, nav, section, footer {display: block}
		'''
	body ->
		div id: 'container', ->
			@body
