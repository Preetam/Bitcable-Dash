
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

var nano = require('nano')('http://dash:epqYeIYqeeKx8ygUPoW3DJqJRJXrQL@199.58.161.156:5999');

var accessKey = "f62caffad954411c3358a8942072698a29145617";

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
		nano.use('bitcable-dash').get("USER-"+req.session.user, null, function(e,r,h) {
			console.log(r.kvms);
			res.render('index', {
				title: 'Home',
				kvmlist: r.kvms
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

app.get('/changepassword', function(req, res) {
	if(checkAuth(req,res)) {
		res.render('changepassword', {
			title: 'Change password'
		});
	}
	else
		console.log("failed auth");
});

app.post('/changepassword', function(req, res) {
	if(checkAuth(req,res)) {
		if(req.body.password != req.body.passwordverify)
			res.redirect('/changepassword');
		else {
			nano.use('bitcable-dash').view('dash', 'get_user_doc', {key: '"'+req.session.user+'"'}, function(e,r,h) {
				var doc = r.rows[0].value;
				doc.password = hashlib.sha512("4s5ji7Lmu747De32T5o224283N263l"+hashlib.sha512(req.body.password+"l65c6546P6v225213nj8628I65nPiH"));
				nano.use('bitcable-dash').insert(doc, doc._id, function(e1,r1,h1) {
					req.session.destroy();
					res.redirect('/');
				});
			});
		}
	}
});

function checkAuth(req, res) {
	if(!req.session.user) {
		res.redirect('/');
		return false;
	}
	return true;
}

app.get('/manage/:kvmid/', function(req, res) {
	if(checkAuth(req, res)) {
		nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
			if(r.user != req.session.user)
				res.render('unauthorized', {title: 'Unauthorized!'});
			else {
				querystring = require('querystring');
				var query = querystring.stringify({
					accesskey: accessKey,
					domain: req.params.kvmid,
					action: "status"
				});
				/*
				var https = require('https');
				https.get({ host: r.node, path: '/?'+query, port: 3000 }, function(response) {
					console.log("statusCode: ", response.statusCode);
					console.log("headers: ", response.headers);

					response.on('data', function(d) {
						console.log(d);
						if(d.output.indexOf("running")!=-1)
							console.log('Running!');
						res.render('manage', {title: 'Manage KVM', kvmdetails: r});
						console.log('DATA');
					});

				}).on('error', function(e) {
					console.error(e);
					console.log('error!');
				});
				*/
				var request = require('request');
				request({uri: "https://"+r.node+":3000/?"+query}, function(err,resp,body) {
					var running = false;
					if(body.indexOf("running") != -1)
						running = true;
					r.running = running;
					res.render('manage',{title: 'Manage KVM', kvmdetails: r});
				});

			}
		});
	}
});

app.get('/manage/:kvmid/start', function(req, res) {
	if(checkAuth(req, res)) {
		nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
			if(r.user != req.session.user)
				res.render('unauthorized', {title: 'Unauthorized!'});
			else
				res.render('action', {title: 'Start KVM',
									  kvmdetails: r});
		});
	}
});

app.get('/manage/:kvmid/poweroff', function(req, res) {
        if(checkAuth(req, res)) {
                nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
                        if(r.user != req.session.user)
                                res.render('unauthorized', {title: 'Unauthorized!'});
                        else
                                res.render('action', {title: 'Power off KVM',
                                                                          kvmdetails: r});
                });
        }
});

app.get('/manage/:kvmid/stop', function(req, res) {
        if(checkAuth(req, res)) {
                nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
                        if(r.user != req.session.user)
                                res.render('unauthorized', {title: 'Unauthorized!'});
                        else
                                res.render('action', {title: 'Stop  KVM',
                                                                          kvmdetails: r});
                });
        }
});


app.post('/manage/:kvmid/start', function(req, res) {
	if(checkAuth(req, res)) {
		nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
			if(r.user != req.session.user)
				res.render('unauthorized', {title: 'Unauthorized!'});
			else {
//				res.redirect('/manage/'+req.params.kvmid);


				querystring = require('querystring');
                                var query = querystring.stringify({
                                        accesskey: accessKey,
                                        domain: req.params.kvmid,
                                        action: "start"
                                });


				var request = require('request');
                                request({uri: "https://"+r.node+":3000/?"+query}, function(err,resp,body) {
                                	res.redirect('/manage/'+req.params.kvmid+'/');
				});






			}
		});
	}
});


app.post('/manage/:kvmid/poweroff', function(req, res) {
        if(checkAuth(req, res)) {
                nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
                        if(r.user != req.session.user)
                                res.render('unauthorized', {title: 'Unauthorized!'});
                        else {
//                              res.redirect('/manage/'+req.params.kvmid);
                                querystring = require('querystring');
                                var query = querystring.stringify({
                                        accesskey: accessKey,
                                        domain: req.params.kvmid,
                                        action: "poweroff"
                                });

                                var request = require('request');
                                request({uri: "https://"+r.node+":3000/?"+query}, function(err,resp,body) {
                                        res.redirect('/manage/'+req.params.kvmid+'/');
                                });

                        }
                });
        }
});

app.post('/manage/:kvmid/stop', function(req, res) {
        if(checkAuth(req, res)) {
                nano.use('bitcable-dash').get("KVM-"+req.params.kvmid, null, function(e,r,h) {
                        if(r.user != req.session.user)
                                res.render('unauthorized', {title: 'Unauthorized!'});
                        else {
//                              res.redirect('/manage/'+req.params.kvmid);
                                querystring = require('querystring');
                                var query = querystring.stringify({
                                        accesskey: accessKey,
                                        domain: req.params.kvmid,
                                        action: "stop"
                                });

                                var request = require('request');
                                request({uri: "https://"+r.node+":3000/?"+query}, function(err,resp,body) {
                                        res.redirect('/manage/'+req.params.kvmid+'/');
                                });

                        }
                });
        }
});

app.get('/auth', function(req, res) {
	res.redirect('/');
});

app.post('/auth', function(req, res) {
	var username = req.body.username;
	var password = req.body.password;
	console.log('Beginning authentication');
	if(req.session.user) {
		res.redirect('/');
    console.log('Already authenticated');
  }

	nano.use('bitcable-dash').view('dash', 'user_auth', {key: '"'+username+'"'}, function(e,r,h) {
		try {
      console.log(r);
			if(r.rows[0].value == hashlib.sha512("4s5ji7Lmu747De32T5o224283N263l"+hashlib.sha512(password+"l65c6546P6v225213nj8628I65nPiH")))
				req.session.user = username;
		}
		catch(e) {
      console.log(e);
		}
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
	res.redirect('https://dash.bitcable.com/',301);
});

nonssl.listen(8001);

app.listen(443, "199.58.161.156");
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
