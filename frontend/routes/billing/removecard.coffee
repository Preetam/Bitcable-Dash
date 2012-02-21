stripe = require('stripe')('19bTMSNFegTOIgdLGLxBQtfncgNqMo54')
db = require('../../db.js').db

module.exports = (req,res) ->
	if req.method is 'GET'
		res.render 'billing/removecard'
	else
		stripe.customers.del req.session.userdoc.stripeid, (err, obj) ->
			if(err)
				res.render 'billing/addcard', {error: "Didn't work."}
			else
				req.session.userdoc.stripeid = null
				db.insert req.session.userdoc, req.session.userdoc._id, (e,r,h) ->
						res.redirect '/billing/'
