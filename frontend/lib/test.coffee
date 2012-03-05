blah = require('./deployKVM')

###
blah.getAvailableNode 5000, (val) ->
	console.log "available node: " + val
	blah.getIPaddress 'public', val, (res) ->
		console.log "public ip: " + res
		blah.getIPaddress 'private', val, (res2) ->
			console.log "private ip: " + res2
###

blah.createKVMdoc {client: "pj@isomero.us", prefix: "pjinka", id_counter: 1, plan: "tera", img: "ubuntu-11.10-64"}, (doc) ->
	blah.sendDeploySignal(doc)
