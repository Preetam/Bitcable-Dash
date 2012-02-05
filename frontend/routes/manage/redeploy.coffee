startKVM = (node, kvmid) ->
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
		)
		

module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'login', title: "Login"
	else if req.method is "GET"
		res.render 'verifyaction'
	else
		db = require('../../db.js').db
		db.get "KVM-#{req.params.kvmid}", (e,r,h) ->
			kvm = r
			startKVM kvm.node, req.params.kvmid
			res.redirect "/manage/#{req.params.kvmid}/"
