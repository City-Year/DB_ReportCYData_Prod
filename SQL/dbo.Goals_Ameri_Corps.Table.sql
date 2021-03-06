USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[Goals_Ameri_Corps]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Goals_Ameri_Corps](
	[Grant] [nvarchar](255) NULL,
	[SchoolTeam] [nvarchar](255) NULL,
	[SchoolName] [nvarchar](255) NULL,
	[GrantCategory] [float] NULL,
	[GrantSiteNum] [float] NULL,
	[GrantSite] [nvarchar](255) NULL,
	[cyschSchoolRefID] [nvarchar](255) NULL,
	[Location] [nvarchar](255) NULL,
	[School] [nvarchar](255) NULL
) ON [PRIMARY]

GO
