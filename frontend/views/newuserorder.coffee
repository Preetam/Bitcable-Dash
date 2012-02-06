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
			p "Plan: "
			select name: "plan", ->
				option value: "tera", -> "Tera"
				option value: "peta", -> "Peta"
				option value: "exa", -> "Exa"
				option value: "zetta", -> "Zetta"
				option value: "yotta", -> "Yotta"
		div ->
			p "Address 1"
			input name: 'address_line1'
			p "Address 2"
			input name: 'address_line2'
			p "City"
			input name: 'city'
			p "State"
			input name: 'state'
			p "ZIP / Postal code"
			input name: 'zip'
			p "Country"
			input name: 'country'
		div ->
			p "Credit card number"
			input name: 'ccnum', maxlength: '16'
			p "CVC"
			input name: 'cvc'
			p "Exp month"
			select name: 'exp_month', ->
				for i in [1..12]
					option i
			p "Exp year"
			select name: 'exp_year', ->
				for i in [2012..2020]
					option i
		div ->
			input type: "submit", id: 'formsubmit', disabled: true
