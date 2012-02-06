stripe_api_key = '19bTMSNFegTOIgdLGLxBQtfncgNqMo54'
stripe = require('stripe')(stripe_api_key)
crypto = require('crypto')

sha512 = (str) ->
	shasum = crypto.createHash 'sha512'
	shasum.update str
	return shasum.digest 'hex'

chargeCustomer = (id) ->
	today = new Date()

	prorated = 800 / 30 * ( ( (Date.UTC(today.getUTCFullYear(), today.getUTCMonth()+1, 1)/1000) - (Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate())/1000) ) / (24*60*60) )

	charge =
		amount: Math.round(prorated)
		currency: 'usd'
		customer: id
		description: 'Tera VPS (prorated)'
	stripe.charges.create charge, (err, ch) ->
		console.log err if err

	invoiceItem =
		customer: id
		amount: 800
		currency: 'usd'
		description: 'Tera VPS'
	stripe.invoice_items.create invoiceItem, (err, item) ->
		stripe.invoices.list {customer: id}, (err, res) ->
			console.log(res)

###
Inserting the new client's data into the Dash database
###

createNewDashUser = (a) ->
	return if not a.stripeid
	hashedpass = sha512 "4s5ji7Lmu747De32T5o224283N263l" +
		     sha512 a.password1+"l65c6546P6v225213nj8628I65nPiH"
	doc =
		_id: "USER-#{a.email}"
		name: a.name
		password: hashedpass
		username: a.email
		stripeid: a.stripeid
	console.log(doc)
	db = require('../../db.js').db
	#db.insert doc, (e,r,h) ->
	#	console.log e if e

	chargeCustomer a.stripeid if a.stripeid
	

createNewStripeClient = (a) ->
	today = new Date()
	nextMonth = Date.UTC(today.getUTCFullYear(), today.getUTCMonth()+1, 1)/1000
	doc =
		card:
			number: a.ccnum
			exp_month: a.exp_month
			exp_year: a.exp_year
			name: a.name
			cvc: a.cvc
			address_line1: a.address_line1
			address_line2: a.address_line2
			address_zip: a.zip
			address_state: a.state
			address_country: a.country
		email: a.email
		trial_end: nextMonth
		plan: 'default'
	stripe.customers.create doc, (err, customer) ->
		console.log(err)
		a.stripeid = customer.id
		createNewDashUser a

createNewClient = (params) ->
	#createNewDashUser(params)
	createNewStripeClient(params)

module.exports = (req,res) ->
	if req.session.user is undefined
		createNewClient(req.body)
		res.render 'default'
