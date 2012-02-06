module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'newuserorder', title: "Order"
