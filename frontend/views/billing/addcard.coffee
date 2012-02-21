div ->
	h1 -> "Add a credit card"
	form action:'', method: 'post', id: 'orderForm', ->
		div class: 'fieldContainer', ->
			input class: 'textInput', name: 'ccnumber', maxlength: '16', id: 'ccnumber'
			label for: 'ccnumber', -> "Card number"
		div class: 'fieldContainer', ->
			input class: 'textInput', name: 'expmonth', maxlength: '2', id: 'expmonth'
			label for: 'expmonth', -> "Exp. month (##)"
		div class: 'fieldContainer', ->
			input class: 'textInput', name: 'expyear', maxlength: '4', id: 'expyear'
			label for: 'expyear', -> "Exp. year (####)"
		div class: 'fieldContainer', ->
			input class: 'textInput', name: 'cvc', maxlength: '6', id: 'cvc'
			label for: 'cvc', -> "CVC"

		input type: 'submit', class: 'submitButton', value: "Vroom!"
