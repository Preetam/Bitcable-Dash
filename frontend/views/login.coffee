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
