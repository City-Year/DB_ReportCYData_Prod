USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[Operating_Goals]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operating_Goals](
	[Region_Name] [varchar](255) NULL,
	[Site_Name] [varchar](255) NULL,
	[School_Name] [varchar](255) NULL,
	[cyschoolhouse_school_id] [varchar](255) NULL,
	[cychannel_school_id] [varchar](255) NULL,
	[Literacy_Growth_Goal] [float] NULL,
	[ELA_Prevention_Goal] [float] NULL,
	[ELA_Recovery_Goal] [float] NULL,
	[Math_Growth_Goal] [float] NULL,
	[Math_Prevention_Goal] [float] NULL,
	[Math_Recovery_Goal] [float] NULL,
	[Attendance_Growth_Goal] [float] NULL,
	[Attendance_Prevention_Goal] [float] NULL,
	[Attendance_Recovery_Goal] [float] NULL
) ON [PRIMARY]

GO
