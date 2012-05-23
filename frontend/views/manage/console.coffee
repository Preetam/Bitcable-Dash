script type: "text/javascript", ->
	"""
	function setConsoleHook() {
		var obj = document.getElementById('consoleFrame');
		obj.contentWindow.addEventListener('message', function(e) {
			obj.contentWindow.location.href += '';
			window.setTimeout(function() {
				setConsoleHook();
			}, 100);
		});
		return obj;
	}
	"""
iframe src: "/manage/#{@kvmid}/shell", height: "400px", width: "100%", id: 'consoleFrame'

script type: 'text/javascript', ->
	"setConsoleHook()"
