status = (node, kvmid, cb) ->
	https = require('https')
	querystring = require('querystring')
	qs = '/?'+ querystring.stringify(
			host: node
			domain: kvmid
			action: 'status'
			key: 'NotVerySecure'
		)
	https.get(
			host: node
			path: qs
			port: 4433
		,(res) ->
			res.on 'data', (chunk) ->
				cb(chunk)
		)
		

module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'login', title: "Login"
	db = require('../../db.js').db
	db.get "KVM-#{req.params.kvmid}", (e,r,h) ->
		kvm = r
		status kvm.node, req.params.kvmid, (output) ->
			res.end output
