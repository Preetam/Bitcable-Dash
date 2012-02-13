crypto = require('crypto')
  
sha512 = (str) ->
	shasum = crypto.createHash 'sha512'
	shasum.update str
	return shasum.digest 'hex'

module.exports = (req,res) ->
	if req.method is "GET"
		res.render 'new'
	else
		db = require('./../db.js').db
		hashedPass = sha512 "4s5ji7Lmu747De32T5o224283N263l" +sha512 req.body.password1+"l65c6546P6v225213nj8628I65nPiH"
		doc =
			_id: "USER-#{req.body.email}"
			name: req.body.name
			username: req.body.email
			password: hashedPass
		db.insert doc, (e,r,h) ->
			res.redirect('/')
