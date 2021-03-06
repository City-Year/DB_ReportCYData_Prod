USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[9_RPT_PERFORMANCE_LEVEL]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[9_RPT_PERFORMANCE_LEVEL](
	[STUDENT_ID] [int] NOT NULL,
	[CYSCHOOLHOUSE_ID] [varchar](250) NULL,
	[SKILL_DESCRIPTION] [varchar](250) NULL,
	[INTERVAL] [varchar](250) NULL,
	[INDICATOR_DESC] [varchar](250) NULL,
	[FREQ_SORT] [int] NULL,
	[SCHOOL_NAME] [varchar](250) NULL,
	[SITE_NAME] [varchar](250) NULL,
	[STUDENT_NAME] [varchar](250) NULL,
	[SCHOOL_ID] [int] NULL,
	[SITE_ID] [int] NULL,
	[PERF_DATE] [datetime] NULL,
	[PERFORMANCE_VALUE] [varchar](250) NULL,
	[PERFORMANCE_VALUE_NUMERIC] [varchar](250) NULL,
	[SCALE_LOCAL] [varchar](250) NULL,
	[SCALE_EVAL] [varchar](250) NULL,
	[PERF_RUN_DATE] [datetime] NULL,
	[CG_VALUE_DISPLAY] [varchar](250) NULL,
	[CG_VALUE_NUM] [float] NULL,
	[CG_LETTER_VIEW] [varchar](250) NULL,
	[CG_LETTER_VIEW_ALL] [varchar](250) NULL,
	[Tag] [varchar](250) NULL,
	[FISCAL_YEAR] [varchar](250) NOT NULL
) ON [PRIMARY]

GO
