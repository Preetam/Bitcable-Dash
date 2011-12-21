exports.test = function(req, res){
	console.log(req.session.user);
	if(req.session && req.session.user)
		res.render('index');
	else
		res.render('login');
};
