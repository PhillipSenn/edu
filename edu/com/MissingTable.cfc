component {
function Where() {
	include '/Inc/newQuery.cfm'
	local.sql = "SELECT * FROM X"
//	local.fw.try.abort = false
	include '/Inc/execute.cfm'
	return local.result
}
}
