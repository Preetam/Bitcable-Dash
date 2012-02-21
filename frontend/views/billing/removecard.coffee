div ->
	h1 -> "Remove your credit card"
	form action:'', method: 'post', id: 'orderForm', ->
		input type: 'submit', class: 'submitButton', value: "Do it!"
