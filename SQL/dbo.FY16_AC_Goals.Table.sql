USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[FY16_AC_Goals]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FY16_AC_Goals](
	[GrantSiteNum] [varchar](250) NULL,
	[GrantSite_GR] [varchar](250) NULL,
	[ACREPORTLIT] [varchar](250) NULL,
	[ACREPORTMTH] [varchar](250) NULL,
	[ACREPORTATT] [varchar](250) NULL,
	[ACREPORTBEH] [varchar](250) NULL,
	[ED1_ACAD_GOAL] [varchar](250) NULL,
	[ED2_ACAD_GOAL] [varchar](250) NULL,
	[ED5_ACAD_GOAL] [varchar](250) NULL,
	[ED1_ENGAGE_GOAL] [varchar](250) NULL,
	[ED2_ENGAGE_GOAL] [varchar](250) NULL,
	[ED27B_ENGAGE_GOAL] [varchar](250) NULL,
	[AC_SEL_OUPUT1_GOAL] [varchar](250) NULL,
	[AC_SEL_OUTPUT2_GOAL] [varchar](250) NULL,
	[AC_SELOUTCOME_GOAL] [varchar](250) NULL
) ON [PRIMARY]

GO
