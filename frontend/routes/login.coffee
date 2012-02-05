sha512 = (str) ->
	shasum = crypto.createHash 'sha512'
	shasum.update str
	return shasum.digest 'hex'
