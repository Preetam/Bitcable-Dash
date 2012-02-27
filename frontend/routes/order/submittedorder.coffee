crypto = require('crypto')
check = require('validator').check

sha512 = (str) ->
	shasum = crypto.createHash 'sha512'
	shasum.update str
	return shasum.digest 'hex'

###
Inserting the new client's data into the Dash database
###

createNewDashUser = (a, cb) ->
	error = ''
	if a.password1 isnt a.password2
		error += "Passwords don't match. "

	try
		check(a.email, "Invalid email address ").len(6,64).isEmail()
	catch err
		error += err

	if(a.prefix.match(/^[a-z][-a-z0-9]*$/) is null)
		error += 'Invalid prefix. Use a valid Linux username.'

	if(error isnt "")
		cb(error)
		return

	hashedpass = sha512 "4s5ji7Lmu747De32T5o224283N263l" +
		     sha512 a.password1+"l65c6546P6v225213nj8628I65nPiH"
	doc =
		_id: "USER-#{a.email}"
		name: a.name
		password: hashedpass
		username: a.email
		stripeid: null
		address1: a.address1
		address2: a.address2
		prefix: a.prefix
		city: a.city
		state: a.state
		zip: a.zip
		country: a.country
		increment: 1

	console.log(doc)
	db = require('../../db.js').db
	db.insert doc, (e,r,h) ->
		if e
			console.log e
			error += "That email address is already in use. " if e.error is 'conflict'
		req.session.user = a.email
		req.session.userdoc = doc

	cb(error)

createNewClient = (params, cb) ->
	createNewDashUser(params, cb)

module.exports = (req,res) ->
	if req.session.user is undefined
		createNewClient(req.body, (err) ->
			res.render 'order/ordercompleted', error: err
		)
