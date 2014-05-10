<cfscript>
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<form method="post" action="LogUI.cfm">
	<p>
	<label>
	<input type="checkbox" name="chkName" id="chkID" class="chkClass" value="1">chkName
	</label>
	</p>
	<p>
		<input type="radio" name="radioName" id="radioName2" value="2" class="radioClass2">2<br>
		<input type="radio" name="radioName" id="radioName3" value="3" class="radioClass3">3
	</p>
	<p><a class="Google" id="idGoogle" name="NameGoogle" href="http://www.google.com">Google</a></p>
	<p><input class="inputClass" id="inputID" name="myInput"></p>
	<p><textarea class="Textareaclass" id="TextareaID" name="myTextArea">myTextarea</textarea></p>
	<p><button type="submit" name="myButton">myButton</button></p>
	<p><input type="button" name="btnInput" value="Input type=button"></p>
	<p><input type="submit" name="submit" value="Input type=submit"></p>
</form>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>