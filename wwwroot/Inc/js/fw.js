;(function() {
	$(document).on('mouseenter', 'button:submit[name="Delete"]', function() {
		$(this).addClass('btn-danger')
	})
	$(document).on('mouseleave', 'button:submit[name="Delete"]', function() {
		$(this).removeClass('btn-danger')
	})
	// $('table').not('.no-table').addClass('table').wrap('<div class="table-responsive"></div>')
	$('table').not('.no-table').addClass('table')
	$('table').not('.no-table,.no-hover').addClass('table-hover')
	$('table').not('.no-table,.no-striped').addClass('table-striped')
	$('table').not('.no-table,.no-bordered').addClass('table-bordered')
	$('table').not('.no-table,.no-condensed').addClass('table-condensed')
	
	$('textarea,input:text,input:password,input[type=email],select').addClass('form-control')

	$('.btn-lg,.btn-block,.btn-default,.btn-primary,.btn-success,.btn-info,.btn-warning,.btn-danger,.btn-link').addClass('btn')
	$('button').addClass('btn')
	$('.btn').not('.no-lg').addClass('btn-lg') // All buttons default to .btn-lg unless they are .no-lg
	$('.no-lg').addClass('btn') // Anything with class="no-lg" will default to btn.
	$('#Save,button[name=Save]').addClass('btn-primary')
	$('.btn').not('.btn-success,.btn-primary,.btn-info,.btn-warning,.btn-danger,.btn-default').addClass('btn-default')

	$('nav').addClass('navbar')
	$('.navbar').not('navbar-inverse').addClass('navbar-default')
	
	$('article,footer,header,main').addClass('row') // section=container
	// $('img').not('[hidden]').addClass('img-responsive') // img-rounded
})()

// Railo (pronounced Rhylo)
;(function() {
	function Railo() {
		$('a[name=cfdebug_templates]').find('font').hide()
		$('table.cfdebug').addClass('table table-striped table-hover table-bordered table-condensed')
	}
	setTimeout(Railo,100)
})()
