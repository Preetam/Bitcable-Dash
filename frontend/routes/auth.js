var db = require('../db.js').db;
var hashlib = require('hashlib');

exports.auth = function(req, res) {
	db.view('dash', 'user_auth', {key: req.body.username}, function(e,r,h) {
		try {
			console.log(r);
			console.log('header: ' + h);
			if(r.rows[0].value ==
				hashlib.sha512("4s5ji7Lmu747De32T5o224283N263l"
				+  hashlib.sha512(req.body.password+"l65c6546P6v225213nj8628I65nPiH"))) {
				console.log("authenticated!");
				req.session.user = req.body.username;
			}
		}
		catch(e) {
			console.log(e);
		}

		res.redirect('/');
	});
};
