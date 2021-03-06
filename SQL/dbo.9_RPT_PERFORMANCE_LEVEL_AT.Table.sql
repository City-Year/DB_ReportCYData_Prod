USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[9_RPT_PERFORMANCE_LEVEL_AT]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[9_RPT_PERFORMANCE_LEVEL_AT](
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](250) NULL,
	[STUDENT_NAME] [varchar](250) NULL,
	[SITE_NAME] [varchar](250) NULL,
	[SCHOOL_NAME] [varchar](250) NULL,
	[GRADE] [varchar](250) NULL,
	[DIPLOMAS_NOW_SCHOOL] [varchar](250) NULL,
	[INTERVAL] [varchar](250) NULL,
	[SKILL_ID] [varchar](250) NULL,
	[SKILL_DESCRIPTION] [varchar](250) NULL,
	[DATA_TYPE] [varchar](250) NULL,
	[INDICATOR_DESC] [varchar](250) NULL,
	[ASSESSMENT_DATE] [varchar](250) NULL,
	[PERFORMANCE_VALUE] [varchar](250) NULL,
	[TARGET_SCORE] [varchar](250) NULL,
	[TESTING_GRADE_LEVEL] [varchar](250) NULL,
	[SCORE_RANK] [varchar](250) NULL,
	[SCORE_RANK_NORM] [varchar](250) NULL,
	[SCALE_LOCAL] [varchar](250) NULL,
	[SCALE_NORM] [varchar](250) NULL,
	[SCALE_NUM_LOCAL] [varchar](250) NULL,
	[SCALE_NUM_NORM] [varchar](250) NULL,
	[TAG] [varchar](250) NULL,
	[USED_AS_MID_YEAR_DATA_POINT] [varchar](250) NULL,
	[USED_FOR_SUMMATIVE_REPORTING] [varchar](250) NULL,
	[FISCAL_YEAR] [varchar](250) NULL,
	[CYSCHOOLHOUSE_SCHOOL_ID] [varchar](250) NULL,
	[SCHOOL_ID] [varchar](250) NULL,
	[SITE_ID] [int] NULL,
	[CREATED_BY] [varchar](250) NULL,
	[ENTRY_DATE] [datetime] NULL,
	[LAST_REFRESH] [datetime] NULL
) ON [PRIMARY]

GO
