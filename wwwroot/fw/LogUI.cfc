component extends="Library.fw0.ReadWhereDelete" {
Variables.TableName = "LogUI";
Variables.TableSort = "LogUIID DESC";
Variables.MetaData = GetMetaData();

remote function Save() {
	if (!session.fw0.LogUI) return 'session.fw0.LogUI=0';
	local.LogUIName = ReplaceNoCase(cgi.HTTP_REFERER,'http://www.phillipsenn.com','');
	if (Left(local.LogUIName,Len(Application.fw0.homeDir)) == Application.fw0.homeDir) {
		local.LogUIName = Mid(local.LogUIName,Len(Application.fw0.homeDir),128);
	}
	local.LogUIName = Replace(local.LogUIName,'=','= ','all');
	
	if (Len(arguments.LogUIClass)) {
		local.LogUIClass = '.' & Replace(arguments.LogUIClass,' ','.','all');
	} else {
		local.LogUIClass = '';
	}
	lock scope="application" type="exlusive" timeout="10" {
		Application.fw0.LogUIID += 1;
		if (Application.fw0.LogUIID > 9999) {
			Application.fw0.LogUIID -= 9999;
		}
		local.LogUIID = Application.fw0.LogUIID;
	}
	if (StructKeyExists(arguments,"TickCount")) {
		local.TickCount = arguments.TickCount;
	} else {
		local.TickCount = GetTickCount();
	}
	if (isDefined("session.fw0.LogCFID")) {
		local.LogCFID = session.fw0.LogCFID;
	} else {
		local.LogCFID = 0;
	}
	local.sql = "
	DECLARE @LogUIID Int = #Val(local.LogUIID)#;
	DECLARE @LogCFID Int = #Val(local.LogCFID)#;
	DECLARE @LogJSSort Int = #Val(arguments.LogJSSort)#;
	DECLARE @LogUIElapsed Int = #GetTickCount() - local.TickCount#;
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
	";
	local.svc = new query();
	local.svc.setSQL(local.sql);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=local.LogUIName);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arguments.LogUITag,MaxLength=6); // anchor, button, check
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arguments.LogUITagName);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arguments.LogUIIdentifier);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=local.LogUIClass);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arguments.LogUIDestination);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arguments.LogUIValue);
	local.obj = local.svc.execute();
	// Don't forget to put local.dataType = 'text'; in the JavaScript!
}
}
