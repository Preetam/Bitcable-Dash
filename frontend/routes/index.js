exports.auth = require('./auth').auth;

exports.index = function(req, res){
	console.log(req.session.user);
	if(req.session && req.session.user)
		res.render('index');
	else
		res.render('login');
};
