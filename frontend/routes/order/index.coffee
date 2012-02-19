module.exports = (req,res) ->
	if req.session.user is undefined
		res.render 'order/newuserorder', {title: "Order", menu: false}
		console.log(req.connection.remoteAddress)
