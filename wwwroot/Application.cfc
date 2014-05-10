component {
this.Name = "edu"
this.DataSource = "edu"
this.SessionManagement = true
this.ScriptProtect = "all"
this.TemplatePath = GetTemplatePath()
this.mappings['com'] = 'c:\home\PhillipSenn.com\edu\com\'
this.mappings['Inc'] = 'c:\home\PhillipSenn.com\edu\Inc\'

this.currentTemplatePath = GetCurrentTemplatePath()
this.directoryFromPath = GetDirectoryFromPath(this.currentTemplatePath)
this.mappings['fw'] = this.directoryFromPath & 'fw\'

public boolean function onApplicationStart() {
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
	request.fw = Duplicate(Application.fw) // fw.try, fw.log
	Application.fw.DomainID = new com.Domain().WhereDomainName() 
	return true
}

public void function onSessionStart() {
	session.fw = Duplicate(Application.fw)
	request.fw = Duplicate(Application.fw)
}

public boolean function onRequestStart(String targetPage) {
	StructAppend(form,url,false)
	if (StructKeyExists(form,"onApplicationStart")) {
		onApplicationStart()
	}
	if (StructKeyExists(form,"onSessionStart")) {
		onSessionStart()
	}
	request.fw = Duplicate(session.fw)
	request.fw.tickCount = GetTickCount()

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
	request.fw.LogCFID = new fw.LogCF().Save() // This is for LogDB
	session.fw.LogCFID = request.fw.LogCFID // These are for LogUI and LogJS.
	session.fw.TickCount = GetTickCount() // I put it these the session scope so that they can't be gamed.
	setting showDebugoutput = false;
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

public void function OnRequestEnd() {
	session.fw.msg = ''
}
}
