USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[d#TempTable5]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[d#TempTable5](
	[INDICATOR_DESC] [varchar](250) NULL,
	[SITE_NAME] [varchar](250) NULL,
	[SCHOOL_NAME] [varchar](255) NOT NULL,
	[STUDENT_NAME] [varchar](80) NULL,
	[SKILL_DESC] [varchar](250) NULL,
	[ASSESSMENT_DATE] [datetime] NOT NULL,
	[PERFORMANCE_VALUE] [varchar](250) NULL,
	[ENTRY_DATE] [date] NULL,
	[CREATE_BY] [varchar](250) NULL,
	[FISCAL_YEAR] [varchar](255) NULL,
	[DIPLOMAS_NOW] [int] NULL,
	[STudentID] [int] NOT NULL,
	[CY_StudentID] [varchar](30) NULL,
	[DATA_TYPE] [varchar](250) NULL,
	[GRADE] [varchar](150) NULL,
	[Placeholder] [varchar](250) NULL
) ON [PRIMARY]

GO
