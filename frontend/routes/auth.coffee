crypto = require('crypto')

sha512 = (str) ->
	shasum = crypto.createHash 'sha512'
	shasum.update str
	return shasum.digest 'hex'

db = require('../db.js').db

module.exports = (req, res) ->
	db.view 'dash', 'user_auth', key: req.body.username, (e,r,h) ->
		try
			if r.rows[0].value is sha512 "4s5ji7Lmu747De32T5o224283N263l"
								+ sha512 req.body.password+"l65c6546P6v225213nj8628I65nPiH"
				req.session.user = req.body.username
				req.session.cookie.maxAge = 3600000
				db.get "USER-#{req.body.username}", (e2, r2, h2) ->
					req.session.userdoc = r2
					res.redirect '/'
		catch err
			console.log err
		
