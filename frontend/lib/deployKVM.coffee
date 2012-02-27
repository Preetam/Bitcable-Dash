db = require('../db.js').db

###
type is either 'public' or 'private'
###
getIPaddress = (type, cb) ->
	db.get 'IP_addresses', (e,r,h) ->
		address = r[type].available.shift
		r[type].used.push(address)
		cb(address)


###
ram is the required amount of RAM.
###
getAvailableNode = (ram, cb) ->
	db.view 'dash', 'get_available_node', {key: null}, (e,r,h) ->
		r = r.rows
		for node in r
			if node.key < ram
				cb node.value
				return

###
Input:
{
	username
	plan
}
###
createKVMdoc = (opts) ->
	

module.exports = () ->
	this.functions =
		createKVMdoc: createKVMdoc
		getAvailableNode: getAvailableNode
