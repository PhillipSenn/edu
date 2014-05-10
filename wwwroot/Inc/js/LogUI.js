(function() {
	var Variables = {}
	Variables.LogJSSort = 0
	
	$(document).on('click','a',aLog)
	$(document).on('click','button',btnLog)
	$(document).on('click','input:submit,input:button',btnLog)
	$(document).on('change','input:checkbox',chkLog)
	$(document).on('mousedown',':radio',RadioMouseDown)
	$(document).on('change','input:radio',RadioLog)
	$(document).on('change','input:not(:submit,:button,:checkbox,:radio)',inputLog)
	$(document).on('change','textarea',TextareaLog)

	function RadioMouseDown() {
		$('input[name=' + $(this).attr('name') + ']:radio').each(SaveDeSelected)
	}
	function SaveDeSelected(index, element) {
		var local = {}
		if ($(this).is(':checked')) {
			local.Destination = 'deSelected'
			local.Save = Save.bind(this,local.Destination)
			local.Save('radio')
		}
	}
	function RadioLog() {
		var local = {}

		if ($(this).is(':checked')) {
			local.Destination = 'Selected'
		} else {
			local.Destination = 'unChecked'
		}
		local.Save = Save.bind(this,local.Destination)
		local.Save('radio')
	}
	function inputLog() {
		var local = {}

		local.Destination = ''
		local.Save = Save.bind(this,local.Destination)
		local.Save('text')
	}
	function TextareaLog() {
		var local = {}

		local.Destination = $(this).text()
		local.Save = Save.bind(this,local.Destination)
		local.Save('text')
	}

	function chkLog() {
		var local = {}

		if ($(this).is(':checked')) {
			local.Destination = 'Checked'
		} else {
			local.Destination = 'unChecked'
		}
		local.Save = Save.bind(this,local.Destination)
		local.Save('check')
	}

	function aLog() {
		var local = {}

		local.Destination = $(this).attr('href') || ''
		local.Save = Save.bind(this,local.Destination)
		local.Save('anchor')
	}
	function btnLog() {
		var local = {}

		local.Destination = $(this).closest('form').attr('action') || ''
		local.Save = Save.bind(this,local.Destination)
		local.Save('button')
	}

	function Save(argDestination,argTag) {
		var local = {}

		if (navigator.onLine) {
			Variables.LogJSSort += 1
			local.data = {}
			local.data.LogJSSort = Variables.LogJSSort
			local.data.method = 'Save'
			local.data.LogUITag = argTag
			local.data.LogUITagName = $(this).attr('name') || ''
			if (this.id) {
				local.data.LogUIIdentifier = '#' + this.id
			} else {
				local.data.LogUIIdentifier = ''
			}
			if ($(this).val()) {
				local.data.LogUIValue = $(this).val()
			} else {
				local.data.LogUIValue = ''
			}
			local.data.LogUIClass = this.className || ''
			local.data.LogUIDestination = argDestination
			local.dataType = 'text' // no return value.
			local.type 		= 'POST'
			local.url		= '/edu/fw/LogUI.cfc'
			local.Promise = $.ajax(local)
			local.Promise.done(done)
			local.Promise.fail(fail)
		}
	}
	function done(response, status, jqXHR) {
		// debugger
	}
	function fail(jqXHR, status, response) {
		$('#msg').text(status + ': ' + response).addClass('label-danger')
		$('#main').html(jqXHR.responseText)
		debugger
	}
})()
