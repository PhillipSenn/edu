<cfscript>
LogUI = new LogUI().Save(
	LogUIClass='x'
	,LogJSSort=1
	,LogUITag='UITag'
	,LogUITagName='LogUITagName'
	,LogUIIdentifier='LogUIIdentifier'
	,LogUIDestination='LogUIDestination'
	,LogUIValue='LogUIValue');
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>