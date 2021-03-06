USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[alpha_9_9]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alpha_9_9](
	[Site] [nvarchar](255) NULL,
	[School] [nvarchar](255) NULL,
	[Grade] [float] NULL,
	[IA] [nvarchar](255) NULL,
	[Skill_Description] [nvarchar](255) NULL,
	[Data_Type] [nvarchar](255) NULL,
	[DATE_RANGE_MIN] [datetime] NULL,
	[DATE_RANGE_MAX] [datetime] NULL,
	[PERFORMANCE_VALUE_DISPLAY] [nvarchar](255) NULL,
	[Scale_Local] [nvarchar](255) NULL,
	[Scale_Norm] [nvarchar](255) NULL,
	[Score_Rank] [nvarchar](255) NULL,
	[Score_Rank_Norm] [nvarchar](255) NULL,
	[Scale_Num_Local] [float] NULL,
	[Scale_Num_Norm] [float] NULL,
	[Used_For_Summative_Reporting] [float] NULL,
	[Date Diff] [float] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
