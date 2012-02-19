script ->
	'''
	function getElem(id) { return document.getElementById(id); }

	function verifyForm() {
		var errors = '';
		if(getElem('password1Field').value != getElem('password2Field').value)
			errors += 'Passwords do not match.\\n'
	if(errors == '')
		document.getElementById('orderForm').submit();
	else
		alert(errors);
	}
	'''

form id: 'orderForm', action: '/order', method: 'post', ->
	plans = ['tera', 'peta', 'exa', 'zetta', 'yotta']
	div class: 'plans', ->
		for plan in plans
			input id: "#{plan}Option", class: 'planRadioButton', type: 'radio', name: 'plan', value: plan
			label for: "#{plan}Option", -> plan

	fields = [
		   ['name', 'Full name'],
		   ['email', 'Email address'],
		   ['password1', 'Password'],
		   ['password2', 'Password (verification)'],
		   ['prefix', 'KVM prefix'],
		   ['address1', 'Address Line 1'],
		   ['address2', 'Address Line 2'],
		   ['city', 'City'],
		   ['state', 'State'],
		   ['zip', 'ZIP / Postal code']
		 ]
	for field in fields
		if(field[0] == 'address1')
			div style: 'height: 2em', ->
		div class: 'fieldContainer', ->
			input name: field[0], class: 'textInput', id: "#{field[0]}Field", type: (if field[0].indexOf('password') isnt -1 then "password" else "text"), maxlength: (if field[0] is 'zip' then 5 else 45)
			label for: "#{field[0]}Field", -> field[1]

	countryArr = [["Albania","AL"],["Algeria","DZ"],["Andorra","AD"],["Angola","AO"],["Antigua and Barbuda","AG"],["Argentina","AR"],["Armenia","AM"],["Australia","AU"],["Austria","AT"],["Azerbaijan","AZ"],["Bahamas, The","BS"],["Bahrain","BH"],["Bangladesh","BD"],["Barbados","BB"],["Belarus","BY"],["Belgium","BE"],["Belize","BZ"],["Benin","BJ"],["Bhutan","BT"],["Bolivia","BO"],["Bosnia and Herzegovina","BA"],["Botswana","BW"],["Brazil","BR"],["Brunei","BN"],["Bulgaria","BG"],["Burkina Faso","BF"],["Burundi","BI"],["Cambodia","KH"],["Cameroon","CM"],["Canada","CA"],["Cape Verde","CV"],["Central African Republic","CF"],["Chad","TD"],["Chile","CL"],["China, People's Republic of","CN"],["Colombia","CO"],["Comoros","KM"],["Congo, Democratic Republic of the (Congo ﾖ Kinshasa)","CD"],["Congo, Republic of the (Congo ﾖ Brazzaville)","CG"],["Costa Rica","CR"],["Cote d'Ivoire (Ivory Coast)","CI"],["Croatia","HR"],["Cuba","CU"],["Cyprus","CY"],["Czech Republic","CZ"],["Denmark","DK"],["Djibouti","DJ"],["Dominica","DM"],["Dominican Republic","DO"],["Ecuador","EC"],["Egypt","EG"],["El Salvador","SV"],["Equatorial Guinea","GQ"],["Eritrea","ER"],["Estonia","EE"],["Ethiopia","ET"],["Fiji","FJ"],["Finland","FI"],["France","FR"],["Gabon","GA"],["Gambia, The","GM"],["Georgia","GE"],["Germany","DE"],["Ghana","GH"],["Greece","GR"],["Grenada","GD"],["Guatemala","GT"],["Guinea","GN"],["Guinea-Bissau","GW"],["Guyana","GY"],["Haiti","HT"],["Honduras","HN"],["Hungary","HU"],["Iceland","IS"],["India","IN"],["Indonesia","ID"],["Iran","IR"],["Iraq","IQ"],["Ireland","IE"],["Israel","IL"],["Italy","IT"],["Jamaica","JM"],["Japan","JP"],["Jordan","JO"],["Kazakhstan","KZ"],["Kenya","KE"],["Kiribati","KI"],["Korea, Democratic People's Republic of (North Korea)","KP"],["Korea, Republic of  (South Korea)","KR"],["Kuwait","KW"],["Kyrgyzstan","KG"],["Laos","LA"],["Latvia","LV"],["Lebanon","LB"],["Lesotho","LS"],["Liberia","LR"],["Libya","LY"],["Liechtenstein","LI"],["Lithuania","LT"],["Luxembourg","LU"],["Macedonia","MK"],["Madagascar","MG"],["Malawi","MW"],["Malaysia","MY"],["Maldives","MV"],["Mali","ML"],["Malta","MT"],["Marshall Islands","MH"],["Mauritania","MR"],["Mauritius","MU"],["Mexico","MX"],["Micronesia","FM"],["Moldova","MD"],["Monaco","MC"],["Mongolia","MN"],["Montenegro","ME"],["Morocco","MA"],["Mozambique","MZ"],["Myanmar (Burma)","MM"],["Namibia","NA"],["Nauru","NR"],["Nepal","NP"],["Netherlands","NL"],["New Zealand","NZ"],["Nicaragua","NI"],["Niger","NE"],["Nigeria","NG"],["Norway","NO"],["Oman","OM"],["Pakistan","PK"],["Palau","PW"],["Panama","PA"],["Papua New Guinea","PG"],["Paraguay","PY"],["Peru","PE"],["Philippines","PH"],["Poland","PL"],["Portugal","PT"],["Qatar","QA"],["Romania","RO"],["Russia","RU"],["Rwanda","RW"],["Saint Kitts and Nevis","KN"],["Saint Lucia","LC"],["Saint Vincent and the Grenadines","VC"],["Samoa","WS"],["San Marino","SM"],["Sao Tome and Principe","ST"],["Saudi Arabia","SA"],["Senegal","SN"],["Serbia","RS"],["Seychelles","SC"],["Sierra Leone","SL"],["Singapore","SG"],["Slovakia","SK"],["Slovenia","SI"],["Solomon Islands","SB"],["Somalia","SO"],["South Africa","ZA"],["Spain","ES"],["Sri Lanka","LK"],["Sudan","SD"],["Suriname","SR"],["Swaziland","SZ"],["Sweden","SE"],["Switzerland","CH"],["Syria","SY"],["Tajikistan","TJ"],["Tanzania","TZ"],["Thailand","TH"],["Timor-Leste (East Timor)","TL"],["Togo","TG"],["Tonga","TO"],["Trinidad and Tobago","TT"],["Tunisia","TN"],["Turkey","TR"],["Turkmenistan","TM"],["Tuvalu","TV"],["Uganda","UG"],["Ukraine","UA"],["United Arab Emirates","AE"],["United Kingdom","GB"],["United States","US"],["Uruguay","UY"],["Uzbekistan","UZ"],["Vanuatu","VU"],["Vatican City","VA"],["Venezuela","VE"],["Vietnam","VN"],["Yemen","YE"],["Zambia","ZM"],["Zimbabwe","ZW"],["Abkhazia","GE"],["China, Republic of (Taiwan)","TW"],["Nagorno-Karabakh","AZ"],["Northern Cyprus","CY"],["Pridnestrovie (Transnistria)","MD"],["Somaliland","SO"],["South Ossetia","GE"],["Ashmore and Cartier Islands","AU"],["Christmas Island","CX"],["Cocos (Keeling) Islands","CC"],["Coral Sea Islands","AU"],["Heard Island and McDonald Islands","HM"],["Norfolk Island","NF"],["New Caledonia","NC"],["French Polynesia","PF"],["Mayotte","YT"],["Saint Barthelemy","GP"],["Saint Martin","GP"],["Saint Pierre and Miquelon","PM"],["Wallis and Futuna","WF"],["French Southern and Antarctic Lands","TF"],["Clipperton Island","PF"],["Bouvet Island","BV"],["Cook Islands","CK"],["Niue","NU"],["Tokelau","TK"],["Guernsey","GG"],["Isle of Man","IM"],["Jersey","JE"],["Anguilla","AI"],["Bermuda","BM"],["British Indian Ocean Territory","IO"],["British Sovereign Base Areas",""],["British Virgin Islands","VG"],["Cayman Islands","KY"],["Falkland Islands (Islas Malvinas)","FK"],["Gibraltar","GI"],["Montserrat","MS"],["Pitcairn Islands","PN"],["Saint Helena","SH"],["South Georgia and the South Sandwich Islands","GS"],["Turks and Caicos Islands","TC"],["Northern Mariana Islands","MP"],["Puerto Rico","PR"],["American Samoa","AS"],["Baker Island","UM"],["Guam","GU"],["Howland Island","UM"],["Jarvis Island","UM"],["Johnston Atoll","UM"],["Kingman Reef","UM"],["Midway Islands","UM"],["Navassa Island","UM"],["Palmyra Atoll","UM"],["U.S. Virgin Islands","VI"],["Wake Island","UM"],["Hong Kong","HK"],["Macau","MO"],["Faroe Islands","FO"],["Greenland","GL"],["French Guiana","GF"],["Guadeloupe","GP"],["Martinique","MQ"],["Reunion","RE"],["Aland","AX"],["Aruba","AW"],["Netherlands Antilles","AN"],["Svalbard","SJ"],["Ascension","AC"],["Tristan da Cunha","TA"],["Antarctica","AQ"],["Kosovo","CS"],["Palestinian Territories (Gaza Strip and West Bank)","PS"],["Western Sahara","EH"],["Australian Antarctic Territory","AQ"],["Ross Dependency","AQ"],["Peter I Island","AQ"],["Queen Maud Land","AQ"],["British Antarctic Territory","AQ"]]
	div class: 'fieldContainer', ->
		select name: 'country', id: 'countryField', ->
			for country in countryArr
				option value: country[1], -> country[0]
		label for: 'countryField', -> 'Country'

	div style: 'height: 2em', ->

	div style: 'text-align: center; font-size: 0.8em', ->
		"( You'll be able to pay through the billing section of Dash. )"

	input type: 'submit', class: 'submitButton', value: "Vroom!", onclick: 'verifyForm(); return false'
