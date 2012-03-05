var nano = require('nano')('http://dash:epqYeIYqeeKx8ygUPoW3DJqJRJXrQL@199.58.161.156:5999');
var db = nano.use('bitcable-dash');
var exec = require('child_process').exec;

function processDoc(doc) {
	exec("vnstat -u -i "+doc.value+".public && vnstat -i "+doc.value+".public --dumpdb | grep m\\;0", function(err, stdout, stderr) {
		var str = stdout.split(';');
		var total = parseInt(str[3]) + parseInt(str[4]);
		db.get(doc.id, function(e,r,h) {
			r.usedbw = total;
			db.insert(r, function(e2, r2, h2) {
				console.log(r2);
			});
		});
	});
}

db.view('dash', 'kvms_by_node', {key: process.argv[2]}, function(e,r,h) {
	for(var i in r.rows)
		processDoc(r.rows[0]);
});
