db = require('../db.js').db

#cmd = "cd scripts && php -f deploy.php "+q.domain+" "+q.plan+" "+q.img+" "+q.pubip+" "+q.pubgw+" "+q.pubnm+" "+q.privip+" "+q.privnm
sendDeploySignal = (kvmdoc) ->
	reqVars =
		domain: kvmdoc.kvmID
		plan: kvmdoc.plan
		img: kvmdoc.img
		pubip: kvmdoc.publicIP.address
		pubgw: kvmdoc.publicIP.gateway
		pubnm: kvmdoc.publicIP.netmask
		privip: kvmdoc.privateIP.address
		privnm: kvmdoc.privateIP.netmask
		key: "NotVerySecure"
		action: "redeploy"
	querystr = "/?"+require('querystring').stringify(reqVars)
	require('https').get {host: kvmdoc.node, port: 4433, path: querystr}, (res) ->
		console.log(res)

###
vars = [block, ip, netmask, [gateway]]
###
setIPused = (type, vars, cb) ->
	db.get vars[0], (e,r,h) ->
		available = r[type].available
		used = r[type].used
		available.splice(available.indexOf(vars[1]), 1)
		used.push(vars[1])
		cb(vars[1], vars[2], vars[3])
		db.insert r, r._id, (e2,r2,h2) ->

###
type is either 'public' or 'private'
###
getIPaddress = (type, node, cb) ->
	db.view 'dash', "get_#{type}_ip", {key: node}, (e,r,h) ->
		ip = r.rows[0].value[1]
		setIPused type, r.rows[0].value, cb

###
ram is the required amount of RAM.
###
getAvailableNode = (ram, cb) ->
	db.view 'dash', 'get_available_node', (e,r,h) ->
		r = r.rows
		for node in r
			cb node.value if node.key >= ram
			return

###
Input:
{
	username/prefix
	plan
	client
	id_counter
}
###
createKVMdoc = (opts, cb) ->
	ram =
		tera: 256
		peta: 512
		exa: 1024
		zetta: 2048
		yotta: 4096
	bw =
		tera: 150
		peta: 300
		exa: 600
		zetta: 1200
		yotta: 2400

	publicIP = ''
	privateIP = ''

	getAvailableNode ram[opts.plan], (node) ->
		getIPaddress 'public', node, (pubip, pubnm, pubgw) ->
			getIPaddress 'private', node, (privip, privnm, privgw) ->
				kvmDoc =
					_id: "KVM-#{opts.prefix}#{opts.id_counter}"
					client: opts.client
					publicIP:
						address: pubip
						netmask: pubnm
						gateway: pubgw
					privateIP:
						address: privip
						netmask: privnm
					node: node
					bw: bw[opts.plan]
					bwUsed: 0
					kvmID: opts.prefix+opts.id_counter
					plan: opts.plan
					img: opts.img
				cb(kvmDoc)
				db.insert kvmDoc, (e,r,h) ->
					

module.exports =
		createKVMdoc: createKVMdoc
		getAvailableNode: getAvailableNode
		getIPaddress: getIPaddress
		sendDeploySignal: sendDeploySignal
