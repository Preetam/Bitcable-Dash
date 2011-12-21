exports.manage = function(req, res){
	console.log(req.session.user);
	if(req.session && req.session.user)
		res.render('manage');
	else
		res.render('login');
};
