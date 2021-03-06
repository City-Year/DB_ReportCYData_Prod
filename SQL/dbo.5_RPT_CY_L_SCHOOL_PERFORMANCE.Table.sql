USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[5_RPT_CY_L_SCHOOL_PERFORMANCE]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[5_RPT_CY_L_SCHOOL_PERFORMANCE](
	[INDICATOR_AREA_DESC] [varchar](200) NULL,
	[SITE_NAME] [varchar](200) NULL,
	[SCHOOL_NAME] [varchar](200) NULL,
	[STUDENT_NAME] [varchar](200) NULL,
	[SKILL_DESC] [varchar](200) NULL,
	[ASSESSMENT_DATE] [datetime] NULL,
	[PERFORMANCE_VALUE] [varchar](55) NULL,
	[ENTRY_DATE] [datetime] NULL,
	[CREATED_BY] [varchar](50) NULL,
	[FISCAL_YEAR] [varchar](50) NOT NULL,
	[DIPLOMAS_NOW_SCHOOL] [varchar](250) NULL,
	[STUDENT_ID] [varchar](250) NULL,
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](250) NULL,
	[DATA_TYPE] [varchar](250) NULL,
	[GRADE] [varchar](250) NULL,
	[Target_Score] [varchar](250) NULL,
	[Testing_grade_level] [varchar](250) NULL
) ON [PRIMARY]

GO
