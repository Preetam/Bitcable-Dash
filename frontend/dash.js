
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , crypto = require('crypto')
  , fs = require('fs')
  , hashlib = require('hashlib')
  , db = require('./db.js').db

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
	app.use(express.methodOverride());
	app.use(require('stylus').middleware({ src: __dirname + '/public', compress: true }));
	app.use(app.router);
	app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
	app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
	app.use(express.errorHandler()); 
});

// Routes

app.get('/', routes.index);
app.post('/auth', routes.auth);

app.get('/logout', function(req, res) {
	req.session.destroy();
	res.redirect('/');
});

app.get('/manage/:kvmid', routes.manage);

app.listen(443, '199.58.161.141');
//console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
