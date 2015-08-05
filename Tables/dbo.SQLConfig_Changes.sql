CREATE TABLE [dbo].[SQLConfig_Changes]
(
[TextData] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostName] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplicationName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatabaseName] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPID] [int] NULL,
[StartTime] [datetime] NULL,
[EventSequence] [int] NULL
) ON [PRIMARY]
GO
