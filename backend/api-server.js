var https = require('https');
var fs = require('fs');
var url = require('url');

var options = {
	key: fs.readFileSync('privatekey.pem'),
	cert: fs.readFileSync('certificate.pem')
};

https.createServer(options, function (req, res) {
	var query = url.parse(req.url, true).query;
	if(query.key == 'a secret') {
		res.writeHead(200);
		res.end(JSON.stringify({response: "Hello"}));
	}
	else {
		res.writeHead(403);
		res.end(JSON.stringify({error: "Unauthorized"}));
	}
}).listen(443);
