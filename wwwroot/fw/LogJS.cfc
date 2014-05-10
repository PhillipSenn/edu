component extends="Library.fw0.ReadWhereDelete" {
Variables.TableName = "LogJS";
Variables.TableSort = "LogJSID DESC";
Variables.MetaData = GetMetaData();

remote function Save() returnformat="plain" {
	lock scope="application" type="exlusive" timeout="10" {
		Application.fw0.LogJSID += 1;
		if (Application.fw0.LogJSID > 9999) {
			Application.fw0.LogJSID -= 9999;
		}
		local.LogJSID = Application.fw0.LogJSID;
	}
	if (isDefined("session.fw0.LogCFID")) {
		local.LogCFID = session.fw0.LogCFID;
	} else {
		local.LogCFID = 0;
	}
	local.sql = "
	DECLARE @LogJSID Int = #Val(local.LogJSID)#;
	DECLARE @LogCFID Int = #Val(local.LogCFID)#;
	DECLARE @LogJSSort Int = #Val(arguments.LogJSSort)#;
	DECLARE @LogJSElapsed Int = #GetTickCount() - arguments.TickCount#;
	UPDATE LogJS SET
	 LogJS_LogCFID = @LogCFID
	,LogJSSort=@LogJSSort
	,LogJSElapsed=@LogJSElapsed
	,LogJSDateTime = getdate()
	,LogJSName=?
	,LogJSDesc=?
	,LogJSPathName = ?
	WHERE LogJSID = @LogJSID
	";
	local.svc = new query();
	local.svc.setSQL(local.sql);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=Left(arguments.LogJSName,512));
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arguments.LogJSDesc);
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=Left(arguments.LogJSPathName,512));
	local.svc.execute();
	return local.LogJSID;
}
}
