blah = require('./deployKVM')()

blah.getAvailableNode 5000, (val) ->
	console.log "val: " + val
