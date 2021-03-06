USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_Tables]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Load_Tables]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	truncate table ReportCYData_Prod.dbo.[0_RPT_ASSESSMENT_NUM]

	insert into ReportCYData_Prod.dbo.[0_RPT_ASSESSMENT_NUM](SITE_NAME, SITE_ID, INDICATOR_AREA, SCALE_LOCAL, ASSESSMENT_NAME, SCALE_NUM, FISCAL_YEAR, SCHOOL_NAME, SCHOOL_ID, NATIONAL_NORM_SCALE, DATA_TYPE)
	select SITE_NAME, SITE_ID, INDICATOR_AREA, SCALE, ASSESSMENT_NAME, SCALE_NUM, FISCAL_YEAR, SCHOOL_NAME, SCHOOL_ID, NATIONAL_NORM_SCALE, DATA_TYPE from ReportCYData_Prod.dbo.vw_0_RPT_ASSESSMENT_NUM

	/*
	truncate table ReportCYData_Prod.dbo.[1_RPT_STUDENT_MAIN]
	
	insert ReportCYData_Prod.dbo.[1_RPT_STUDENT_MAIN]
	(STUDENT_ID, 
	CYSCHOOLHOUSE_STUDENT_ID, 
	StudentSF_ID,
	FIRST_NAME, 
	MIDDLE_NAME, 
	LAST_NAME, 
	REGION_ID, 
	REGION_NAME, 
	SITE_NAME,
	SCHOOL_ID, 
	CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	SCHOOL_NAME, 
	DIPLOMAS_NOW_SCHOOL, 
	GENDER, 
	GRADE_ID, 
	GRADE_DESC, 
	PRIMARY_CM_ID, 
	PRIMARY_CM_NAME, 
	Attendance_IA, 
	ELA_IA, 
	Math_IA, 
	Behavior_IA, 
	FISCAL_YEAR, 
	ELL, 
	Race_Ethnicity,
	[Student_District_ID],
	[CYSCHOOLHOUSE_SCHOOL_ID],
	ELA_PRIMARY_CM_ID,
	ELA_PRIMARY_CM_NAME,
	MATH_PRIMARY_CM_ID,
	MATH_PRIMARY_CM_NAME,
	ATT_PRIMARY_CM_ID,
	ATT_PRIMARY_CM_NAME,
	BEH_PRIMARY_CM_ID,
	BEH_PRIMARY_CM_NAME
	
	
	)
	select distinct 
	STUDENT_ID, 
	CYSCHOOLHOUSE_STUDENT_ID,
	StudentSF_ID, 
	FIRST_NAME, 
	MIDDLE_NAME, 
	LAST_NAME, 
	REGION_ID, 
	REGION_NAME, 
	SITE_NAME, 
	SCHOOL_ID,
	CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	SCHOOL_NAME, 
	DIPLOMAS_NOW_SCHOOL, 
	GENDER, 
	GRADE_ID, 
	GRADE_DESC, 
	PRIMARY_CM_ID, 
	PRIMARY_CM_NAME, 
	Attendance_IA, 
	ELA_IA, 
	Math_IA, 
	Behavior_IA, 
	FISCAL_YEAR, 
	ELL, 
	Ethnicity, 
	[Student_District_ID], 
	[CYSchoolhouse_School_ID], 
	ELA_PRIMARY_CM_ID,
	ELA_PRIMARY_CM_NAME,
	MATH_PRIMARY_CM_ID,
	MATH_PRIMARY_CM_NAME,
	ATT_PRIMARY_CM_ID,
	ATT_PRIMARY_CM_NAME,
	BEH_PRIMARY_CM_ID,
	BEH_PRIMARY_CM_NAME
	from ReportCYData_Prod.dbo.vw_1_RPT_STUDENT_MAIN

	--ADDED 60 NEW FIELDS TO TABLE 2----------------------------------------------------------------------------------
	
	truncate table ReportCYData_Prod.dbo.[2_RPT_SCHOOL_MAIN]

	insert into ReportCYData_Prod.dbo.[2_RPT_SCHOOL_MAIN]
	(SCHOOL_ID, 
	CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	SCHOOL_NAME, 
--	REGION_ID, 
	REGION_NAME, 
--	SITE_ID, 
	SITE_NAME, 
	DIPLOMAS_NOW_SCHOOL, 
--	COMPARE_VAL1, 
--	COMPARE_VAL2, 
--	COMPARE_VAL3, 
--	COMPARE_VAL4, 
--	COMPARE_VAL5, 

	SCM,
	CM,
	SCMCMsW_FLs,
	ELA_CMwFL,
	WSWC_ELA_39_EnrollGoal,
	ELA_out39_Enroll,
	ELA_All_Enroll,
	MTH_CMwFL,
	WSWC_MTH_39_EnrollGoal,
	MTH_out39_Enroll,
	MTH_All_Enroll,
	ATT_CMwFL,
	WSWC_ATT_39_EnrollGoal,
	ATT_out39_enroll,
	ATT_All_Enroll,
	BEH_CMwFL,
	WSWC_BEH_39_EnrollGoal,
	BEH_out39_Enroll,
	BEH_All_Enroll,
	Q1_ELA_EnrollGoalPerc,
	Q1_MTH_EnrollGoalPerc,
	Q1_ATT_EnrollGoalPerc,
	Q1_BEH_EnrollGoalPerc,
	Q2_ELA_EnrollGoalPerc,
	Q2_MTH_EnrollGoalPerc,
	Q2_ATT_EnrollGoalPerc,
	Q2_BEH_EnrollGoalPerc,
	Q3_ELA_EnrollGoalPerc,
	Q3_MTH_EnrollGoalPerc,
	Q3_ATT_EnrollGoalPerc,
	Q3_BEH_EnrollGoalPerc,
	AUG_ELA_DosageGoal,
	SEP_ELA_DosageGoal,
	OCT_ELA_DosageGoal,
	NOV_ELA_DosageGoal,
	DEC_ELA_DosageGoal,
	JAN_ELA_DosageGoal,
	FEB_ELA_DosageGoal,
	MAR_ELA_DosageGoal,
	APR_ELA_DosageGoal,
	MAY_ELA_DosageGoal,
	JUN_ELA_DosageGoal,
	AUG_MTH_DosageGoal,
	SEP_MTH_DosageGoal,
	OCT_MTH_DosageGoal,
	NOV_MTH_DosageGoal,
	DEC_MTH_DosageGoal,
	JAN_MTH_DosageGoal,
	FEB_MTH_DosageGoal,
	MAR_MTH_DosageGoal,
	APR_MTH_DosageGoal,
	MAY_MTH_DosageGoal,
	JUN_MTH_DosageGoal,
	Q1_ELA_EnrollGoal,
	Q2_ELA_EnrollGoal,
	Q3_ELA_EnrollGoal,
	AUG_ELA_DosageGoal_Minutes,
	SEP_ELA_DosageGoal_Minutes,
	OCT_ELA_DosageGoal_Minutes,
	NOV_ELA_DosageGoal_Minutes,
	DEC_ELA_DosageGoal_Minutes,
	JAN_ELA_DosageGoal_Minutes,
	FEB_ELA_DosageGoal_Minutes,
	MAR_ELA_DosageGoal_Minutes,
	APR_ELA_DosageGoal_Minutes,
	MAY_ELA_DosageGoal_Minutes,
	JUN_ELA_DosageGoal_Minutes,
	AUG_MTH_DosageGoal_Minutes,
	SEP_MTH_DosageGoal_Minutes,
	OCT_MTH_DosageGoal_Minutes,
	NOV_MTH_DosageGoal_Minutes,
	DEC_MTH_DosageGoal_Minutes,
	JAN_MTH_DosageGoal_Minutes,
	FEB_MTH_DosageGoal_Minutes,
	MAR_MTH_DosageGoal_Minutes,
	APR_MTH_DosageGoal_Minutes,
	MAY_MTH_DosageGoal_Minutes,
	JUN_MTH_DosageGoal_Minutes,	
	
	CY_SCHOOLHOUSE_SCHOOL_ID,
	[CY_CHANNEL_ID], 
	CY_CHANNEL_SF_ID, 
	FISCAL_YEAR,
	
	[Q1_MTH_EnrollGoal],
	[Q2_MTH_EnrollGoal],
	[Q3_MTH_EnrollGoal],
	[Q1_BEH_EnrollGoal],
	[Q2_BEH_EnrollGoal],
	[Q3_BEH_EnrollGoal],
	[Q1_ATT_EnrollGoal],
	[Q2_ATT_EnrollGoal],
	[Q3_ATT_EnrollGoal])

	SELECT 
	SCHOOL_ID, 
	CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	SCHOOL_NAME, 
--	REGION_ID, 
	REGION_NAME, 
--	SITE_ID, 
	SITE_NAME, 
	DIPLOMAS_NOW_SCHOOL, 
--	COMPARE_VAL1, 
--	COMPARE_VAL2, 
--	COMPARE_VAL3, 
--	COMPARE_VAL4, 
--	COMPARE_VAL5, 
	SCM,
	CM,
	SCMCMsW_FLs,
	ELA_CMwFL,
	WSWC_ELA_39_EnrollGoal,
	ELA_out39_Enroll,
	ELA_All_Enroll,
	MTH_CMwFL,
	WSWC_MTH_39_EnrollGoal,
	MTH_out39_Enroll,
	MTH_All_Enroll,
	ATT_CMwFL,
	WSWC_ATT_39_EnrollGoal,
	ATT_out39_enroll,
	ATT_All_Enroll,
	BEH_CMwFL,
	WSWC_BEH_39_EnrollGoal,
	BEH_out39_Enroll,
	BEH_All_Enroll,
	Q1_ELA_EnrollGoalPerc,
	Q1_MTH_EnrollGoalPerc,
	Q1_ATT_EnrollGoalPerc,
	Q1_BEH_EnrollGoalPerc,
	Q2_ELA_EnrollGoalPerc,
	Q2_MTH_EnrollGoalPerc,
	Q2_ATT_EnrollGoalPerc,
	Q2_BEH_EnrollGoalPerc,
	Q3_ELA_EnrollGoalPerc,
	Q3_MTH_EnrollGoalPerc,
	Q3_ATT_EnrollGoalPerc,
	Q3_BEH_EnrollGoalPerc,
	AUG_ELA_DosageGoal,
	SEP_ELA_DosageGoal,
	OCT_ELA_DosageGoal,
	NOV_ELA_DosageGoal,
	DEC_ELA_DosageGoal,
	JAN_ELA_DosageGoal,
	FEB_ELA_DosageGoal,
	MAR_ELA_DosageGoal,
	APR_ELA_DosageGoal,
	MAY_ELA_DosageGoal,
	JUN_ELA_DosageGoal,
	AUG_MTH_DosageGoal,
	SEP_MTH_DosageGoal,
	OCT_MTH_DosageGoal,
	NOV_MTH_DosageGoal,
	DEC_MTH_DosageGoal,
	JAN_MTH_DosageGoal,
	FEB_MTH_DosageGoal,
	MAR_MTH_DosageGoal,
	APR_MTH_DosageGoal,
	MAY_MTH_DosageGoal,
	JUN_MTH_DosageGoal,
	Q1_ELA_EnrollGoal,
	Q2_ELA_EnrollGoal,
	Q3_ELA_EnrollGoal,
	AUG_ELA_DosageGoal_Minutes,
	SEP_ELA_DosageGoal_Minutes,
	OCT_ELA_DosageGoal_Minutes,
	NOV_ELA_DosageGoal_Minutes,
	DEC_ELA_DosageGoal_Minutes,
	JAN_ELA_DosageGoal_Minutes,
	FEB_ELA_DosageGoal_Minutes,
	MAR_ELA_DosageGoal_Minutes,
	APR_ELA_DosageGoal_Minutes,
	MAY_ELA_DosageGoal_Minutes,
	JUN_ELA_DosageGoal_Minutes,
	AUG_MTH_DosageGoal_Minutes,
	SEP_MTH_DosageGoal_Minutes,
	OCT_MTH_DosageGoal_Minutes,
	NOV_MTH_DosageGoal_Minutes,
	DEC_MTH_DosageGoal_Minutes,
	JAN_MTH_DosageGoal_Minutes,
	FEB_MTH_DosageGoal_Minutes,
	MAR_MTH_DosageGoal_Minutes,
	APR_MTH_DosageGoal_Minutes,
	MAY_MTH_DosageGoal_Minutes,
	JUN_MTH_DosageGoal_Minutes,	
	[CY_SCHOOLHOUSE_ID], 
	[CY_CHANNEL_ID],
	[CY_CHANNEL_SF_ID], 
	FISCAL_YEAR,
	[Q1_MTH_EnrollGoal],
	[Q2_MTH_EnrollGoal],
	[Q3_MTH_EnrollGoal],
	[Q1_BEH_EnrollGoal],
	[Q2_BEH_EnrollGoal],
	[Q3_BEH_EnrollGoal],
	[Q1_ATT_EnrollGoal],
	[Q2_ATT_EnrollGoal],
	[Q3_ATT_EnrollGoal]

	FROM ReportCYData_Prod.dbo.vw_2_RPT_SCHOOL_MAIN 
	
UPDATE [dbo].[2_RPT_SCHOOL_MAIN] SET

SCM							= b.scm,
CM							= b.cm,
SCMCMsW_FLs					= b.SCMCMsW_FLs,
ELA_CMwFL					= b.ELA_CMwFL,
WSWC_ELA_39_EnrollGoal		= b.WSWC_ELA_39_EnrollGoal,
ELA_out39_Enroll			= b.ELA_out39_Enroll,
ELA_All_Enroll				= b.ELA_All_Enroll,
MTH_CMwFL					= b.MTH_CMwFL,
WSWC_MTH_39_EnrollGoal		= b.WSWC_MTH_39_EnrollGoal,
MTH_out39_Enroll			= b.MTH_out39_Enroll,
MTH_All_Enroll				= b.MTH_All_Enroll,
ATT_CMwFL					= b.ATT_CMwFL,
WSWC_ATT_39_EnrollGoal		= b.WSWC_ATT_39_EnrollGoal,
ATT_out39_enroll			= b.ATT_out39_enroll,
ATT_All_Enroll				= b.ATT_All_Enroll,
BEH_CMwFL					= b.BEH_CMwFL,
WSWC_BEH_39_EnrollGoal		= b.WSWC_BEH_39_EnrollGoal,
BEH_out39_Enroll			= b.BEH_out39_Enroll,
BEH_All_Enroll				= b.BEH_All_Enroll,
Q1_ELA_EnrollGoalPerc = b.Q1_ELA_EnrollGoalPerc,
Q1_MTH_EnrollGoalPerc = b.Q1_MTH_EnrollGoalPerc,
Q1_ATT_EnrollGoalPerc = b.Q1_ATT_EnrollGoalPerc,
Q1_BEH_EnrollGoalPerc = b.Q1_BEH_EnrollGoalPerc,
Q2_ELA_EnrollGoalPerc = b.Q2_ELA_EnrollGoalPerc,
Q2_MTH_EnrollGoalPerc = b.Q2_MTH_EnrollGoalPerc,
Q2_ATT_EnrollGoalPerc = b.Q2_ATT_EnrollGoalPerc,
Q2_BEH_EnrollGoalPerc = b.Q2_BEH_EnrollGoalPerc,
Q3_ELA_EnrollGoalPerc = b.Q3_ELA_EnrollGoalPerc,
Q3_MTH_EnrollGoalPerc = b.Q3_MTH_EnrollGoalPerc,
Q3_ATT_EnrollGoalPerc = b.Q3_ATT_EnrollGoalPerc,
Q3_BEH_EnrollGoalPerc = b.Q3_BEH_EnrollGoalPerc,
AUG_ELA_DosageGoal = b.AUG_ELA_DosageGoal,
SEP_ELA_DosageGoal = b.SEP_ELA_DosageGoal,
OCT_ELA_DosageGoal = b.OCT_ELA_DosageGoal,
NOV_ELA_DosageGoal = b.NOV_ELA_DosageGoal,
DEC_ELA_DosageGoal = b.DEC_ELA_DosageGoal,
JAN_ELA_DosageGoal = b.JAN_ELA_DosageGoal,
FEB_ELA_DosageGoal = b.FEB_ELA_DosageGoal,
MAR_ELA_DosageGoal = b.MAR_ELA_DosageGoal,
APR_ELA_DosageGoal = b.APR_ELA_DosageGoal,
MAY_ELA_DosageGoal = b.MAY_ELA_DosageGoal,
JUN_ELA_DosageGoal = b.JUN_ELA_DosageGoal,
AUG_MTH_DosageGoal = b.AUG_MTH_DosageGoal,
SEP_MTH_DosageGoal = b.SEP_MTH_DosageGoal,
OCT_MTH_DosageGoal = b.OCT_MTH_DosageGoal,
NOV_MTH_DosageGoal = b.NOV_MTH_DosageGoal,
DEC_MTH_DosageGoal = b.DEC_MTH_DosageGoal,
JAN_MTH_DosageGoal = b.JAN_MTH_DosageGoal,
FEB_MTH_DosageGoal = b.FEB_MTH_DosageGoal,
MAR_MTH_DosageGoal = b.MAR_MTH_DosageGoal,
APR_MTH_DosageGoal = b.APR_MTH_DosageGoal,
MAY_MTH_DosageGoal = b.MAY_MTH_DosageGoal,
JUN_MTH_DosageGoal = b.JUN_MTH_DosageGoal,
Q1_ELA_EnrollGoal = b.Q1_ELA_EnrollGoal,
Q2_ELA_EnrollGoal = b.Q2_ELA_EnrollGoal,
Q3_ELA_EnrollGoal = b.Q3_ELA_EnrollGoal,
AUG_ELA_DosageGoal_Minutes = b.AUG_ELA_DosageGoal_Minutes,
SEP_ELA_DosageGoal_Minutes = b.SEP_ELA_DosageGoal_Minutes,
OCT_ELA_DosageGoal_Minutes = b.OCT_ELA_DosageGoal_Minutes,
NOV_ELA_DosageGoal_Minutes = b.NOV_ELA_DosageGoal_Minutes,
DEC_ELA_DosageGoal_Minutes = b.DEC_ELA_DosageGoal_Minutes,
JAN_ELA_DosageGoal_Minutes = b.JAN_ELA_DosageGoal_Minutes,
FEB_ELA_DosageGoal_Minutes = b.FEB_ELA_DosageGoal_Minutes,
MAR_ELA_DosageGoal_Minutes = b.MAR_ELA_DosageGoal_Minutes,
APR_ELA_DosageGoal_Minutes = b.APR_ELA_DosageGoal_Minutes,
MAY_ELA_DosageGoal_Minutes = b.MAY_ELA_DosageGoal_Minutes,
JUN_ELA_DosageGoal_Minutes = b.JUN_ELA_DosageGoal_Minutes,
AUG_MTH_DosageGoal_Minutes = b.AUG_MTH_DosageGoal_Minutes,
SEP_MTH_DosageGoal_Minutes = b.SEP_MTH_DosageGoal_Minutes,
OCT_MTH_DosageGoal_Minutes = b.OCT_MTH_DosageGoal_Minutes,
NOV_MTH_DosageGoal_Minutes = b.NOV_MTH_DosageGoal_Minutes,
DEC_MTH_DosageGoal_Minutes = b.DEC_MTH_DosageGoal_Minutes,
JAN_MTH_DosageGoal_Minutes = b.JAN_MTH_DosageGoal_Minutes,
FEB_MTH_DosageGoal_Minutes = b.FEB_MTH_DosageGoal_Minutes,
MAR_MTH_DosageGoal_Minutes = b.MAR_MTH_DosageGoal_Minutes,
APR_MTH_DosageGoal_Minutes = b.APR_MTH_DosageGoal_Minutes,
MAY_MTH_DosageGoal_Minutes = b.MAY_MTH_DosageGoal_Minutes,
JUN_MTH_DosageGoal_Minutes = b.JUN_MTH_DosageGoal_Minutes,
Q1_MTH_EnrollGoal = b.Q1_MTH_EnrollGoal,
Q2_MTH_EnrollGoal = b.Q2_MTH_EnrollGoal,
Q3_MTH_EnrollGoal = b.Q3_MTH_EnrollGoal,
Q1_BEH_EnrollGoal = b.Q1_BEH_EnrollGoal,
Q2_BEH_EnrollGoal = b.Q2_BEH_EnrollGoal,
Q3_BEH_EnrollGoal = b.Q3_BEH_EnrollGoal,
Q1_ATT_EnrollGoal = b.Q1_ATT_EnrollGoal,
Q2_ATT_EnrollGoal = b.Q2_ATT_EnrollGoal,
Q3_ATT_EnrollGoal = b.Q3_ATT_EnrollGoal

FROM [dbo].[2_RPT_SCHOOL_MAIN] a inner join [dbo].[Goals_Dosage_2] b
							ON	Substring(a.[CY_CHANNEL_SF_ID],1,15)  = b.[CY_CHANNEL_SF_ID]  



UPDATE [dbo].[2_RPT_SCHOOL_MAIN] SET

[GrantCategory]  = b.[GrantCategory],
[GrantSiteNum]   = b.[GrantSiteNum],
[GrantSite]      = b.[GrantSite]

FROM [dbo].[2_RPT_SCHOOL_MAIN] a inner join [dbo].[FY16_Schools_And_ACGrants] b
                                 ON a.[CY_CHANNEL_SF_ID] = b.[CY_CHANNEL_SF_ID]

	
UPDATE [dbo].[2_RPT_SCHOOL_MAIN] SET

	[ACREPORTLIT]			= b.[ACREPORTLIT],
	[ACREPORTMTH]			= 	b.[ACREPORTMTH],
	[ACREPORTATT]			= 	b.[ACREPORTATT],
	[ACREPORTBEH]			= 	b.[ACREPORTBEH],
	[ED1_ACAD_GOAL]			= 	b.[ED1_ACAD_GOAL],
	[ED2_ACAD_GOAL]			= 	b.[ED2_ACAD_GOAL],
	[ED5_ACAD_GOAL]			= 	b.[ED5_ACAD_GOAL],
	[ED1_ENGAGE_GOAL]		= 	b.[ED1_ENGAGE_GOAL],
	[ED2_ENGAGE_GOAL]		= 	b.[ED2_ENGAGE_GOAL],
	[ED27B_ENGAGE_GOAL]		= 	b.[ED27B_ENGAGE_GOAL],
	[AC_SEL_OUPUT1_GOAL]	= 	b.[AC_SEL_OUPUT1_GOAL],
	[AC_SEL_OUTPUT2_GOAL]	= 	b.[AC_SEL_OUTPUT2_GOAL],
	[AC_SELOUTCOME_GOAL]	= 	b.[AC_SELOUTCOME_GOAL]

FROM [dbo].[2_RPT_SCHOOL_MAIN] a inner join [dbo].[FY16_AC_Goals] b
on a.[GrantSiteNum] = b.[GrantSiteNum]

   
*/


   --TABLE 3------------------------------------------------------------------------------------------------------------------------------------------

	truncate table ReportCYData_Prod.dbo.[3_RPT_STUDENT_ENROLLMENT]

	INSERT INTO ReportCYData_Prod.dbo.[3_RPT_STUDENT_ENROLLMENT]
	SELECT * FROM  SDW_Stage_Prod.[dbo].[vw_TBL_3_Enrollments]

