
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , crypto = require('crypto')
  , fs = require('fs')
  , hashlib = require('hashlib')
  , db = require('./db.js').db
  , httpProxy = require('http-proxy')
  , https = require('https');

var proxy = new httpProxy.RoutingProxy();

var options = {
  https: {
    key: fs.readFileSync('privatekey.pem', 'utf8'),
    cert: fs.readFileSync('certificate.pem', 'utf8'),
    ca: fs.readFileSync('ca.pem', 'utf8')
  }
};


httpProxy.createServer(options, function (req, res, proxy) {
	var kvmid = req.url.match(/kvm[0-9]+/)[0];
	req.url = req.url.replace(kvmid+'/', '');
	req.url = '/9099'+req.url;
	proxy.proxyRequest(req, res, {
		host: 'storm.bitcable.com',
		port: 443,
		https: true
	});
}).listen(4430);

// SSL features

var privateKey = fs.readFileSync('privatekey.pem').toString();
var certificate = fs.readFileSync('certificate.pem').toString();
var caCert = fs.readFileSync('ca.pem').toString();
var app = module.exports = express.createServer({key: privateKey, cert: certificate, ca: caCert});

var nonssl = express.createServer();
nonssl.get('*', function(req, res) {
	res.redirect('https://dash.bitcable.com/');
});
nonssl.listen('8001');

// Configuration

app.configure(function(){
	app.set('views', __dirname + '/views');
	app.use(express.cookieParser());
	app.use(express.session({ secret: "dash is cool" }));
	app.set('view engine', 'jade');
	app.use(express.bodyParser());
	app.use(app.router);
	app.use(express.methodOverride());
	app.use(require('stylus').middleware({ src: __dirname + '/public', compress: true }));
	app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
	app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
	app.use(express.errorHandler()); 
});

// Routes


app.get(/console\/([\w]+)\/[.]*/, function(req, res) {
	req.url = req.url.replace('/console/'+req.params[0], '');
	req.url = '/9099'+req.url;
	console.log(req.url);
	proxy.proxyRequest(req, res, {
		host: 'storm.bitcable.com',
		port: 443,
		https: true
	});
});

app.post(/console\/([\w]+)\/[.]*/, function(req, res) {
	req.url = req.url.replace('/console/'+req.params[0], '');
	req.url = '/9099'+req.url;
	console.log(req.url);
	proxy.proxyRequest(req, res, {
		host: 'storm.bitcable.com',
		port: 443,
		https: true
	});
});

app.get('/', routes.index);
app.post('/auth', routes.auth);

app.get('/logout', function(req, res) {
	req.session.destroy();
	res.redirect('/');
});

app.get('/manage/:kvmid', routes.manage);
app.listen(443, '199.58.161.141');
//console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
