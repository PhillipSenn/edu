use fw
set nocount on
set statistics time off
set statistics io off
SET ANSI_NULL_DFLT_OFF ON -- All columns default to NOT NULL
GO
if exists (select * from sysobjects where id = object_id(N'Domain') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Domain
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'DomainView'))
DROP VIEW DomainView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogCFCID')
DROP SEQUENCE LogCFCID
if exists (select * from sysobjects where id = object_id(N'LogCFC') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogCFC
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogCFCView'))
DROP VIEW LogCFCView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogCFErrID')
DROP SEQUENCE LogCFErrID
if exists (select * from sysobjects where id = object_id(N'LogCFErr') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogCFErr
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogCFErrView'))
DROP VIEW LogCFErrView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogDBErrID')
DROP SEQUENCE LogDBErrID
if exists (select * from sysobjects where id = object_id(N'LogDBErr') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogDBErr
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogDBErrView'))
DROP VIEW LogDBErrView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogCFID')
DROP SEQUENCE LogCFID
if exists (select * from sysobjects where id = object_id(N'LogCF') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogCF
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogCFView'))
DROP VIEW LogCFView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogDBID')
DROP SEQUENCE LogDBID
if exists (select * from sysobjects where id = object_id(N'LogDB') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogDB
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogDBView'))
DROP VIEW LogDBView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogUIID')
DROP SEQUENCE LogUIID
if exists (select * from sysobjects where id = object_id(N'LogUI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogUI
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogUIView'))
DROP VIEW LogUIView

IF  EXISTS (SELECT * FROM sys.sequences WHERE name = 'LogJSID')
DROP SEQUENCE LogJSID
if exists (select * from sysobjects where id = object_id(N'LogJS') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogJS
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogJSView'))
DROP VIEW LogJSView


--
-- Tables
--
CREATE TABLE Domain(
DomainID Int Identity Primary Key NONCLUSTERED
,DomainName Varchar(256)
)
GO
if exists (select * from sysobjects where id = object_id(N'LogCF') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogCF
GO
CREATE TABLE LogCF(
LogCFID BigInt Primary Key -- Logged when either there's a database error or a ColdFusion error.
,LogCF_DomainID Int
,LogCF_UsrID Int default 0 -- This relates to the Usr table in the domain
,LogCFSort Int default 0 -- request.LogDBSort
,LogCFElapsed Int default 0 -- #GetTickCount() - local.tickCount# Start Time
,LogCFOutString Varchar(max) default '' -- http://stackoverflow.com/questions/17813403/get-generated-content-in-coldfusion
-- http://www.stephenwithington.com/blog/index.cfm/2008/8/26/CGI-Variables-and-Their-Respective-ColdFusionJava-Servlet-Alternative-Methods
,LogCFQueryString Varchar(512) default '' -- getPageContext().getRequest().getQueryString()
,LogCFName Varchar(512) default '' -- getPageContext().getRequest().getServletPath()
,LogCFUserAgent Varchar(512) default '' -- getPageContext().getRequest().getHeader("User-Agent")
,LogCFURL Varchar(max) default ''
,LogCFForm Varchar(max) default ''
,LogCFSession Varchar(max) default ''
,LogCFDateTime DateTime2 default getdate()
,RemoteAddr Varchar(15) default '' -- getPageContext().getRequest().getRemoteAddr()
)
GO
CREATE SEQUENCE LogCFID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO
if exists (select * from sysobjects where id = object_id(N'LogCFC') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogCFC
GO
CREATE TABLE LogCFC(
LogCFCID BigInt Primary Key
,LogCFC_DomainID Int
,LogCFC_LogCFID Int default 0 -- If there's a request.fw0.LogCFID, then use it. I need to worry about remote jobs as well though.
,LogCFCName Varchar(512) default '' -- This needs to be the name of the component.
,LogCFCDesc Varchar(512) default '' -- And then this could be the name of the function.
,LogCFCSort Int default 0 -- request.LogDBSort
,LogCFCElapsed Int default 0 -- #GetTickCount() - local.tickCount# Start Time
,LogCFCDateTime DateTime2 default getdate()
)
GO

CREATE SEQUENCE LogCFCID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO
if exists (select * from sysobjects where id = object_id(N'LogCFErr') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogCFErr
GO
CREATE TABLE LogCFErr(
LogCFErrID BigInt Primary Key -- Identity 
,LogCFErr_DomainID Int
,LogCFErr_LogCFID Int default 0
,LogCFErrName Varchar(512) default '' -- name
,LogCFErrSort Int default 0 -- request.LogDBSort
,LogCFErrNumber Int default 0 -- errnumber
,LogCFErrElapsed Int default 0 -- #GetTickCount() - local.tickCount#
,LogCFErrLine Int default 0 -- Exception.TagContext[1].Line

,LogCFErrDetail Varchar(max) default '' -- detail
,LogCFErrMessage Varchar(max) default '' -- message
,LogCFErrType Varchar(512) default '' -- type
,LogCFErrEventName Varchar(512) default '' -- function onError(Exception,EventName)
,LogCFErrDateTime DateTime2 default getdate()
)
GO
CREATE SEQUENCE LogCFErrID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO

if exists (select * from sysobjects where id = object_id(N'LogDB') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogDB
GO
CREATE TABLE LogDB(
LogDBID BigInt Primary Key -- Every database call is potentially logged.
,LogDB_DomainID Int
,LogDB_LogCFID Int default 0 -- The ColdFusion page that made this call.
,LogDBName Varchar(max) default '' -- sql stmt + any other logging I might want to log
,LogDBSort Int default 0 -- request.LogDBSort
,LogDBComponentName Varchar(512) default ''
,LogDBFunctionName Varchar(512) default ''
,LogDBRecordCount Int default 0
,LogDBElapsed Int default 0 -- #GetTickCount() - local.tickCount# Start Time
,LogDBExecutionTime Int default 0
,LogDBDateTime DateTime2 default getdate()
)
GO
CREATE SEQUENCE LogDBID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO
if exists (select * from sysobjects where id = object_id(N'LogDBErr') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogDBErr
GO
CREATE TABLE LogDBErr(
LogDBErrID BigInt Primary Key
,LogDBErr_DomainID Int
,LogDBErr_LogDBID Int default 0
,LogDBErrName Varchar(max) default '' -- Exception.Message
,LogDBErrDesc Varchar(max) default '' -- Exception.Detail
,LogDBErrSort Int default 0 -- request.LogDBErrSort
,LogDBErrElapsed Int default 0 -- #GetTickCount() - local.tickCount#
,LogDBErrCode Int default 0 -- NativeErrorCode
,LogDBErrSQLState Int default 0 -- SQLState
,LogDBErrType Varchar(512) default '' -- type
-- ,LogDBErrWhere Varchar(max) default '' -- I don't think this ever produces anything
,LogDBErrDateTime DateTime2 default getdate()
)
GO

CREATE SEQUENCE LogDBErrID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO
if exists (select * from sysobjects where id = object_id(N'LogJS') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogJS
GO
CREATE TABLE LogJS(
LogJSID BigInt Primary Key
,LogJS_DomainID Int
,LogJS_LogCFID Int default 0
,LogJSName Varchar(512) default ''
,LogJSDesc Varchar(max) default ''
,LogJSSort Int default 0 -- Separate from request.LogDBSort because LogJS is posted via Ajax.
,LogJSPathName Varchar(512) default ''
,LogJSElapsed Int default 0 -- #GetTickCount() - local.tickCount# Start Time
,LogJSDateTime DateTime2 default getdate()
)
GO
CREATE SEQUENCE LogJSID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO
if exists (select * from sysobjects where id = object_id(N'LogUI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LogUI
GO
CREATE TABLE LogUI(
LogUIID BigInt Primary Key -- Every User Interaction is potentially logged
,LogUI_DomainID Int
,LogUI_LogCFID Int default 0
,LogUIName Varchar(512) default ''
,LogUISort Int default 0 -- Separate from request.fw0.LogDBSort because LogUI is posted via Ajax.
,LogUIElapsed Int default 0 -- #GetTickCount() - local.tickCount#
,LogUITag Varchar(6) default '' -- anchor, button
,LogUITagName Varchar(512) default '' -- myName
,LogUIIdentifier Varchar(512) default ''  -- #myID
,LogUIClass Varchar(512) default '' -- .myClass.label-success
,LogUIDestination Varchar(512) default '' -- href or action
,LogUIValue Varchar(max) default ''
,LogUIDateTime DateTime2 default getdate()
)
GO
CREATE SEQUENCE LogUIID
	MINVALUE 1
	MAXVALUE 100
	cycle
	cache
GO





--
-- Views
--
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'DomainView'))
DROP VIEW DomainView
GO
CREATE View DomainView AS
SELECT *
FROM Domain
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogCFView'))
DROP VIEW LogCFView
GO
CREATE View LogCFView AS
SELECT *
FROM LogCF
JOIN Domain
ON LogCF_DomainID = DomainID
--JOIN DOMAIN'S UsrView
--ON LogCF_UsrID = UsrID
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogCFCView'))
DROP VIEW LogCFCView
GO
CREATE View LogCFCView AS
SELECT *
FROM LogCFC
JOIN Domain
ON LogCFC_DomainID = DomainID
JOIN LogCF -- View
ON LogCFC_LogCFID = LogCFID
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogCFErrView'))
DROP VIEW LogCFErrView
GO
CREATE View LogCFErrView AS
SELECT *
FROM LogCFErr
JOIN Domain
ON LogCFErr_DomainID = DomainID
JOIN LogCF -- View
ON LogCFErr_LogCFID = LogCFID
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogDBView'))
DROP VIEW LogDBView
GO
CREATE View LogDBView AS
SELECT *
FROM LogDB
JOIN Domain
ON LogDB_DomainID = DomainID
JOIN LogCF -- View
ON LogDB_LogCFID = LogCFID
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogDBErrView'))
DROP VIEW LogDBErrView
GO
CREATE View LogDBErrView AS
SELECT *
FROM LogDBErr
JOIN Domain
ON LogDBErr_DomainID = DomainID
JOIN LogDB -- View
ON LogDBErr_LogDBID = LogDBID
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogJSView'))
DROP VIEW LogJSView
GO
CREATE View LogJSView AS
SELECT *
FROM LogJS
JOIN Domain
ON LogJS_DomainID = DomainID
JOIN LogCF -- View
ON LogJS_LogCFID = LogCFID
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'LogUIView'))
DROP VIEW LogUIView
GO
CREATE View LogUIView AS
SELECT *
FROM LogUI
JOIN Domain
ON LogUI_DomainID = DomainID
JOIN LogCF -- View
ON LogUI_LogCFID = LogCFID
GO

--
-- Data
--
DECLARE @DomainID Int
INSERT INTO Domain(DomainName) VALUES('PhillipSenn.com/edu')
SELECT @DomainID = Scope_Identity()
INSERT INTO LogCF(LogCFID,LogCF_DomainID) VALUES(0,@DomainID) -- LogCFErr relates to LogCF
INSERT INTO LogDB(LogDBID,LogDB_DomainID) VALUES(0,@DomainID) -- LogDBErr relates to LogDB

DECLARE @LogCFID BigInt=0
DECLARE @MaxCFID BigInt
SELECT @MaxCFID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogCFID' ;
WHILE (@LogCFID < @MaxCFID) BEGIN
	SELECT @LogCFID = NEXT VALUE FOR LogCFID
	INSERT INTO LogCF(LogCF_DomainID,LogCFID) VALUES(@DomainID,@LogCFID)
END

DECLARE @LogCFCID BigInt=0
DECLARE @MaxCFCID BigInt
SELECT @MaxCFCID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogCFCID' ;
WHILE (@LogCFCID < @MaxCFCID) BEGIN
	SELECT @LogCFCID = NEXT VALUE FOR LogCFCID
	INSERT INTO LogCFC(LogCFC_DomainID,LogCFCID) VALUES(@DomainID,@LogCFCID)
END

DECLARE @LogCFErrID BigInt=0
DECLARE @MaxCFErrID BigInt
SELECT @MaxCFErrID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogCFErrID' ;
WHILE (@LogCFErrID < @MaxCFErrID) BEGIN
	SELECT @LogCFErrID = NEXT VALUE FOR LogCFErrID
	INSERT INTO LogCFErr(LogCFErr_DomainID,LogCFErrID) VALUES(@DomainID,@LogCFErrID)
END

DECLARE @LogDBID BigInt=0
DECLARE @MaxDBID BigInt
SELECT @MaxDBID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogDBID' ;
WHILE (@LogDBID < @MaxDBID) BEGIN
	SELECT @LogDBID = NEXT VALUE FOR LogDBID
	INSERT INTO LogDB(LogDB_DomainID,LogDBID) VALUES(@DomainID,@LogDBID)
END

DECLARE @LogDBErrID BigInt=0
DECLARE @MaxDBErrID BigInt
SELECT @MaxDBErrID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogDBErrID' ;
WHILE (@LogDBErrID < @MaxDBErrID) BEGIN
	SELECT @LogDBErrID = NEXT VALUE FOR LogDBErrID
	INSERT INTO LogDBErr(LogDBErr_DomainID,LogDBErrID) VALUES(@DomainID,@LogDBErrID)
END

DECLARE @LogJSID BigInt=0
DECLARE @MaxJSID BigInt
SELECT @MaxJSID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogJSID' ;
WHILE (@LogJSID < @MaxJSID) BEGIN
	SELECT @LogJSID = NEXT VALUE FOR LogJSID
	INSERT INTO LogJS(LogJS_DomainID,LogJSID) VALUES(@DomainID,@LogJSID)
END

DECLARE @LogUIID BigInt=0
DECLARE @MaxUIID BigInt
SELECT @MaxUIID = CAST(maximum_value AS BigInt) FROM sys.sequences WHERE name = 'LogUIID' ;
WHILE (@LogUIID < @MaxUIID) BEGIN
	SELECT @LogUIID = NEXT VALUE FOR LogUIID
	INSERT INTO LogUI(LogUI_DomainID,LogUIID) VALUES(@DomainID,@LogUIID)
END
Select * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE='BASE TABLE'
ORDER BY TABLE_SCHEMA,TABLE_NAME
