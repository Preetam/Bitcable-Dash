for kvm in @kvms
	div class: 'vmBox', onclick: "window.location = '/manage/pjinka1'", ->
		div class: 'hostname', -> kvm.value.hostname
		div class: 'pub', -> kvm.value.publicIP.address
		div class: 'priv', -> kvm.value.privateIP.address
		div class: 'details', -> kvm.value.plan.charAt(0).toUpperCase()+kvm.value.plan.slice(1)

###
div class: 'vmBoxContainer', ->
	div class: 'vmBox offline', onclick:"window.location = '/manage/pjinka1'", ->
		div class: 'hostname', "test.bitcable.com"
		div class: 'pub', '199.58.161.100'
		div class: 'priv', '10.0.0.5'
		div class: 'details', 'Ubuntu - 256 MB'
	div class: 'vmBox online', onclick:"window.location = '/manage/pjinka2'", ->
		div class: 'hostname', "domain.name"
		div class: 'pub', '199.58.161.101'
		div class: 'priv', '10.0.0.6'
		div class: 'details', 'Ubuntu - 512 MB'
	div class: 'vmBox online', onclick:"window.location = '/manage/pjinka3'", ->
		div class: 'hostname', "blah.name"
		div class: 'pub', '199.58.161.102'
		div class: 'priv', '10.0.0.7'
		div class: 'details', 'Ubuntu - 2048 MB'
	div class: 'vmBox offline', onclick:"window.location = '/manage/pjinka1'", ->
		div class: 'hostname', "test.bitcable.com"
		div class: 'pub', '199.58.161.100'
		div class: 'priv', '10.0.0.5'
		div class: 'details', 'Ubuntu - 256 MB'
	div class: 'vmBox online', onclick:"window.location = '/manage/pjinka2'", ->
		div class: 'hostname', "domain.name"
		div class: 'pub', '199.58.161.101'
		div class: 'priv', '10.0.0.6'
		div class: 'details', 'Ubuntu - 512 MB'
	div class: 'vmBox online', onclick:"window.location = '/manage/pjinka3'", ->
		div class: 'hostname', "blah.name"
		div class: 'pub', '199.58.161.102'
		div class: 'priv', '10.0.0.7'
		div class: 'details', 'Ubuntu - 2048 MB'
###
