module.exports = (req,res) ->
	console.log req.session.user
	if req.session.user is undefined
		res.render 'login', title: "Login"
	else
		res.render 'index'
