<cfscript>
local.result = {}
local.result.msg = ''
local.svc = new query()
local.fw = Duplicate(request.fw)
if (IsDefined('Variables.fw.DataSource')) {
	local.fw.DataSource = Variables.fw.DataSource
}
local.fw.FunctionCalledName = GetFunctionCalledName() & '()'
</cfscript>