--	insert into ReportCYData_Prod.dbo.[3_RPT_STUDENT_ENROLLMENT](STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC, ENROLLED_DAYS, FIRST_INTERVENTION, LAST_INTERVENTION, CURRENTLY_ENROLLED, INVALID_ENROLLMENT, FISCAL_YEAR, [SITE_NAME], [SCHOOL_NAME], [SCHOOL_ID], [CYSCHOOLHOUSE_STUDENT_ID], DIPLOMAS_NOW, STUDENTNAME)
--	select distinct STUDENT_ID, PROGRAM_DESCRIPTION, INDICATOR_AREA_DESC, ENROLLED_DAYS, BEGIN_DATE_USED, END_DATE_USED, CURRENTLY_ENROLLED, INVALID_ENROLLMENT, FISCAL_YEAR, [SITE_NAME], [SCHOOL_NAME], [SCHOOL_ID], [CYSCHOOLHOUSE_STUDENT_ID], DIPLOMAS_NOW,STUDENTNAME FROM ReportCYData_Prod.dbo.vw_3_RPT_STUDENT_ENROLLMENT (nolock)

	truncate table ReportCYData_Prod.dbo.[4_RPT_DIPLOMAS_NOW]
	
	insert into ReportCYData_Prod.dbo.[4_RPT_DIPLOMAS_NOW](SCHOOL_ID, CYCHANNEL_SCHOOL_ACCOUNT_NBR, SCHOOL_NAME, DIPLOMAS_NOW_SCHOOL, FISCAL_YEAR, SITE_NAME, SITE_ID)
	select SCHOOL_ID, CYCHANNEL_SCHOOL_ACCOUNT_NBR, SCHOOL_NAME, DIPLOMAS_NOW_SCHOOL, FISCAL_YEAR, SITE_NAME, SITE_ID from ReportCYData_Prod.dbo.vw_4_RPT_DIPLOMAS_NOW (nolock)

	truncate table ReportCYData_Prod.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]

	select INDICATOR_DESC, SITE_NAME, SCHOOL_NAME, STUDENT_NAME, SKILL_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, ENTRY_DATE, CREATE_BY, FISCAL_YEAR, DIPLOMAS_NOW, STudentID, CY_StudentID, DATA_TYPE, GRADE, SKILL_DESC Placeholder
	into #TempTable5
	from ReportCYData_Prod.dbo.vw_5_RPT_CY_L_SCHOOL_PERFORMANCE (nolock)

	update 	#TempTable5
	set Placeholder = SKILL_DESC
	where DATA_TYPE like '%Course%Grade%' or Indicator_Desc = 'Attendance'

	
	update #TempTable5 set INDICATOR_DESC = NULL Where SKILL_DESC like '%Attendance%'


	update #TempTable5
	set SKILL_DESC = DATA_TYPE
	where DATA_TYPE like '%Course%Grade%' or Indicator_Desc = 'Attendance'

	update #TempTable5
	set DATA_TYPE = Placeholder
	where DATA_TYPE like '%Course%Grade%' or Indicator_Desc = 'Attendance'

	insert into ReportCYData_Prod.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE](INDICATOR_AREA_DESC, SITE_NAME, SCHOOL_NAME, STUDENT_NAME, SKILL_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, ENTRY_DATE, CREATED_BY, FISCAL_YEAR, DIPLOMAS_NOW_SCHOOL, STUDENT_ID, CYSCHOOLHOUSE_STUDENT_ID, DATA_TYPE, GRADE)
	select INDICATOR_DESC, SITE_NAME, SCHOOL_NAME, STUDENT_NAME, SKILL_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, ENTRY_DATE, CREATE_BY, FISCAL_YEAR, DIPLOMAS_NOW, STudentID, CY_StudentID, DATA_TYPE, GRADE from #TempTable5 (nolock)

	truncate table ReportCYData_Prod.dbo.[6_RPT_SCALE_NORMALIZATION]

	insert into ReportCYData_Prod.dbo.[6_RPT_SCALE_NORMALIZATION](SCHOOL_ID, INDICATOR_DESC, SCALE_LOCAL, SITE_SCHOOL_DESC, NATIONAL_NORM_SCALE, FISCAL_YEAR)
	select SchoolID, IndicatorArea, Scale, SchoolName, National_Benchmark, SchoolYear from ReportCYData_Prod.dbo.vw_6_RPT_SCALE_NORMALIZATION

