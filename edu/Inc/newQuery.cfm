<cfscript>
local.result = {}
local.result.msg = ''
local.svc = new query()
if (IsDefined('Variables.DataSource')) {
	local.svc.setDataSource(Variables.DataSource)
}
local.fw = Duplicate(request.fw)
local.fw.FunctionCalledName = GetFunctionCalledName() & '()'
</cfscript>