USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[SCHOOL_BASED_TEAMS]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCHOOL_BASED_TEAMS](
	[TEAM_NUMBER] [varchar](250) NULL,
	[TEAM_NAME] [varchar](250) NULL,
	[CY_CHANNEL_ACCT_#] [varchar](50) NULL,
	[SCHOOL_NAME] [varchar](250) NULL,
	[TEAM_TYPE] [varchar](250) NULL,
	[SERVICE_YEAR] [varchar](250) NULL,
	[SCHOOL_NAME_NORMALIZED] [varchar](250) NULL
) ON [PRIMARY]

GO
