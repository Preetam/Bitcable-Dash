module.exports = (req,res) ->
	db = require('../../db.js').db
	db.get "KVM-#{req.params.kvmid}", (e,r,h) ->
		kvm = r
		res.render 'manage', {kvm: kvm}
