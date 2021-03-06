USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[EVAL_DESSA_MINI]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVAL_DESSA_MINI](
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](255) NULL,
	[SCHOOL_ID] [varchar](255) NULL,
	[SITE_NAME] [varchar](255) NULL,
	[STUDENT_NAME] [varchar](255) NULL,
	[GRADE] [varchar](255) NULL,
	[Diplomas_Now_School] [varchar](255) NULL,
	[SCHOOL_NAME] [varchar](255) NULL,
	[INDICATOR_DESC] [varchar](255) NULL,
	[SKILL_DESCRIPTION] [varchar](255) NULL,
	[PRE_DATE] [date] NULL,
	[PRE_INTERVAL] [varchar](255) NULL,
	[PRE_VALUE] [varchar](255) NULL,
	[PRE_VALUE_DESC] [varchar](255) NULL,
	[MY_DATE] [date] NULL,
	[MY_INTERVAL] [varchar](255) NULL,
	[MY_VALUE] [varchar](255) NULL,
	[MY_VALUE_DESC] [varchar](255) NULL,
	[POST_DATE] [date] NULL,
	[POST_INTERVAL] [varchar](255) NULL,
	[POST_VALUE] [varchar](255) NULL,
	[POST_VALUE_DESC] [varchar](255) NULL,
	[MY_DAYS_BETWEEN_ASSESSMENTS] [varchar](255) NULL,
	[DAYS_BETWEEN_ASSESSMENTS] [varchar](255) NULL,
	[MY_RAWCHANGE] [varchar](255) NULL,
	[RAWCHANGE] [float] NULL,
	[MY_RAWCHANGE_DEGREE] [varchar](255) NULL,
	[RAWCHANGE_DEGREE] [varchar](255) NULL,
	[MY_DESC_CHANGE] [varchar](255) NULL,
	[DESC_CHANGE] [varchar](255) NULL,
	[MY_DESC_CHANGE_DEGREE] [varchar](255) NULL,
	[DESC_CHANGE_DEGREE] [varchar](255) NULL,
	[Attendance_IA] [varchar](255) NULL,
	[ELA_IA] [varchar](255) NULL,
	[Math_IA] [varchar](255) NULL,
	[Behavior_IA] [varchar](255) NULL,
	[CURRENTLY_ENROLLED] [varchar](255) NULL,
	[ENROLLED_DAYS] [varchar](255) NULL,
	[MET_56_DAYS] [varchar](255) NULL,
	[GRADE_GROUP] [varchar](255) NULL,
	[FISCAL_YEAR] [varchar](255) NULL,
	[GRANTSITENUM] [varchar](255) NULL,
	[GRANTCATEGORY] [varchar](255) NULL,
	[RUN_DATE] [datetime] NULL
) ON [PRIMARY]

GO
