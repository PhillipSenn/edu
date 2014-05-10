component {
Variables.DataSource = 'fw'
Variables.MetaData = GetMetaData()

remote function Save() {
	local.LogUIName = ReplaceNoCase(cgi.HTTP_REFERER,'http://www.phillipsenn.com','')
	if (FindNoCase(Application.fw.Path,local.LogUIName) == 1) {
		local.LogUIName = Mid(local.LogUIName,Len(Application.fw.Path),128)
	}
	local.LogUIName = Replace(local.LogUIName,'=','= ','all')
	
	if (Len(arguments.LogUIClass)) {
		local.LogUIClass = '.' & Replace(arguments.LogUIClass,' ','.','all')
	} else {
		local.LogUIClass = ''
	}
	if (IsDefined('session.fw.TickCount')) {
		local.TickCount = session.fw.TickCount
	} else {
		local.TickCount = GetTickCount()
	}
	if (isDefined('session.fw.LogCFID')) {
		local.LogCFID = session.fw.LogCFID
	} else {
		local.LogCFID = 0
	}
	local.sql = "
	DECLARE @LogUIID Int = NEXT VALUE FOR LogUIID
	DECLARE @LogCFID Int = #Val(local.LogCFID)#
	DECLARE @LogJSSort Int = #Val(arguments.LogJSSort)#
	DECLARE @LogUIElapsed Int = #GetTickCount() - local.TickCount#
	UPDATE LogUI SET
	 LogUI_LogCFID = @LogCFID
	,LogUISort=@LogJSSort
	,LogUIElapsed=@LogUIElapsed
	,LogUIDateTime = getdate()
	,LogUIName=?
	,LogUITag=?
	,LogUITagName=?
	,LogUIIdentifier=?
	,LogUIClass=?
	,LogUIDestination=?
	,LogUIValue=?
	WHERE LogUIID = @LogUIID
	"
	local.svc = new query()
	local.svc.setSQL(local.sql)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogUIName)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUITag,MaxLength=6) // anchor, button, check
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUITagName)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUIIdentifier)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogUIClass)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUIDestination)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUIValue)
	local.svc.setDataSource(Variables.DataSource)
	local.svc.execute()
	// Don't forget to put local.dataType = 'text' in the JavaScript!
}
}
