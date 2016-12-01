USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[EVAL_ELA_CG]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVAL_ELA_CG](
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](255) NULL,
	[SCHOOL_ID] [varchar](255) NULL,
	[SITE_NAME] [varchar](255) NULL,
	[STUDENT_NAME] [varchar](255) NULL,
	[GRADE] [varchar](255) NULL,
	[Diplomas_Now_School] [varchar](255) NULL,
	[SCHOOL_NAME] [varchar](255) NULL,
	[INDICATOR_DESC] [varchar](255) NULL,
	[SKILL_DESCRIPTION] [varchar](255) NULL,
	[PRE_INTERVAL] [varchar](255) NULL,
	[PRE_DATE] [date] NULL,
	[PRE_VALUE] [varchar](255) NULL,
	[PRE_VALUE_NUM_LOCAL] [varchar](255) NULL,
	[PRE_VALUE_NUM_NORM] [varchar](255) NULL,
	[PRE_SCALE_LOCAL] [varchar](255) NULL,
	[PRE_SCALE_NORM] [varchar](255) NULL,
	[PRE_SCALE_RANK_LOCAL] [varchar](255) NULL,
	[PRE_SCALE_NORM_RANK] [varchar](255) NULL,
	[MY_INTERVAL] [varchar](255) NULL,
	[MY_DATE] [date] NULL,
	[MY_VALUE] [varchar](255) NULL,
	[MY_VALUE_NUM_LOCAL] [varchar](255) NULL,
	[MY_VALUE_NUM_NORM] [varchar](255) NULL,
	[MY_SCALE_LOCAL] [varchar](255) NULL,
	[MY_SCALE_NORM] [varchar](255) NULL,
	[MY_SCALE_RANK_LOCAL] [varchar](255) NULL,
	[MY_SCALE_NORM_RANK] [varchar](255) NULL,
	[POST_INTERVAL] [varchar](255) NULL,
	[POST_DATE] [date] NULL,
	[POST_VALUE] [varchar](255) NULL,
	[POST_VALUE_NUM_LOCAL] [varchar](255) NULL,
	[POST_VALUE_NUM_NORM] [varchar](255) NULL,
	[POST_SCALE_LOCAL] [varchar](255) NULL,
	[POST_SCALE_NORM] [varchar](255) NULL,
	[POST_SCALE_RANK_LOCAL] [varchar](255) NULL,
	[POST_SCALE_NORM_RANK] [varchar](255) NULL,
	[MY_RAWCHANGE] [varchar](255) NULL,
	[RAWCHANGE] [varchar](255) NULL,
	[MY_RAWCHANGE_NUM_LOCAL] [varchar](255) NULL,
	[RAWCHANGE_NUM_LOCAL] [varchar](255) NULL,
	[MY_RAWCHANGE_NUM_NORM] [varchar](255) NULL,
	[RAWCHANGE_NUM_NORM] [varchar](255) NULL,
	[MY_RAWCHANGE_NUM_LOCAL_DEGREE] [varchar](255) NULL,
	[RAWCHANGE_NUM_LOCAL_DEGREE] [varchar](255) NULL,
	[MY_RAWCHANGE_NUM_NORM_DEGREE] [varchar](255) NULL,
	[RAWCHANGE_NUM_NORM_DEGREE] [varchar](255) NULL,
	[MY_SCALE_CHANGE_LOCAL] [varchar](255) NULL,
	[SCALE_CHANGE_LOCAL] [varchar](255) NULL,
	[MY_SCALE_CHANGE_NORM] [varchar](255) NULL,
	[SCALE_CHANGE_NORM] [varchar](255) NULL,
	[MY_SCALE_CHANGE_LOCAL_TEXT] [varchar](255) NULL,
	[SCALE_CHANGE_LOCAL_TEXT] [varchar](255) NULL,
	[MY_SCALE_CHANGE_NORM_TEXT] [varchar](255) NULL,
	[SCALE_CHANGE_NORM_TEXT] [varchar](255) NULL,
	[STARTOFFSLIDING] [varchar](255) NULL,
	[MY_SOS_MoveOn] [varchar](255) NULL,
	[SOS_MoveOn] [varchar](255) NULL,
	[STARTBELOWB] [varchar](255) NULL,
	[MY_INCGRADELEVEL] [varchar](255) NULL,
	[INCGRADELEVEL] [varchar](255) NULL,
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
	[GRANTCATEGORY] [varchar](255) NULL,
	[SOY_REPORT] [varchar](50) NULL,
	[MY_REPORT] [varchar](50) NULL,
	[EOY_REPORT] [varchar](50) NULL,
	[STARTONSTAYON] [varchar](50) NULL,
	[SCALE_CHANGE_NORM_DEGREE] [varchar](20) NULL,
	[SCALE_CHANGE_LOCAL_DEGREE] [varchar](20) NULL,
	[RUN_DATE] [datetime] NULL
) ON [PRIMARY]

GO
