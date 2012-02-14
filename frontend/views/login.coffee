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
		script ->
			"
			function clearValue(obj) {
				obj.value = '';
			}
			"

		div id: "loginBox", ->
			'''
			<div id='topBar'><h1 class='logo'>dash</h1></div>
			<form action='/auth' method='post'>
				<input name='username' onfocus='clearValue(this)' value='email@address.com'>
				<input name='password' type='password' onfocus='clearValue(this)' value='password'>
				<input class='submitButton' type='submit' value='Login'>
			</form>
			'''
