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

nonssl.listen 8001

privateKey = (fs.readFileSync 'privatekey.pem').toString()
certificate = (fs.readFileSync 'cert.pem').toString()
caCert = (fs.readFileSync 'ca.pem').toString()
app = module.exports = express.createServer {key: privateKey, cert: certificate, ca: caCert}

app.set 'view engine', 'coffee'
app.register '.coffee', require('coffeekup').adapters.express
app.listen 443, '199.58.161.141'

app.configure () ->
	app.set 'views', __dirname + '/views'
	app.use express.cookieParser()
	app.use express.session { secret: "dash is cool" }
	app.use express.bodyParser()
	app.use express.static __dirname + '/public'
	app.use app.router
	app.use express.methodOverride()

# Route definitions

app.get '/shell', (req, res) ->
	require('child_process').exec("shellinaboxd --css white-on-black.css -s /:SSH:#{req.query.node} --cgi", (err, stdout, stderr) ->
		res.writeHead(stdout)
		res.end()
	)

app.get '/consoletest', require('./routes/consoletest')

# Don't need to be logged in
app.get '/new', require('./routes/new')
app.post '/new', require('./routes/new')

app.get '/order', require('./routes/order/')
app.post '/order', require('./routes/order/submittedorder')

app.post '/ipn', require('./routes/ipn')
app.get '/ipn', require('./routes/ipn')

app.get '*', (req, res, next) ->
	if req.session.user is undefined
		res.render 'login', {title: "Login", layout: false}
	else
		next()


# Need to be logged in

app.get '/', require('./routes/')

app.post '/auth', require('./routes/auth')
app.get '/auth', (req, res) ->
	res.redirect '/'

app.get '/manage/:kvmid/', require('./routes/manage/')

app.get '/manage/:kvmid/start', require('./routes/manage/start')
app.post '/manage/:kvmid/start', require('./routes/manage/start')

app.get '/manage/:kvmid/stop', require('./routes/manage/stop')
app.post '/manage/:kvmid/stop', require('./routes/manage/stop')

app.get '/manage/:kvmid/redeploy', require('./routes/manage/redeploy')
app.post '/manage/:kvmid/redeploy', require('./routes/manage/redeploy')

app.get '/manage/:kvmid/status', require('./routes/manage/status')
