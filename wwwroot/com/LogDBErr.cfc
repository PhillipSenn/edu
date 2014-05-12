component {
Variables.fw.DataSource = 'fw'

function Save(arg) { // arg was the local scope when passed.  So arg.result was local.result.
	request.fw.log.Sort += 1

	local.result.Prefix = {}
	if (StructKeyExists(arg.result.Exception,"sql")) {
		local.result.Prefix.sql = arg.result.Exception.sql
	}
	local.result.Prefix.RecordCount = 0
	local.result.Prefix.ExecutionTime = 0
	local.fw.FunctionCalledName = arg.fw.FunctionCalledName
	local.LogDBID = new com.LogDB().Save(local)

	// ErrorCode and SQLState are Integers
	if (StructKeyExists(arg.result.Exception,"NativeErrorCode")) {
		local.LogDBErrCode = arg.result.Exception.NativeErrorCode
	} else {
		local.LogDBErrCode = 0
	}
	if (StructKeyExists(arg.result.Exception,"SQLState")) {
		local.LogDBErrSQLState = arg.result.Exception.SQLState
	} else {
		local.LogDBErrSQLState = 0
	}

	// Type, Name, Desc are varchar
	if (StructKeyExists(arg.result.Exception,"Type")) {
		local.LogDBErrType = arg.result.Exception.Type
	} else {
		local.LogDBErrType = "arg.result.Exception.Type"
	}
	if (StructKeyExists(arg.result.Exception,"Message")) {
		local.LogDBErrName = arg.result.Exception.Message
	} else {
		local.LogDBErrName = "arg.result.Exception.Message"
	}
	if (StructKeyExists(arg.result.Exception,"Detail")) {
		local.LogDBErrDesc = arg.result.Exception.Detail
	} else {
		local.LogDBErrDesc = "arg.result.Exception.Detail"
	}

	if (StructKeyExists(arg.result.Exception,"queryError")) {
		local.LogDBErrQuery = arg.result.Exception.QueryError
		if (local.LogDBErrQuery != local.LogDBErrDesc) {
			local.LogDBErrDesc &= '<br>' & local.LogDBErrQuery
		}
	}
//	if (StructKeyExists(arg.result.Exception,"where")) {
//		local.LogDBErrWhere = arg.result.Exception.where
//	} else {
//		local.LogDBErrWhere = "arg.result.Exception.where"
//	}
	local.sql = "
	DECLARE @DomainID Int = #Val(Application.fw.DomainID)#
	DECLARE @LogDBErrID BigInt = NEXT VALUE FOR LogDBErrID
	DECLARE @LogDBID BigInt = #Val(local.LogDBID)#
	DECLARE @LogDBErrSort Int = #Val(request.fw.log.Sort)#
	DECLARE @LogDBErrElapsed Int = #GetTickCount() - request.fw.TickCount#
	DECLARE @LogDBErrCode Int = #Val(local.LogDBErrCode)#
	DECLARE @LogDBErrSQLState Int = #Val(local.LogDBErrSQLState)#
	UPDATE LogDBErr SET
	 LogDBErr_DomainID = @DomainID
	,LogDBErr_LogDBID=@LogDBID
	,LogDBErrSort=@LogDBErrSort
	,LogDBErrElapsed=@LogDBErrElapsed
	,LogDBErrCode=@LogDBErrCode
	,LogDBErrSQLState=@LogDBErrSQLState
	,LogDBErrDateTime = getdate()
	,LogDBErrType=?
	,LogDBErrName=?
	,LogDBErrDesc=?
	WHERE LogDBErrID=@LogDBErrID
	"
	include '/Inc/newQuery.cfm'
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=local.LogDBErrType)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=local.LogDBErrName)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=local.LogDBErrDesc)
	local.fw.log.db = false
	include '/Inc/execute.cfm'

	if (arg.fw.try.abort) {
		WriteOutput('<html>' & Chr(10))
		WriteOutput('<body>' & Chr(10))
		WriteOutput('It looks like you got the following database error:<pre>' & arg.result.Exception.Detail & '</pre>' & Chr(10))
		if (arg.fw.try.email != '') {
			local.svc = new mail()
			local.svc.setSubject(Application.fw.Name & ': ' & ListLast(GetBaseTemplatePath(),'\'))
			local.msg  = ''
			if (StructKeyExists(arg.result.Exception,"Datasource")) {
				local.msg &= 'Datasource: ' & arg.result.Exception.datasource & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"Detail")) {
				local.msg &= 'Detail: ' & arg.result.Exception.Detail & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"Detail")) {
				local.msg &= 'ErrorCode: ' & arg.result.Exception.ErrorCode & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"Message")) {
				local.msg &= 'Message: ' & arg.result.Exception.message & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"NativeErrorCode")) {
				local.msg &= 'NativeErrorCode: ' & arg.result.Exception.NativeErrorCode & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"SQLState")) {
				local.msg &= 'SQLState: ' & arg.result.Exception.SQLState & '<br>'
			}
			// local.msg &= 'StackTrace: ' & arg.result.Exception.StackTrace & '<br>'
			if (StructKeyExists(arg.result.Exception,"Type")) {
				local.msg &= 'Type: ' & arg.result.Exception.Type & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"QueryError")) {
				local.msg &= 'QueryError: ' & arg.result.Exception.QueryError & '<br>'
			}
			/*
			if (StructKeyExists(arg.result.Exception,"Where") && arg.result.Exception != '') {
				local.msg &= 'Where: ' & arg.result.Exception.Where & '<br>'
			}
			*/
			local.msg &= '<p>'
			local.msg &= 'Application: ' & Application.fw.Name & '<br>'
			local.msg &= 'SCRIPT_NAME: ' & cgi.SCRIPT_NAME & '<br>'
			local.msg &= 'CurrentTmpl: ' & GetCurrentTemplatePath() & '<br>'
			local.msg &= '</p>'
			if (StructKeyExists(arg.result.Exception,"sql")) {
				local.msg &= '<pre>' & arg.result.Exception.sql & '</pre>'
			} else {
				local.msg &= '<pre>arg.result.Exception.sql is empty.</pre>'
			}
			local.svc.setBody(local.msg)

			local.port=465
			local.server='smtp.gmail.com'
			local.type='html'
			local.useSSL=true
			local.svc.setServer(local.Server)
			local.svc.setType(local.Type)
			local.svc.setUseSSL(local.UseSSL)
			local.svc.setPort(local.Port)

			var UserName='PhillipSenn@gmail.com'
			var Password = ''
			include "/Inc/Passwords/Email.cfm"
			local.svc.setFrom(UserName)
			local.svc.setTo('Administrator<#UserName#>')
			local.svc.setUserName(UserName)
			local.svc.setPassword(Password)
			local.svc.Send()
			WriteOutput("<p>I've sent an email to the administrator to let them know.</p>" & Chr(10))
		}
		WriteOutput('</body>' & Chr(10))
		WriteOutput('</html>')
		abort;
	} else {
		request.fw.msg = arg.result.Exception.Detail
		request.fw.msgClass = arg.fw.try.class
	}
}
}