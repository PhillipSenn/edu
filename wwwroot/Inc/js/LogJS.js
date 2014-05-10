fw = {}
fw.LogJS = function(arg) {
	var Closure = {}
	Closure.LogJSSort = 0;
	return function(arg) {
		var local = {}
		log(arg)
		if (navigator.onLine) {
			local.global		= false
			local.context		= this
			local.type 			= 'POST'
			local.dataType		= 'text'
			local.url			= '/edu/fw/LogJS.cfc'
			local.data			= {}
			local.data.method	= 'Save'
			local.data.LogJSName = arg
			
			// var err = new Error();
			// console.log(err.stack)

			if (arguments.callee.caller) {
				local.data.LogJSDesc = arguments.callee.caller.toString()
			} else {
				local.data.LogJSDesc = ''
			}
			Closure.LogJSSort += 1
			local.data.LogJSSort = Closure.LogJSSort
			local.data.LogJSPathName = window.location.pathname
			local.Promise = $.ajax(local) // no error trapping
		}
	}
}
logjs = fw.LogJS()
