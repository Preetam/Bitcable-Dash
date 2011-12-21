var nano = require('nano')('http://dash:epqYeIYqeeKx8ygUPoW3DJqJRJXrQL@199.58.161.156:5999');
var db = nano.use('bitcable-dash');

exports.db = db;
