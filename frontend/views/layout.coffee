doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "#{@title} - Dash"
		link rel: 'stylesheet', href: '/reset.css'
		link rel: 'stylesheet', href: '/style.css'
	body ->
		@body
