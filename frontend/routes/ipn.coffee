ipn = require 'paypal-ipn'
db = require('./../db.js').db

module.exports = (req, res) ->
	ipn.verify req.body, (err,msg) ->
		if err
			console.log("IPN VERIFICATION ERROR")
		else
			console.log("IPN VERFICATION PASSED")
			console.log 'Invoice: ' + req.body.invoice
			db.get req.body.invoice, (e,r,h) ->
				if(r.total == parseFloat(req.body.mc_gross))
					r.paid = true
					console.log r
					db.insert r,r._id,(e2,r2,h2) ->
				else
					console.log "VALUES NOT EQUAL"
	res.end('ok')
