USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[3_RPT_STUDENT_ENROLLMENT]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[3_RPT_STUDENT_ENROLLMENT](
	[STUDENT_ID] [int] NOT NULL,
	[PROGRAM_DESC] [varchar](70) NOT NULL,
	[INDICATOR_AREA_DESC] [varchar](70) NOT NULL,
	[ENROLLED_DAYS] [int] NULL,
	[FIRST_INTERVENTION] [datetime] NULL,
	[LAST_INTERVENTION] [datetime] NULL,
	[CURRENTLY_ENROLLED] [varchar](50) NULL,
	[INVALID_ENROLLMENT] [varchar](50) NULL,
	[FISCAL_YEAR] [varchar](50) NOT NULL,
	[SITE_NAME] [varchar](250) NULL,
	[SCHOOL_NAME] [varchar](250) NULL,
	[SCHOOL_ID] [varchar](250) NULL,
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](250) NULL,
	[DIPLOMAS_NOW] [varchar](250) NULL,
	[StudentName] [varchar](250) NULL
) ON [PRIMARY]

GO
