USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[10_RPT_PERFORMANCE_LEVEL_ATT]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[10_RPT_PERFORMANCE_LEVEL_ATT](
	[STUDENT_ID] [int] NOT NULL,
	[FREQUENCY_PERIOD_ID] [int] NOT NULL,
	[SKILL_ID] [int] NULL,
	[MISSED_DAYS] [int] NULL,
	[DAYS_ENROLLED] [int] NULL,
	[CALCULATED_ADA] [varchar](70) NULL,
	[PERF_ADA] [float] NULL,
	[YEAR_TO_DATE_CUMULATIVE_ADA] [int] NULL,
	[INTERVAL] [varchar](50) NULL,
	[FREQ_SORT] [int] NULL,
	[SCHOOL_NAME] [varchar](70) NULL,
	[SITE_NAME] [varchar](70) NULL,
	[STUDENT_NAME] [varchar](70) NULL,
	[STUDENT_GRADE] [varchar](70) NULL,
	[SCHOOL_ID] [int] NULL,
	[SITE_ID] [int] NULL,
	[SCALE_LOCAL] [varchar](50) NULL,
	[SCALE_EVAL] [varchar](50) NULL,
	[SCALE_TYPE] [varchar](50) NULL,
	[PERF_RUN_DATE] [datetime] NULL,
	[INTERVENTION_TIME] [int] NULL,
	[INVALID_ADA] [varchar](70) NULL,
	[Tag] [varchar](4) NULL,
	[FISCAL_YEAR] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
