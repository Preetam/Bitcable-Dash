
/**
 * Module dependencies.
 */

var sys = require('sys');
var crypto = require('crypto');
var fs = require('fs');

var hashlib = require("hashlib");

var privateKey = fs.readFileSync('privatekey.pem').toString();
var certificate = fs.readFileSync('certificate.pem').toString();

var credentials = crypto.createCredentials({key: privateKey, cert: certificate});

var express = require('express');
var app = module.exports = express.createServer({key: privateKey, cert: certificate});
var nonssl = express.createServer();
var cradle = require('cradle');

var db = new(cradle.Connection)('http://199.58.161.5', 5984, {
  cache: true,
  raw: false,
  auth: {username: 'dashuser', password: 'C79bwzjtjJD0iN4kn0JiALcp55W96t'}
}).database('dash');

db.get('vps-1', function(err, doc) {
  sys.puts(doc.nodes);
});

var accessKey = "36df270ab6765f49c9c3d536a7b6c52365913916";

// Configuration
app.configure(function(){
	app.set('views', __dirname + '/views');
 	app.set('view engine', 'jade');
  app.use(express.cookieParser());
  app.use(express.session({secret: 'dash is neat :)'}));
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(require('stylus').middleware({ src: __dirname + '/public' }));
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

app.get('/', function(req, res){
	if(req.session.user) {
		db.view('dash/get_domains', {"key": req.session.user}, function(err, doc) {
			console.log(doc);
			req.session.domains = doc;
			res.render('index', {
				title: 'DASH.',
				locals: {
					username: req.session.user,
					domains: doc
				}
			});
		});
	}
	else
		res.render('login', {
			title: 'Login'
		});
});

app.get('/logout', function(req, res) {
	req.session.destroy(function(err) {
	
	});
	res.redirect('/');
});

app.get('/auth', function(req, res) {
	res.redirect('/');
});

app.post('/auth', function(req, res) {
	var username = req.body.username;
	var password = req.body.password;
	
	if(req.session.user)
		res.redirect('/');
		
	db.view('dash/user_auth', {"key": username}, function(err, doc) {
		console.log(doc);
		if(doc[0])
			if(doc[0]['value'] == hashlib.sha512(hashlib.sha512(password+"__salt")+"__salt")) {
				req.session.user = username;
			        console.log('Authenticated!');
			}
		else
			console.log(hashlib.sha512(hashlib.sha512(password+"__salt")+"__salt"));
		res.redirect('/');
	});
});

app.post('/exec', function(req, res) {
	var action = req.body.action;
	var domain = req.body.domain;
	var username = req.session.user;
	var domlist = req.session.domains;
	console.log("DOM LIST");
	console.log(JSON.stringify(domlist));
	var domDoc;
	for(idx in domlist) {
		if(domlist[idx]['value']['name'] == domain)
			domDoc = domlist[idx]['value'];
	}
	if(!username || !username.length || !domDoc.name)
		res.send(JSON.stringify({
			"output":"",
			"error":"Unauthorized"
		}));
	else {
		querystring = require('querystring');
		var query = querystring.stringify({
			accesskey: accessKey,
			domain: domain,
			action: action
		});
		console.log("EXEC REQUEST AUTHENTICATED! =======================================|||||||||||||");
		var https = require('https');
	
		https.get({ host: 'yorkfield.bitcable.com', path: '/?'+query, port: 3000 }, function(response) {
		  console.log("statusCode: ", response.statusCode);
		  console.log("headers: ", response.headers);

		  response.on('data', function(d) {
			process.stdout.write(d);
			res.send(d);
			console.log('DATA');
		  });

		}).on('error', function(e) {
		  console.error(e);
			console.log('error!');
		});
	
		console.log(req.session.user);
	}
});

nonssl.get('*', function(req, res) {
	res.redirect('https://dash.bitcable.com/');
});

nonssl.listen(80);

app.listen(443);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
