module.exports = (req,res) ->
	if req.method is "GET"
		res.render 'new'
	else
		db = require('../../db.js').db
		db.get "KVM-#{req.params.kvmid}", (e,r,h) ->
			kvm = r
			startKVM kvm.node, req.params.kvmid
			res.redirect "/manage/#{req.params.kvmid}/"
