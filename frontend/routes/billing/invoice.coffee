module.exports = (req,res) ->
	db = require('../../db.js').db
	invoiceid = req.params.invoiceid

	db.get "INVOICE-#{invoiceid}", (e,r,h) ->
		res.render 'error' if e
		res.render 'forbidden' if r.client isnt req.session.user
		res.render 'billing/invoice', {invoice: r}

	db.view 'dash', 'get_invoices', key: req.session.user, (e,r,h) ->
		invoices = r.rows
		for i,val of invoices
			invoices[i] = val.value
		res.render 'billing/index', {stripeid: req.session.userdoc.stripeid, invoices: invoices}
