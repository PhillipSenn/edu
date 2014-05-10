component {

function WhereDomainName() {
	include '/Inc/newQuery.cfm'
	local.sql = "SELECT * FROM fw.dbo.Domain WHERE DomainName='PhillipSenn.com/edu'"
	include '/Inc/execute.cfm'
	return local.result.qry.DomainID
}
}
