USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[FY16_Schools_And_ACGrants]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FY16_Schools_And_ACGrants](
	[CY_CHANNEL_SF_ID] [varchar](250) NULL,
	[GrantCategory] [varchar](250) NULL,
	[GrantSiteNum] [varchar](250) NULL,
	[GrantSite] [varchar](250) NULL
) ON [PRIMARY]

GO
