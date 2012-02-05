module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'login', title: "Login"
	else
		db = require('../db.js').db
		db.view 'dash', 'get_kvms', key: req.session.user, (e,r,h) ->
			kvms = r.rows;
			res.render 'index', { kvms: kvms }
