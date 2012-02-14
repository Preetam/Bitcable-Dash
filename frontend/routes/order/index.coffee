module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'order/newuserorder', title: "Order"
		console.log(req.connection.remoteAddress)
