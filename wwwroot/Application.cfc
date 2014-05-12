component {
this.Name = "edu1157"
this.DataSource = "edu"
this.SessionManagement = true
this.ScriptProtect = "all"
this.TemplatePath = GetTemplatePath()
this.mappings['com'] = 'c:\home\PhillipSenn.com\wwwroot\edu\com\' // todo: remove \wwwroot
this.mappings['Inc'] = 'c:\home\PhillipSenn.com\wwwroot\edu\Inc\' // todo: remove \wwwroot

this.currentTemplatePath = GetCurrentTemplatePath()
this.directoryFromPath = GetDirectoryFromPath(this.currentTemplatePath)
this.mappings['fw'] = this.directoryFromPath & 'fw\'

function onApplicationStart() {
	Application.fw = {}
	Application.fw.name='edu - Education'
	Application.fw.Path = '/edu/'
	Application.fw.msg = ''
	Application.fw.msgClass = 'label-info'

	Application.fw.log = {}
	Application.fw.log.CF  = true
	Application.fw.log.CFC = true
	Application.fw.log.CFErr = true
	Application.fw.log.DB = true 		// INSERT INTO LogDB
	Application.fw.log.DBErr = true 	// INSERT INTO LogDBErr
	Application.fw.log.JS  = true
	Application.fw.log.UI  = true
	Application.fw.log.CFErrCounter = 0
	Application.fw.log.DBErrCounter = 0
	Application.fw.log.MaxDB = 0		// Every session defaults to logging a maximum of n sequences

	Application.fw.try = {}
	Application.fw.try.catch = true
	Application.fw.try.abort = true // abort if there is a database exception
	Application.fw.try.class = 'label-danger'
	Application.fw.try.email = 'lrPhillipSenn@gmail.com'
	Application.fw.js = true // This get duplicated in the session scope
	Application.fw.css= true // This get duplicated in the session scope
	Application.fw.hidden = false // Hide #main until the page has loaded.

	Application.fw.DomainID = 0 // For logging the next command
	Application.fw.log.Sort = 0 // For logging the next command
	Application.fw.tickCount = GetTickCount() // For logging the next command
	session.fw = Duplicate(Application.fw) // fw.try, fw.log
	request.fw = Duplicate(Application.fw) // fw.try, fw.log
	Application.fw.DomainID = new com.Domain().WhereDomainName()
	local.LogCFCName = 'this.Name: ' & this.Name;
	local.LogCFCDesc = 'onApplicationStart';
	new com.LogCFC().Save(local);
	
	return true
}

function onSessionStart() {
	session.fw = Duplicate(Application.fw)
	request.fw = Duplicate(Application.fw)
	local.LogCFCName = 'this.Name: ' & this.Name;
	local.LogCFCDesc = 'onSessionStart';
	new com.LogCFC().Save(local);
}

function onRequestStart(LogCFCName) {
	StructAppend(form,url,false)
	if (StructKeyExists(form,"onApplicationStart")) {
		onApplicationStart()
	}
	if (StructKeyExists(form,"onSessionStart")) {
		onSessionStart()
	}
	request.fw = Duplicate(session.fw)
	request.fw.tickCount = GetTickCount()
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onRequestStart';
	new com.LogCFC().Save(local);

	if (IsDefined('form.logout')) {
		StructDelete(session,"Usr")
	}
	if (IsDefined('form.UniqueID')) {
		local.Usr = new com.Usr().WhereUniqueID(form)
		if (IsDefined('local.Usr.Prefix')) {
			if (local.Usr.Prefix.Recordcount) {
				session.Usr = Duplicate(local.Usr)
			}
		}
	}
	request.fw.LogCFID = new com.LogCF().Save() // This is for LogDB
	session.fw.LogCFID = request.fw.LogCFID // These are for LogUI and LogJS.
	session.fw.TickCount = GetTickCount() // I put it these the session scope so that they can't be gamed.
	// setting showDebugoutput = false;
	if (IsDefined('session.Usr.qry')) {
		//
	} else if (IsDefined('session.Registered')) {
		// java.lang.ArrayIndexOutOfBoundsException
	} else if (FindNoCase('\WordSearch\',this.TemplatePath)) {
		//
	} else if (FindNoCase('\Registration\',this.TemplatePath)) {
	} else {
//		include '/TpT/Inc/LoggedOut.cfm'
//		return false
	}
	return true
}

function OnRequestEnd(LogCFCName) {
	session.fw.msg = ''
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onRequestEnd';
	new com.LogCFC().Save(local);
}

function onSessionEnd(mySession,myApplication) {
	if (IsDefined('mySession.Usr.qry.UsrID')) {
		local.LogCFCName = 'mySession.Usr.qry.UsrID: ' & mySession.Usr.qry.UsrID
	} else {
		local.LogCFCName = 'myApplication.name: ' & myApplication.name
	}
	local.LogCFCDesc = 'onSessionEnd';
	new com.LogCFC().Save(local);
}

function onCFCRequest(LogCFCName, LogCFCDesc, args) {
	local.LogCFCName = arguments.LogCFCName
	local.LogCFCDesc = arguments.LogCFCDesc
	new com.LogCFC().Save(local)
}

function onMissingTemplate(LogCFCName) {
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onMissingTemplate';
	new com.LogCFC().Save(local);
	return false;
}

function onMissingMethod(LogCFCName,args) { // I don't think this is working
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onMissingMethod';
	new com.LogCFC().Save(local);
	return false;
}

function onApplicationEnd(myApplication) {
	local.LogCFCName = 'myApplication.name: ' & myApplication.name
	local.LogCFCDesc = 'onApplicationEnd';
	new com.LogCFC().Save(local);
}

function onError(Exception,EventName) {
	if (!IsDefined('session.fw.log.CFErr')) return
	if (!session.fw.log.CFErr) return
	session.fw.log.CFErrCounter += 1 // See onRequestStart

	if (IsDefined('arguments.Exception.Message')) {
		request.fw.msg = Exception.Message
		local.LogCFErrMessage = Exception.Message
	} else {
		local.LogCFErrMessage = 'No Exception.Message'
	}

	request.fw.Detail = ''
	if (isDefined('arguments.Exception.Number')) {
		request.fw.Detail &= 'Exception.Number: #arguments.Exception.Number#<br>'
		local.LogCFErrNumber = Exception.Number
	} else {
		local.LogCFErrNumber = 'No Exception.Number'
	}
	if (isDefined('arguments.Exception.TagContext') && IsArray(Exception.TagContext) && ArrayLen(Exception.TagContext)) {
		request.fw.Detail &= 'Exception.TagContext[1].Line: #arguments.Exception.TagContext[1].Line#<br>'
		local.LogCFErrLine = Exception.TagContext[1].Line
	} else {
		local.LogCFErrLine = 0
	}

	if (isDefined('arguments.Exception.Name')) {
		request.fw.Detail &= 'Exception.Name: #arguments.Exception.Name#<br>'
		local.LogCFErrName = Exception.Name
	} else {
		local.LogCFErrName = 'No Exception.Name'
	}
	if (isDefined('arguments.Exception.Detail') AND arguments.Exception.Detail != '') {
		request.fw.Detail &= 'Exception.Detail: #arguments.Exception.Detail#<br>'
		local.LogCFErrDetail = Exception.Detail
	} else {
		local.LogCFErrDetail = 'No Exception.Detail'
	}
	if (isDefined('arguments.Exception.Type')) {
		request.fw.Detail &= 'Exception.Type: #arguments.Exception.Type#<br>'
		local.LogCFErrType = Exception.Type
	} else {
		local.LogCFErrType = 'No Exception.Type'
	}
	if (IsDefined('arguments.EventName') AND arguments.EventName != '') {
		request.fw.Detail &= 'EventName: #arguments.EventName#<br>'
		local.LogCFErrEventName = arguments.EventName
	} else {
		local.LogCFErrEventName = 'No arguments.EventName'
	}
	request.fw.Detail &= '</pre>'

	local.svc = new mail()
	local.svc.setSubject(Application.fw.Name & ': ' & ListLast(GetBaseTemplatePath(),'\'))
	local.svc.setBody('Exception.Message: #request.fw.msg#<p>#request.fw.Detail#</p>')
	
	local.port=465
	local.server='smtp.gmail.com'
	local.type='html'
	local.UserName='PhillipSenn@gmail.com'
	local.useSSL=true

	local.svc.setPort(local.Port)
	local.svc.setServer(local.Server)
	local.svc.setType(local.Type)
	local.svc.setUserName(local.UserName)
	local.svc.setUseSSL(local.UseSSL)
	local.svc.setFrom(local.UserName)
	var Password = ''
	include "/Inc/Passwords/Email.cfm"
	local.svc.setPassword(Password)
	local.svc.setTo('Phillip Senn<PhillipSenn@gmail.com>')
	local.svc.Send()

	request.fw.log.Sort += 1; // I use the same counter for LogDB, LogDBErr, LogCF, LogCFErr, LogCFC
	local.LogCFID = new com.LogCF().Save()
	local.sql = '
	DECLARE @DomainID Int = #Val(Application.Domain.qry.DomainID)#
	DECLARE @LogCFErrID Int = NEXT VALUE FOR LogCFErrID;
	DECLARE @LogCFID Int = #Val(local.LogCFID)#;
	DECLARE @LogCFErrSort Int = #Val(request.fw.log.Sort)#;
	DECLARE @LogCFErrElapsed Int = #GetTickCount() - request.fw.TickCount#;
	DECLARE @LogCFErrNumber Int = #Val(local.LogCFErrNumber)#;
	DECLARE @LogCFErrLine Int = #Val(local.LogCFErrLine)#;
	
	UPDATE fw.dbo.LogCFErr SET
	 LogCFErr_DomainID	= @DomainID
	,LogCFErr_LogCFID		= @LogCFID
	,LogCFErrSort			= @LogCFErrSort
	,LogCFErrNumber		= @LogCFErrNumber
	,LogCFErrElapsed		= @LogCFErrElapsed
	,LogCFErrLine			= @LogCFErrLine
	,LogCFErrDatetime		= getdate()
	,LogCFErrName			= ?
	,LogCFErrDetail		= ?
	,LogCFErrMessage		= ?
	,LogCFErrType			= ?
	,LogCFErrEventName	= ?
	WHERE LogCFErrID = @LogCFErrID
	';
	local.svc = new query();

	local.svc.setSQL(local.sql);
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrName,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrDetail,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrMessage,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrType,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrEventName,512));
	local.svc.execute();

	request.fw.Detail = '<pre>#request.fw.Detail#</pre>'
	request.fw.Detail &= "I've sent an email to the administrator."
	include "/Inc/onError.cfm"
}

}
