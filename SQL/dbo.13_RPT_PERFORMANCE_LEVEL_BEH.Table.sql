USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[13_RPT_PERFORMANCE_LEVEL_BEH]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[13_RPT_PERFORMANCE_LEVEL_BEH](
	[STUDENT_ID] [varchar](250) NULL,
	[FREQUENCY_PERIOD_ID] [varchar](250) NULL,
	[INTERVAL] [varchar](250) NULL,
	[OFFICE_REFERRALS] [varchar](250) NULL,
	[DETENTIONS] [varchar](250) NULL,
	[SUSPENSIONS] [varchar](250) NULL,
	[TOTAL_INCIDENTS] [varchar](250) NULL,
	[SCHOOL_NAME] [varchar](255) NOT NULL,
	[SITE_NAME] [varchar](250) NULL,
	[STUDENT_NAME] [varchar](250) NULL,
	[STUDENT_GRADE] [varchar](250) NULL,
	[SCHOOL_ID] [varchar](250) NULL,
	[SITE_ID] [varchar](250) NULL,
	[PERF_RUN_DATE] [varchar](250) NULL,
	[INTERVENTION_TIME] [varchar](250) NULL,
	[TAG] [varchar](250) NULL,
	[FISCAL_YEAR] [varchar](255) NULL
) ON [PRIMARY]

GO
