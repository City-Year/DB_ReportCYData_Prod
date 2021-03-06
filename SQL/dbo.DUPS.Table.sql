USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[DUPS]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DUPS](
	[Student_Name] [varchar](80) NULL,
	[Student_First] [varchar](100) NOT NULL,
	[Student_Last] [varchar](100) NULL,
	[Student_IA_Att] [decimal](1, 0) NULL,
	[Student_IA_Beh] [decimal](1, 0) NULL,
	[Student_IA_ELA] [decimal](1, 0) NULL,
	[Student_IA_Math] [decimal](1, 0) NULL,
	[Student_TTL_IAs_Assigned] [decimal](18, 0) NULL,
	[Student_Gender] [varchar](255) NULL,
	[Student_Ethnicity] [varchar](255) NULL,
	[Student_ELL] [int] NOT NULL,
	[Student_Grade] [varchar](255) NULL,
	[Student_DOB] [datetime] NULL,
	[Student_District_ID] [varchar](100) NULL,
	[Student_School_Year] [varchar](1300) NULL,
	[CY_Student_ID] [varchar](100) NULL,
	[Student_School_Name] [varchar](1300) NULL,
	[Student_SF_ID] [varchar](18) NOT NULL,
	[Section_Name] [varchar](80) NULL,
	[Core_Class__c] [int] NULL,
	[Assignment_Due_Date] [varchar](1300) NULL,
	[Assignment_Marking_Period] [varchar](5) NULL,
	[Assignment_Type] [varchar](1300) NULL,
	[Assignment_Name] [varchar](80) NULL,
	[Assignment_Subject] [varchar](12) NOT NULL,
	[Create_by] [varchar](121) NULL,
	[Entry_date] [datetime] NULL,
	[Grade_Name] [varchar](30) NULL,
	[Assignment_Entered_Grade] [varchar](10) NULL,
	[Assignment_Grade_Number] [decimal](5, 2) NULL,
	[Assignment_Weighted_Grade_Vale] [decimal](8, 2) NULL,
	[Business_Unit] [varchar](255) NULL,
	[CorpsName1] [varchar](80) NULL,
	[CorpsEmail1] [varchar](8000) NULL,
	[TeamName] [varchar](80) NULL,
	[TeamDescription] [varchar](1300) NULL,
	[cysch_Accnt_SF_ID] [varchar](18) NOT NULL,
	[cych_Accnt_SF_ID] [varchar](20) NULL,
	[Standard_Name] [varchar](80) NULL,
	[Grade_For_Standard] [varchar](18) NULL,
	[Identifier__c] [varchar](50) NULL,
	[Long_Text__c] [varchar](1300) NULL,
	[Grades_IA] [varchar](8) NOT NULL,
	[Session_Skills] [varchar](3) NOT NULL,
	[Program_Description] [varchar](3) NOT NULL,
	[count] [int] NULL
) ON [PRIMARY]

GO
