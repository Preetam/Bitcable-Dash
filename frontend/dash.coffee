express = require('express')
nonssl = express.createServer()

fs = require('fs')
db = require('./db.js').db
https = require('https')

###
Redirecting non-SSL traffic to SSL.
###

nonssl.get '*', (req, res) ->
	res.redirect 'https://dash.bitcable.com/'

nonssl.listen 8080

privateKey = fs.readFileSync('privatekey.pem').toString();
certificate = fs.readFileSync('certificate.pem').toString();
caCert = fs.readFileSync('ca.pem').toString();
app = module.exports = express.createServer({key: privateKey, cert: certificate, ca: caCert});
app.set 'view engine', 'coffee'
app.register '.coffee', require('coffeekup').adapters.express
app.listen 443

`
app.configure(function(){
	app.set('views', __dirname + '/views');
	app.use(express.cookieParser());
	app.use(express.session({ secret: "dash is cool" }));
	app.use(express.bodyParser());
	app.use(app.router);
	app.use(express.methodOverride());
	app.use(express.static(__dirname + '/public'));
});
`

app.get '/', require('./routes/default')
app.post '/auth', require('./routes/auth')
app.get '/auth', (req, res) ->
	res.redirect '/'
app.get '/manage/:kvmid/', require('./routes/manage')

app.get '/manage/:kvmid/start', require('./routes/manage/start')
app.post '/manage/:kvmid/start', require('./routes/manage/start')

app.get '/manage/:kvmid/stop', require('./routes/manage/stop')
app.post '/manage/:kvmid/stop', require('./routes/manage/stop')

app.get '/manage/:kvmid/redeploy', require('./routes/manage/redeploy')
app.post '/manage/:kvmid/redeploy', require('./routes/manage/redeploy')
