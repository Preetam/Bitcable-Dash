stripe = require('stripe')('19bTMSNFegTOIgdLGLxBQtfncgNqMo54')

module.exports = (req,res) ->
	db = require('../../db.js').db
	db.view 'dash', 'get_invoices', key: req.session.user, (e,r,h) ->
		invoices = r.rows
		for i,val of invoices
			invoices[i] = val.value
		if(req.session.userdoc.stripeid != null)
			stripe.customers.retrieve req.session.userdoc.stripeid, (err, custobj) ->
				res.render 'billing/index', {stripeid: custobj.active_card, invoices: invoices}
		else
			res.render 'billing/index', {stripeid: null, invoices: invoices}
