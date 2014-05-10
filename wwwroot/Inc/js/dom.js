var dom = {};
dom.msg = $('#msg');
dom.main = $('#main');

dom.failure = function(SQLTransaction, SQLError) {
	dom.msg.addClass('label-danger').text(SQLError.message);
	debugger;
}
