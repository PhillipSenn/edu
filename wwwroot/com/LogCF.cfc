component {
Variables.fw.DataSource = 'fw'

function Save() {
	request.fw.log.Sort += 1 // I use the same counter for LogDB, LogDBErr, LogCF, LogCFErr
	local.LogCFOutString   = getPageContext().getOut().getString()
	local.LogCFQueryString = cgi.QUERY_STRING // getPageContext().getRequest().getQueryString()
	local.RemoteAddr  = getPageContext().getRequest().getRemoteAddr()
	local.LogCFName  = getPageContext().getRequest().getServletPath()
	// local.LogCFName  = ReplaceNoCase(local.LogCFName,Application.fw.Path,'')
	// local.LogCFCookies     = getPageContext().getRequest().getHeader('Cookie')
	local.LogCFUserAgent   = getPageContext().getRequest().getHeader('User-Agent')
	savecontent variable='local.LogCFURL' { 
		// dump(var=url,format='text',top=3,metainfo=false)
	}
	if (Find('struct [empty]',local.LogCFURL)) {
		local.LogCFURL = ''
	}
	savecontent variable='local.LogCFForm' { 
		// dump(var=form,format='text',top=3,metainfo=false)
	}
	if (Find('struct [empty]',local.LogCFForm)) {
		local.LogCFForm = ''
	}

	savecontent variable='local.LogCFSession' { 
		// dump(var=session,format='text',top=3,metainfo=false)
	}
	if (IsDefined('session.Usr.qry.UsrID')) {
		local.UsrID = session.Usr.qry.UsrID
	} else {
		local.UsrID = 0
	}
	
	local.svc = new query()
	local.svc.setSQL('SELECT LogCFID = NEXT VALUE FOR LogCFID') // I'm having a hard time executing an update followed by a select in Railo.
	local.svc.setDataSource(Variables.fw.DataSource)
	local.obj = local.svc.execute()
	local.LogCFID = local.obj.getResult().LogCFID

	include '/Inc/newQuery.cfm'
	local.sql = '
	DECLARE @LogCFID BigInt = #Val(local.LogCFID)#
	DECLARE @DomainID Int = #Val(Application.fw.DomainID)#
	DECLARE @LogCFSort Int = #Val(request.fw.log.Sort)#
	DECLARE @LogCFElapsed Int = #GetTickCount() - request.fw.TickCount#
	DECLARE @UsrID Int = #Val(local.UsrID)#
	
	UPDATE LogCF SET
	 LogCF_DomainID = @DomainID
	,LogCFSort = @LogCFSort
	,LogCFElapsed=@LogCFElapsed
	,LogCF_UsrID =@UsrID
	,LogCFDateTime = getdate()
	,LogCFOutString=?
	,LogCFQueryString=?
	,LogCFName=?
	,LogCFUserAgent=?
	,LogCFURL=?
	,LogCFForm=?
	,LogCFSession=?
	,RemoteAddr=?
	WHERE LogCFID = @LogCFID
	'
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogCFOutString)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=Left(local.LogCFQueryString,512))
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=Left(local.LogCFName,512))
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=Left(local.LogCFUserAgent,512))
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogCFURL)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogCFForm)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogCFSession)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=Left(local.RemoteAddr,15))
	local.fw.log.db = false
	include '/Inc/Execute.cfm'
	return local.LogCFID // For: LogCFErr_LogCFID
}
}
