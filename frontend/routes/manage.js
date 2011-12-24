var db = require('../db.js').db;

exports.manage = function(req, res){
	console.log(req.session.user);
	console.log(req.params.kvmid);
	var kvmid = req.params.kvmid.replace(/[^0-9]/g, '');
	if(req.session && req.session.user) {
		db.view('dash', 'getkvm', { key: parseInt(kvmid) }, function(e,r,h) {
			console.log(r.rows[0].value);
			res.render('manage', r.rows[0].value);
		});
	}
	else
		res.render('login');
};
