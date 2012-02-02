div id: 'container', ->
	div id: 'menu', ->
		a href: "/", -> 'Home'
		a href:"#", -> 'Billing'
		a href: "#", -> 'DNS'
	table ->
		for i in @kvms
			tr -> 
				td ->
					a href: "/manage/#{i.value._id.replace('KVM-','')}/", -> i.value.hostname
				td i.value.ip
