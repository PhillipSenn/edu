component {
Variables.fw.DataSource = 'fw'

remote function Save() {
	include '/Inc/newQuery.cfm'
	if (isDefined("session.fw.LogCFID")) {
		local.LogCFID = session.fw.LogCFID
	} else {
		local.LogCFID = 0
	}
	if (IsDefined('session.fw.TickCount')) {
		local.TickCount = session.fw.TickCount
	} else {
		local.TickCount = GetTickCount()
	}
	local.sql = "
	DECLARE @LogJSID BigInt = NEXT VALUE FOR LogJSID
	DECLARE @LogCFID BigInt = #Val(local.LogCFID)#
	DECLARE @LogJSSort Int = #Val(arguments.LogJSSort)#
	DECLARE @LogJSElapsed Int = #GetTickCount() - local.TickCount#
	UPDATE LogJS SET
	 LogJS_LogCFID = @LogCFID
	,LogJSSort = @LogJSSort
	,LogJSElapsed = @LogJSElapsed
	,LogJSDateTime = getdate()
	,LogJSName=?
	,LogJSDesc=?
	,LogJSPathName = ?
	WHERE LogJSID = @LogJSID
	"
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=Left(arguments.LogJSName,512))
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=arguments.LogJSDesc)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=Left(arguments.LogJSPathName,512))
	local.fw.log.db = false
	include '/Inc/execute.cfm'
}
}
