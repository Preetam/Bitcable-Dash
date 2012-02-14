module.exports = (req,res) ->
	db = require('../db.js').db
	db.view 'dash', 'get_kvms', key: req.session.user, (e,r,h) ->
		kvms = r.rows
		res.render 'index', { kvms: kvms }
