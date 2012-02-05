module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'login', title: "Login"
	else
		db = require('../db.js').db
		db.get "KVM-#{req.params.kvmid}", (e,r,h) ->
			kvm = r
			res.render 'manage', {kvm: kvm}
