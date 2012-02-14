script '''
function checkPasswords() {
if(document.getElementById('password1').value == document.getElementById('password2').value)
	document.getElementById('formsubmit').disabled = false;
else
	document.getElementById('formsubmit').disabled = true;
}
'''

div id: 'container', ->
	form action: '', method: 'post', ->
		div ->
			p "Name"
			input name: 'name'
		div ->
			p "Email address"
			input name: 'email'
		div ->
			p "Password"
			input type: "password", name: 'password1', id: 'password1', onblue: 'checkPasswords()'
		div ->
			p "Password (again)"
			input type: "password", name: 'password2', id: 'password2', onblur: 'checkPasswords()'
		div ->
			input type: "submit", id: 'formsubmit', disabled: true
