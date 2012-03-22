div ->
	h1 -> "Billing."
	div ->
	if(@stripeid == null)
		p -> "You don't have a credit card associated with your account. Click <a href='/billing/addcard'>here</a> to add one."
	else
		div ->
			h2 -> "Active card"
			p -> "xxxx-xxxx-xxxx-#{@stripeid.last4}"
			p -> "Expires #{@stripeid.exp_month}/#{@stripeid.exp_year}"
			a href: '/billing/removecard', "Remove card"
	h1 -> "Invoices."
	for invoice in @invoices
		div ->
			a href: "/billing/invoices/#{invoice.num}", ->
				p -> "#{invoice.num} - $#{invoice.total.toFixed(2)}"
