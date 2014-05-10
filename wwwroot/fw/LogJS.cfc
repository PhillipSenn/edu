component {
Variables.DataSource = 'fw'
Variables.MetaData = GetMetaData()

remote function Save() returnformat="plain" {
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
	DECLARE @LogJSID Int = NEXT VALUE FOR LogJSID
	DECLARE @LogCFID Int = #Val(local.LogCFID)#
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
	local.svc = new query()
	local.svc.setSQL(local.sql)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=Left(arguments.LogJSName,512))
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=arguments.LogJSDesc)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=Left(arguments.LogJSPathName,512))
	local.svc.setDataSource(Variables.DataSource)
	local.svc.execute() // No error trapping
}
}
