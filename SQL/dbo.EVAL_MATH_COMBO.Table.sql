USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[EVAL_MATH_COMBO]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVAL_MATH_COMBO](
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](255) NULL,
	[SCHOOL_ID] [varchar](255) NULL,
	[SITE_NAME] [varchar](255) NULL,
	[STUDENT_NAME] [varchar](255) NULL,
	[GRADE] [varchar](255) NULL,
	[Diplomas_Now_School] [varchar](255) NULL,
	[SCHOOL_NAME] [varchar](255) NULL,
	[INDICATOR_DESC] [varchar](255) NULL,
	[PRE_SCALE_COMPARE] [varchar](255) NULL,
	[MY_SCALE_COMPARE] [varchar](255) NULL,
	[POST_SCALE_COMPARE] [varchar](255) NULL,
	[MY_SCALE_COMPARE_CHANGE] [varchar](255) NULL,
	[POST_SCALE_COMPARE_CHANGE] [varchar](255) NULL,
	[PRE_ASSESSMENT_VALUE] [varchar](255) NULL,
	[PRE_ASSESSMENT_DATE] [date] NULL,
	[PRE_ASSESSMENT_SCALE_LOCAL] [varchar](255) NULL,
	[PRE_ASSESSMENT_SCALE_NORM] [varchar](255) NULL,
	[MY_ASSESSMENT_VALUE] [varchar](255) NULL,
	[MY_ASSESSMENT_DATE] [date] NULL,
	[MY_ASSESSMENT_SCALE_LOCAL] [varchar](255) NULL,
	[MY_ASSESSMENT_SCALE_NORM] [varchar](255) NULL,
	[POST_ASSESSMENT_VALUE] [varchar](255) NULL,
	[POST_ASSESSMENT_DATE] [date] NULL,
	[POST_ASSESSMENT_SCALE_LOCAL] [varchar](255) NULL,
	[POST_ASSESSMENT_SCALE_NORM] [varchar](255) NULL,
	[ASSESSMENT_SKILL_DESCRIPTION] [varchar](255) NULL,
	[ASSESSMENT_DATA_TYPE] [varchar](255) NULL,
	[PRE_CG_INTERVAL] [varchar](255) NULL,
	[PRE_CG_DATE] [date] NULL,
	[PRE_CG_VALUE] [varchar](255) NULL,
	[PRE_CG_VALUE_NUM] [varchar](255) NULL,
	[PRE_CG_VALUE_NUM_NORM] [varchar](255) NULL,
	[PRE_CG_SCALE_LOCAL] [varchar](255) NULL,
	[PRE_CG_SCALE_NORM] [varchar](255) NULL,
	[PRE_CG_SCALE_RANK_LOCAL] [varchar](255) NULL,
	[PRE_CG_SCALE_NORM_RANK] [varchar](255) NULL,
	[MY_CG_INTERVAL] [varchar](255) NULL,
	[MY_CG_DATE] [date] NULL,
	[MY_CG_VALUE] [varchar](255) NULL,
	[MY_CG_VALUE_NUM] [varchar](255) NULL,
	[MY_CG_VALUE_NUM_NORM] [varchar](255) NULL,
	[MY_CG_SCALE_LOCAL] [varchar](255) NULL,
	[MY_CG_SCALE_NORM] [varchar](255) NULL,
	[MY_CG_SCALE_RANK_LOCAL] [varchar](255) NULL,
	[MY_CG_SCALE_NORM_RANK] [varchar](255) NULL,
	[POST_CG_INTERVAL] [varchar](255) NULL,
	[POST_CG_DATE] [date] NULL,
	[POST_CG_VALUE] [varchar](255) NULL,
	[POST_CG_VALUE_NUM] [varchar](255) NULL,
	[POST_CG_VALUE_NUM_NORM] [varchar](255) NULL,
	[POST_CG_SCALE_LOCAL] [varchar](255) NULL,
	[POST_CG_SCALE_NORM] [varchar](255) NULL,
	[POST_CG_SCALE_RANK_LOCAL] [varchar](255) NULL,
	[POST_CG_SCALE_NORM_RANK] [varchar](255) NULL,
	[Attendance_IA] [varchar](255) NULL,
	[ELA_IA] [varchar](255) NULL,
	[Math_IA] [varchar](255) NULL,
	[Behavior_IA] [varchar](255) NULL,
	[TEAM_JUNE_DOSAGE_GOAL] [varchar](255) NULL,
	[TEAM_MONTH_DOSAGE_GOAL] [varchar](255) NULL,
	[TTL_TIME] [varchar](255) NULL,
	[DOSAGE_CATEGORY] [varchar](255) NULL,
	[STATUS_JUNE_DOSAGE_GOAL] [varchar](255) NULL,
	[STATUS_MONTH_DOSAGE_GOAL] [varchar](255) NULL,
	[CURRENTLY_ENROLLED] [varchar](255) NULL,
	[ENROLLED_DAYS] [varchar](255) NULL,
	[FISCAL_YEAR] [varchar](255) NULL,
	[GRANTSITENUM] [varchar](255) NULL,
	[GRANTCATEGORY] [varchar](255) NULL
) ON [PRIMARY]

GO