--	truncate table ReportCYData_Prod.dbo.[7_RPT_CG_NORMALIZE]

--	insert into ReportCYData_Prod.dbo.[7_RPT_CG_NORMALIZE](TIME1_ELA_CG_VALUE_DISPLAY, CG_LETTERSCALE_ALL, LETTER_VIEW, FISCAL_YEAR)
--	select PERFORMANCE_DISPLAY, CG_LETTERSCALE_ALL, LETTER_VIEW, FISCAL_YEAR from vw_7_RPT_CG_NORMALIZE

	truncate table ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR]

	insert into ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR](STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC, TTL_TIME, FISCAL_YEAR, CYSCHOOLHOUSE_STUDENT_ID, SITE_NAME, SCHOOL_NAME, SCHOOL_ID)
	select StudentID, ProgramDescription, IndicatorArea, TTL_Time, SchoolYear, CY_StudentID, SITE_NAME, SCHOOL_NAME, SCHOOL_ID from ReportCYData_Prod.dbo.vw_8_RPT_STUDENT_TIME_LINEAR
	

	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '0-4.99 hours' where TTL_TIME between 0 and 299
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '5-9.99 hours' where TTL_TIME >= 300 and TTL_TIME < 600
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '10-14.99 hours' where TTL_TIME >= 600 and TTL_TIME < 900
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '15-19.99 hours' where TTL_TIME >= 900 and TTL_TIME < 1200
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '20-24.99 hours' where TTL_TIME >= 1200 and TTL_TIME < 1500
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '25-34.99 hours' where TTL_TIME >= 1500 and TTL_TIME < 2100
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '35 to 49.99 hours' where TTL_TIME >= 2100 and TTL_TIME < 3000
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '50+ hours' where TTL_TIME >= 3000

	--SPLIT SCHOOL UPDATE 
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Hennigan Elementary School' where school_name = 'Hennigan Elementary School (6-7)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Father Keith B. Kenny' where school_name = 'Father Keith B. Kenny (7-8)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'McKay K-8 School' where school_name = 'McKay K-8 School (6-8)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Higginson Lewis K-8 School' where school_name = 'Higginson Lewis K-8 School (6-8)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Mildred Ave K-8 School' where school_name = 'Mildred Ave K-8 School (6-8)'





