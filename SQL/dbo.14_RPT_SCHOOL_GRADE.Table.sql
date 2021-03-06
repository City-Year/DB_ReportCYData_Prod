USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[14_RPT_SCHOOL_GRADE]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[14_RPT_SCHOOL_GRADE](
	[SCHOOL_ID] [varchar](50) NULL,
	[GRADE_ID] [varchar](50) NULL,
	[INDICATOR_ID] [int] NULL,
	[B_RULE_VAL1] [float] NULL,
	[B_RULE_VAL2] [float] NULL,
	[B_RULE_VAL3] [float] NULL,
	[B_RULE_VAL4] [float] NULL,
	[B_RULE_VAL5] [float] NULL,
	[FISCAL_YEAR] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
