var nano = require('nano')('http://dash:epqYeIYqeeKx8ygUPoW3DJqJRJXrQL@199.58.161.156:5999');
var exec = require('child_process').exec;

var kvmID = process.argv[2];
update(kvmID);

function update(kvmID) {
	exec("php -f slaveutils/monthbw.php "+kvmID+'.0', function(error, stdout, stderr) {
		console.log(stdout);
		nano.use('bitcable-dash').get("KVM-"+kvmID, function(e,r,h) {
			console.log('===');
			console.log(r);
			console.log('===');
			var doc = r;
			doc.usedbandwidth = stdout;
			nano.use('bitcable-dash').insert(doc, doc._id, function(e1,r1,h1) {
				if(!e1)
					console.log("success");
				else
					console.log(e1);
			});
		});
	});
}
