SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[usp_Capture_SQL_Config_Changes] @SendEmailTo VARCHAR(255) AS

CREATE TABLE #temp_cfg (
TEXTData VARCHAR(500),
HostName VARCHAR(155),
ApplicationName VARCHAR(255),
DatabaseName VARCHAR(155),
LoginName VARCHAR(155),
SPID INT,
StartTime DATETIME,
EventSequence INT
)

DECLARE @trc_path VARCHAR(500),
@message VARCHAR(MAX),
@message1 VARCHAR(MAX),
@textdata VARCHAR(1000)

SELECT @trc_path=CONVERT(VARCHAR(500),value) FROM fn_trace_getinfo(DEFAULT)
WHERE property=2

INSERT INTO #temp_cfg
SELECT TEXTData,HostName,ApplicationName,DatabaseName,LoginName,SPID,StartTime,EventSequence
FROM fn_trace_gettable(@trc_path,1) fn
WHERE TEXTData LIKE '%configure%'
--AND SPID<>@@spid
AND fn.EventSequence NOT IN (SELECT EventSequence FROM SQLConfig_Changes)
AND TEXTData NOT LIKE '%Insert into #temp_cfg%'
ORDER BY StartTime DESC


INSERT INTO dbo.SQLConfig_Changes
SELECT * FROM #temp_cfg

/*select TextData,HostName,ApplicationName,DatabaseName,LoginName,SPID,StartTime,EventSequence
from fn_trace_gettable(@trc_path,1) fn
where TextData like '%configure%'
and SPID<>@@spid
and fn.EventSequence not in (select EventSequence from SQLConfig_Changes)
order by StartTime desc*/

--select * from SQLConfig_Changes

IF @@ROWCOUNT > 0
--select @@ROWCOUNT

BEGIN
DECLARE c CURSOR FOR

SELECT LTRIM(REPLACE(SUBSTRING(TEXTdata,31,250), '. Run the RECONFIGURE statement to install.', '')) 
FROM #temp_cfg 

OPEN c

FETCH NEXT FROM c INTO @textdata

WHILE (@@FETCH_STATUS <> -1)
BEGIN
--FETCH c INTO @textdata

SELECT @message = @textdata + 'on server ' + @@servername + CHAR(13) 

SELECT @SendEmailTo, 'SQL Server Configuration Change Alert', @message

FETCH NEXT FROM c INTO @textdata

END





CLOSE c
DEALLOCATE c 

END

DROP TABLE #temp_cfg
GO
