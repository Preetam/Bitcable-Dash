div ->
	h1 -> "Here's an invoice."
	h2 -> "All paid!" if @invoice.paid
	total = 0
	table class: 'invoiceTable', ->
		tr class: 'heading', ->
			td -> 'Description'
			td -> 'Price'
		for item in @invoice.items
			tr ->
				td -> ""+item.desc
				td -> "$"+item.val.toFixed(2)
			total += item.val
		tr class: 'total', ->
			td -> "&nbsp;"
			td -> "$"+total.toFixed(2)
	if @invoice.paid is false
		a href: "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_xclick&business=paypal_1329713300_biz@isomero.us&item_name=Bitcable%20Invoice&amount=#{total}&button_subtype=services&invoice=#{@invoice._id}&undefined_quantity=0&rm=2&notify_url=https://dash.bitcable.com/ipn&return=https://dash.bitcable.com/billing/invoices/#{@invoice.num}&cancel_return=https://dash.bitcable.com/billing/invoices/#{@invoice.num}", -> "Pay via PayPal"
