<cfscript>
local.result = {}
local.result.msg = ''
local.svc = new query()
if (IsDefined('Variables.DataSource')) {
	local.svc.setDataSource(Variables.DataSource)
}
local.fw.try = Duplicate(request.fw.try)
local.fw.log = Duplicate(request.fw.log) // LogDB, LogErr
local.fw.FunctionName = GetFunctionCalledName() & '()'
</cfscript>