USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[1_RPT_STUDENT_MAIN]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[1_RPT_STUDENT_MAIN](
	[STUDENT_ID] [int] NOT NULL,
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](100) NULL,
	[StudentSF_ID] [varchar](250) NULL,
	[FIRST_NAME] [varchar](100) NULL,
	[MIDDLE_NAME] [varchar](100) NULL,
	[LAST_NAME] [varchar](100) NULL,
	[REGION_ID] [varchar](100) NULL,
	[REGION_NAME] [varchar](100) NULL,
	[SITE_NAME] [varchar](100) NULL,
	[SCHOOL_ID] [int] NULL,
	[CYCHANNEL_SCHOOL_ACCOUNT_NBR] [varchar](100) NULL,
	[SCHOOL_NAME] [varchar](100) NULL,
	[DIPLOMAS_NOW_SCHOOL] [varchar](15) NULL,
	[GENDER] [varchar](10) NULL,
	[GRADE_ID] [varchar](10) NULL,
	[GRADE_DESC] [varchar](100) NULL,
	[PRIMARY_CM_ID] [varchar](50) NULL,
	[PRIMARY_CM_NAME] [varchar](100) NULL,
	[Attendance_IA] [varchar](1) NULL,
	[ELA_IA] [varchar](1) NULL,
	[Math_IA] [varchar](1) NULL,
	[Behavior_IA] [varchar](1) NULL,
	[FISCAL_YEAR] [varchar](50) NOT NULL,
	[ELL] [varchar](250) NULL,
	[Race_Ethnicity] [varchar](250) NULL,
	[Student_District_ID] [varchar](250) NULL,
	[CYSCHOOLHOUSE_SCHOOL_ID] [varchar](250) NULL,
	[ELA_PRIMARY_CM_ID] [varchar](50) NULL,
	[ELA_PRIMARY_CM_NAME] [varchar](50) NULL,
	[MATH_PRIMARY_CM_ID] [varchar](50) NULL,
	[MATH_PRIMARY_CM_NAME] [varchar](50) NULL,
	[ATT_PRIMARY_CM_ID] [varchar](50) NULL,
	[ATT_PRIMARY_CM_NAME] [varchar](50) NULL,
	[BEH_PRIMARY_CM_ID] [varchar](50) NULL,
	[BEH_PRIMARY_CM_NAME] [varchar](50) NULL
) ON [PRIMARY]

GO
