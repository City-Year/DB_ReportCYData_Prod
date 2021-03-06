USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[goals_numeric_backup]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[goals_numeric_backup](
	[Site] [nvarchar](255) NULL,
	[School] [nvarchar](255) NULL,
	[GRADE] [float] NULL,
	[IA] [nvarchar](255) NULL,
	[Skill_Description] [nvarchar](255) NULL,
	[      DATA_TYPE] [nvarchar](255) NULL,
	[DATE_RANGE_MIN] [datetime] NULL,
	[DATE_RANGE_MAX] [datetime] NULL,
	[PERFORMANCE_VALUE_DISPLAY _MIN] [float] NULL,
	[PERFORMANCE_VALUE_DISPLAY _MAX] [float] NULL,
	[      SCALE_LOCAL] [nvarchar](255) NULL,
	[      SCALE_NUM] [float] NULL,
	[      NATIONAL_NORM_SCALE] [nvarchar](255) NULL
) ON [PRIMARY]

GO
