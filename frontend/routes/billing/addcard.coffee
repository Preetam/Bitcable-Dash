stripe = require('stripe')('19bTMSNFegTOIgdLGLxBQtfncgNqMo54')
db = require('../../db.js').db

module.exports = (req,res) ->
	if req.method is 'GET'
		res.render 'billing/addcard'
	else
		obj =
			email: req.session.user
			description: req.session.userdoc.name
			card:
				number: req.body.ccnumber
				exp_month: req.body.expmonth
				exp_year: req.body.expyear
				cvc: req.body.cvc
				name: req.session.userdoc.name
				address_line1: req.session.userdoc.address1
				address_line2: req.session.userdoc.address2
				address_zip: req.session.userdoc.zip
				address_state: req.session.userdoc.state
				address_country: req.session.userdoc.country
		stripe.customers.create obj, (err, customer) ->
			if(err)
				res.render 'billing/addcard', {error: "Didn't work.", user: req.session.user}
			else
				db.get "USER-#{req.session.user}", (e,r,h) ->
					r.stripeid = customer.id
					console.log r
					db.insert r, r._id, (e2, r2, h2) ->
						if e2
							console.log e2
						req.session.userdoc = r
						res.redirect '/billing/'
