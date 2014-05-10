<cfscript>
LogUI = new LogUI().Save(
	LogUIClass='x'
	,LogJSSort=1
	,TickCount=GetTickCount()
	,LogUITag='x'
	,LogUITagName='x'
	,LogUIIdentifier='x'
	,LogUIDestination='x'
	,LogUIValue='x');
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<cfdump var="#LogUI#">
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>