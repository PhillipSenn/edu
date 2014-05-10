<cfscript>

</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
This did a console.log as well as posting it to the logjs table.
<cfinclude template="/Inc/foot.cfm">
<script>
logjs('Hello World')
</script>
<cfinclude template="/Inc/End.cfm">
</cfoutput>