/* NOT USING VIEWS FOR TABLE 9. STORED PROCEDURES AND STAGE TABLES ARE BEING USED. COMMENTED OUT ON 10/1/2015

	truncate table ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_AS]

	insert into ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_AS](CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, DATE_OF_ASSESSMSNT, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH)
	select CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH
	from ReportCYData_Prod.dbo.[vw_9_RPT_PERFORMANCE_LEVEL_AS]

	truncate table ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_AT]

	insert into ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_AT](CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, DATE_OF_ASSESSMSNT, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH)
	select CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH
	from ReportCYData_Prod.dbo.[vw_9_RPT_PERFORMANCE_LEVEL_AT]

	truncate table ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_BH]

	insert into ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_BH](CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, DATE_OF_ASSESSMSNT, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH)
	select CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH
	from ReportCYData_Prod.dbo.[vw_9_RPT_PERFORMANCE_LEVEL_BH]

	truncate table ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_CG]

	insert into ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_CG](CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, DATE_OF_ASSESSMSNT, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH)
	select CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH
	from ReportCYData_Prod.dbo.[vw_9_RPT_PERFORMANCE_LEVEL_CG]

	truncate table ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_SB]

	insert into ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL_SB](CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, DATE_OF_ASSESSMSNT, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH)
	select CYSCHOOLHOUSE_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, IS_NUMERIC, PERFORMANCE_VALUE_NUMERIC, PERFORMANCE_VALUE_DISPLAY, LETTER_GRADE_RANK, LETTER_GRADE_RANK_NORM, PERFORMANCE_VALUE_ID, SCALE_LOCAL, SCALE_EVAL, TAG_OG, TAG_AC, FISCAL_YEAR, SITE_ID, SCHOOL_ID, INDICATOR_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH
	from ReportCYData_Prod.dbo.[vw_9_RPT_PERFORMANCE_LEVEL_SB]
*/


