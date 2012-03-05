var https = require('https');
var fs = require('fs');
var url = require('url');
var exec = require('child_process').exec;

var options = {
	key: fs.readFileSync('privatekey.pem'),
	cert: fs.readFileSync('certificate.pem')
};

function redeploy(q, cb) {
//	php -f deploy.php test1 tera ubuntu-11.10-64 199.58.161.254 199.58.161.129 255.255.255.128 10.0.2.1 255.255.0.0
	var cmd = "cd scripts && php -f deploy.php "+q.domain+" "+q.plan+" "+q.img+" "+q.pubip+" "+q.pubgw+" "+q.pubnm+" "+q.privip+" "+q.privnm+" "+q.useremail;
	exec(cmd, function(err,stdout,stderr) {
		cb(stdout);
	});
}

console.log('huh');

https.createServer(options, function (req, res) {
	var query = url.parse(req.url, true).query;
	if(query.key == 'NotVerySecure') {
		if(query.action == null || query.domain == null) {
			res.writeHead(400);
			res.end(JSON.stringify({error: "Bad request"}));
		}
		else {
			res.writeHead(200);
			switch(query.action) {
				case 'status':
					/*
					 * Note: we're removing all non-alphanumeric characters. We don't want anything
					 * bad to happen :)
					 */
					getStatus(res, query.domain.replace(/[^\w]/g, ''));
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
				case 'redeploy':
					console.log('redeploy');
					redeploy(query, function(out) {
						res.end(out);
					});
					break;
				default:
					res.end(JSON.stringify({error: 'Unknown action'}));
			}
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

function getStatus(res, domid) {
	exec("virsh domstate "+domid, function(err, stdout, stderr) {
		if(stdout.indexOf('running') == 0)
			res.end('1');
		else
			res.end('0');
	});
}
