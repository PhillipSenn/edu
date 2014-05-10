component {

function GrandUnification(form) {
	/*
	include "/Inc/newQuery.cfm";
	local.sql = "
	SELECT TOP 1 LogDBDateTime
	FROM LogDB
	WHERE LogDBSort=0
	ORDER BY LogDBDateTime DESC
	";
	local.fw0.LogDB = false;
	include "/Inc/execute.cfm";
	Then use that to limit the number of rows WHERE LogCFDateTime > LogDBDateTime
	*/
	include "/Inc/newQuery.cfm";
	local.sql = "
	WITH CF AS(
		SELECT TOP 100 *
		FROM LogCF
		ORDER BY LogCFDateTime DESC
	)
	,CFC AS(
		SELECT TOP 100 LogCFC.*
		,RemoteAddr AS LogCFC_RemoteAddr
		,UsrID AS LogCFC_UsrID
		FROM LogCFC
		JOIN LogCFView
		ON LogCFC_LogCFID = LogCFID
		ORDER BY LogCFCDateTime DESC
	)
	,CFErr AS(
		SELECT TOP 100 LogCFErr.*
		,RemoteAddr AS LogCFErr_RemoteAddr
		,UsrID AS LogCFErr_UsrID
		FROM LogCFErr
		JOIN LogCFView
		ON LogCFErr_LogCFID = LogCFID
		ORDER BY LogCFErrDateTime DESC
	)
	,DB AS(
		SELECT TOP 100 LogDB.*
		,RemoteAddr AS LogDB_RemoteAddr
		,UsrID AS LogDB_UsrID
		FROM LogDB
		JOIN LogCFView
		ON LogDB_LogCFID = LogCFID
		ORDER BY LogDBDateTime DESC
	)
	,DBErr AS(
		SELECT TOP 100 LogDBErr.*
		,LogCFID AS LogDBErr_LogCFID
		,RemoteAddr AS LogDBErr_RemoteAddr
		,UsrID AS LogDBErr_UsrID
		,LogDBComponentName AS LogDBErrComponentName
		,LogDBFunctionName AS LogDBErrFunctionName
		FROM LogDBErr
		JOIN LogDBView
		ON LogDBErr_LogDBID = LogDBID
		ORDER BY LogDBErrDateTime DESC
	)
	,JS AS(
		SELECT TOP 100 LogJS.*
		,RemoteAddr AS LogJS_RemoteAddr
		,UsrID AS LogJS_UsrID
		FROM LogJS
		JOIN LogCFView
		ON LogJS_LogCFID = LogCFID
		ORDER BY LogJSDateTime DESC
	)
	,UI AS(
		SELECT TOP 100 LogUI.*
		,RemoteAddr AS LogUI_RemoteAddr
		,UsrID AS LogUI_UsrID
		FROM LogUI
		JOIN LogCFView
		ON LogUI_LogCFID = LogCFID
		ORDER BY LogUIDateTime DESC
	)
	SELECT 'DB' AS Type
	,LogDBID AS PrimaryKey
	,LogDB_LogCFID AS LogCFID
	,LogDB_UsrID AS UsrID
	,LogDBID
	,LogDBSort AS DBSort
	,0 AS JSSort
	,LogDBElapsed AS Elapsed
	,LogDBName AS LogName
	,LogDBFunctionName AS [Description]
	,LogDBDateTime AS LogDateTime
	,LogDB_RemoteAddr AS RemoteAddr
	,LogDBComponentName AS Varchar1
	,'' AS Varchar2
	,'' AS Varchar3
	,'' AS Varchar4
	,'' AS Varchar5
	,'' AS Varchar6
	,LogDBExecutionTime AS Int1
	,LogDBRecordCount AS Int2
	FROM DB
	
	UNION ALL
	SELECT 'CF'
	,LogCFID -- Primary Key
	,LogCFID
	,LogCF_UsrID
	,0 -- LogDBID
	,LogCFSort
	,0 -- JSSort
	,LogCFElapsed
	,LogCFQueryString -- Description
	,LogCFName
	,LogCFDateTime
	,RemoteAddr
	,LogCFOutString -- Varchar1
	,LogCFUserAgent -- Varchar2
	,'' -- Varchar3
	,LogCFURL -- Varchar4
	,LogCFForm -- Varchar5
	,LogCFSession -- Varchar6
	,0 -- Int1
	,0 -- Int2
	FROM CF
	
	UNION ALL
	SELECT 'CFC'
	,LogCFCID
	,LogCFC_LogCFID
	,LogCFC_UsrID
	,0 -- LogDBID
	,LogCFCSort
	,0 -- JSSort
	,LogCFCElapsed
	,LogCFCName
	,LogCFCDesc
	,LogCFCDateTime
	,LogCFC_RemoteAddr
	,'' -- Varchar1
	,'' -- Varchar2
	,'' -- Varchar3
	,'' -- Varchar4
	,'' -- Varchar5
	,'' -- Varchar6
	,0 -- Int1
	,0 -- Int2
	FROM CFC
	
	UNION ALL
	SELECT 'DBErr'
	,LogDBErrID
	,LogDBErr_LogCFID
	,LogDBErr_UsrID
	,LogDBErr_LogDBID
	,LogDBErrSort
	,0 -- JSSort
	,LogDBErrElapsed
	,LogDBErrName
	,LogDBErrDesc
	,LogDBErrDateTime
	,LogDBErr_RemoteAddr
	,LogDBErrType -- Varchar1
	,'' -- Varchar2
	,'' -- Varchar3
	,'' -- Varchar4
	,'' -- Varchar5
	,'' -- Varchar6
	,LogDBErrCode -- Int1
	,LogDBErrSQLState -- Int2
	FROM DBErr
	
	UNION ALL
	SELECT 'CFErr'
	,LogCFErrID
	,LogCFErr_LogCFID
	,LogCFErr_UsrID
	,0 -- LogDBID
	,LogCFErrSort
	,0 -- JSSort
	,LogCFErrElapsed
	,LogCFErrName
	,LogCFErrDetail -- Description
	,LogCFErrDateTime
	,LogCFErr_RemoteAddr
	,LogCFErrMessage -- Varchar1
	,LogCFErrType -- Varchar2
	,LogCFErrEventName -- Varchar3
	,'' -- Varchar4
	,'' -- Varchar5
	,'' -- Varchar6
	,LogCFErrNumber -- Int1
	,LogCFErrLine -- Int2
	FROM CFErr
	
	UNION ALL
	SELECT 'UI'
	,LogUIID
	,LogUI_LogCFID
	,LogUI_UsrID
	,0 -- LogDBID
	,0 -- Sort
	,LogUISort
	,LogUIElapsed
	,LogUIName
	,LogUIClass
	,LogUIDateTime

	,LogUI_RemoteAddr
	,LogUITagName -- Varchar1
	,LogUIDestination -- Varchar2
	,'' -- Varchar3
	,'' -- Varchar4
	,'' -- Varchar5
	,'' -- Varchar6
	,0 -- Int1
	,0 -- Int2
	FROM UI
	
	UNION ALL
	SELECT 'JS'
	,LogJSID
	,LogJS_LogCFID
	,LogJS_UsrID
	,0 -- LogDBID
	,0 -- Sort
	,LogJSSort
	,LogJSElapsed
	,LogJSName
	,LogJSDesc
	,LogJSDateTime
	,LogJS_RemoteAddr
	,'' -- Varchar1
	,'' -- Varchar2
	,'' -- Varchar3
	,'' -- Varchar4
	,'' -- Varchar5
	,'' -- Varchar6
	,0 AS Int1
	,0 AS Int2
	FROM JS
	ORDER BY LogDateTime DESC
	";
	local.fw0.LogDB = false;
	include "/Inc/execute.cfm";
	return local.result;
}
}