/*
	truncate table ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL]
	
	insert into ReportCYData_Prod.dbo.[9_RPT_PERFORMANCE_LEVEL](STUDENT_ID, CYSCHOOLHOUSE_ID, SKILL_DESCRIPTION, INTERVAL, INDICATOR_DESC, FREQ_SORT, SCHOOL_NAME, SITE_NAME, STUDENT_NAME, SCHOOL_ID, SITE_ID, PERF_DATE, PERFORMANCE_VALUE, PERFORMANCE_VALUE_NUMERIC, SCALE_LOCAL, SCALE_EVAL, PERF_RUN_DATE, CG_VALUE_DISPLAY, CG_VALUE_NUM, CG_LETTER_VIEW, CG_LETTER_VIEW_ALL, Tag, FISCAL_YEAR)
	select STUDENT_ID, CYSCHOOLHOUSE_ID, SKILL_DESCRIPTION, INTERVAL, INDICATOR_DESC, FREQ_SORT, SCHOOL_NAME, SITE_NAME, STUDENT_NAME, SCHOOL_ID, SITE_ID, PERF_DATE, PERFORMANCE_VALUE, PERFORMANCE_VALUE_NUMERIC, SCALE_LOCAL, SCALE_EVAL, PERF_RUN_DATE, CG_VALUE_DISPLAY, CG_VALUE_NUM, CG_LETTER_VIEW, CG_LETTER_VIEW_ALL, Tag, FISCAL_YEAR from vw_9_RPT_PERFORMANCE_LEVEL

	truncate table ReportCYData_Prod.dbo.[13_RPT_PERFORMANCE_LEVEL_BEH]

	insert into ReportCYData_Prod.dbo.[13_RPT_PERFORMANCE_LEVEL_BEH](STUDENT_ID, FREQUENCY_PERIOD_ID, INTERVAL, OFFICE_REFERRALS, DETENTIONS, SUSPENSIONS, TOTAL_INCIDENTS, SCHOOL_NAME, SITE_NAME, STUDENT_NAME, STUDENT_GRADE, SCHOOL_ID, SITE_ID, PERF_RUN_DATE, INTERVENTION_TIME, TAG, FISCAL_YEAR)
	select STUDENT_ID, FREQUENCY_PERIOD_ID, INTERVAL, OFFICE_REFERRALS, DETENTIONS, SUSPENSIONS, TOTAL_INCIDENTS, SCHOOL_NAME, SITE_NAME, STUDENT_NAME, STUDENT_GRADE, SCHOOL_ID, SITE_ID, PERF_RUN_DATE, INTERVENTION_TIME, TAG, FISCAL_YEAR
	from vw_13_RPT_PERFORMANCE_LEVEL_BEH
*/
END
















GO
