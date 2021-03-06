USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[12_RPT_PERFORMANCE_LEVEL_SB]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[12_RPT_PERFORMANCE_LEVEL_SB](
	[CONFIG_ID] [int] NULL,
	[STUDENT_ID] [int] NULL,
	[FREQUENCY_PERIOD_ID] [int] NULL,
	[FREQUENCY_MPO] [int] NULL,
	[SKILL_MPO] [int] NULL,
	[INTERVAL] [varchar](80) NULL,
	[STUDENT_NAME] [varchar](70) NULL,
	[SITE_ID] [int] NULL,
	[SITE_NAME] [varchar](70) NULL,
	[SCHOOL_ID] [int] NULL,
	[SCHOOL_NAME] [varchar](70) NULL,
	[SKILL_ID] [int] NULL,
	[SKILL_DESCRIPTION] [varchar](80) NULL,
	[INDICATOR_DESC] [varchar](50) NULL,
	[PERFORMANCE_VALUE_NUMERIC] [float] NULL,
	[SCALE_LOCAL] [varchar](50) NULL,
	[SCALE_EVAL] [varchar](50) NULL,
	[SCALE_TYPE] [varchar](50) NULL,
	[PERF_DIRECTION] [varchar](50) NULL,
	[INDICATOR_AREA_ID] [int] NULL,
	[PRIMARY_CM] [varchar](100) NULL,
	[DATA_POINT] [varchar](100) NULL,
	[Tag] [varchar](4) NULL
) ON [PRIMARY]

GO
