module.exports = (req,res) ->
	res.render 'manage/console', {kvmid: req.params.kvmid, user: req.session.user}
