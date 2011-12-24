var https = require('https');
var fs = require('fs');
var url = require('url');
var exec = require('child_process').exec;

var options = {
	key: fs.readFileSync('privatekey.pem'),
	cert: fs.readFileSync('certificate.pem')
};

https.createServer(options, function (req, res) {
	var query = url.parse(req.url, true).query;
	if(query.key == 'NotVerySecure') {
		if(query.action == null || query.domain == null) {
			res.writeHead(400);
			res.end(JSON.stringify({error: "Bad request"}));
		}
		res.writeHead(200);
		switch(query.action) {
			case 'status':
				/*
				 * Note: we're removing all non-alphanumeric characters. We don't want anything
				 * bad to happen :)
				 */
				run(res, 'virsh domstate '+query.domain.replace(/[^\w]/g, ''));
				break;
			case 'start':
				run(res, 'virsh start '+query.domain.replace(/[^\w]/g, ''));
				break;
			case 'stop':
				run(res, 'virsh shutdown '+query.domain.replace(/[^\w]/g, ''));
				break;
			case 'poweroff':
				run(res, 'virsh destroy '+query.domain.replace(/[^\w]/g, ''));
				break;
			default:
				res.end(JSON.stringify({error: 'Unknown action'}));
		}
	}
	else {
		res.writeHead(403);
		res.end(JSON.stringify({error: "Unauthorized"}));
	}
}).listen(4433);

function run(res, cmd) {
	exec(cmd, function(err, stdout, stderr) {
		var out = { output: stdout,
			    error: stderr
			  };
		res.end(JSON.stringify(out));
	});
}
