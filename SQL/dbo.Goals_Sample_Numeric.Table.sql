USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[Goals_Sample_Numeric]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Goals_Sample_Numeric](
	[Site] [nvarchar](255) NULL,
	[School] [nvarchar](255) NULL,
	[GRADE] [float] NULL,
	[IA] [nvarchar](255) NULL,
	[Skill_Description] [nvarchar](255) NULL,
	[DATA_TYPE] [nvarchar](255) NULL,
	[DATE_RANGE_MIN] [datetime] NULL,
	[DATE_RANGE_MAX] [datetime] NULL,
	[PERFORMANCE_VALUE_DISPLAY_MIN] [float] NULL,
	[PERFORMANCE_VALUE_DISPLAY_MAX] [float] NULL,
	[SCALE_LOCAL] [nvarchar](255) NULL,
	[SCALE_NUM_LOCAL] [nvarchar](255) NULL,
	[SCALE_NORM] [nvarchar](255) NULL,
	[SCALE_NUM_NORM] [float] NULL,
	[USED_FOR_SUMMATIVE_REPORTING] [float] NULL,
	[PERORMANCE_VALUE] [nvarchar](255) NULL,
	[SCORE_RANK] [nvarchar](255) NULL,
	[SCORE_RANK_NORM] [nvarchar](255) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
