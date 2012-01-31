script ->
	'''
	function emailField(obj) {
		obj.value = '';
	}
	
	function passwordField(obj) {
		obj.value = '';
		obj.type = 'password';
	}'''

div id: "loginBox", ->
	'''<form action='/auth' method='post'>
		<input name='username' onfocus='emailField(this)' value="email@address.com">
		<input name='password' onfocus='passwordField(this)' value="password">
		<input type='submit' value='Login'>
	</form>'''
