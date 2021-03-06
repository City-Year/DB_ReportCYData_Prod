USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_2_RPT_SCHOOL_MAIN]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  VIEW [dbo].[vw_2_RPT_SCHOOL_MAIN]
AS
SELECT DISTINCT 
	a.SchoolID AS SCHOOL_ID, 
	b.CYCh_Account_# AS CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	b.SchoolName AS SCHOOL_NAME, 
--	'' AS REGION_ID, 
	b.Region AS REGION_NAME, 
--	'' AS SITE_ID, 
	b.Business_Unit AS SITE_NAME, 
    CASE Diplomas_Now WHEN 'No' THEN 0 WHEN 'Yes' THEN 1 END AS DIPLOMAS_NOW_SCHOOL, 
--	NULL AS COMPARE_VAL1, 
--	NULL AS COMPARE_VAL2, 
--	NULL AS COMPARE_VAL3, 
--	NULL AS COMPARE_VAL4, 
--	NULL AS COMPARE_VAL5,
--	CY_CHANNEL_SF_ID,
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
		
		
	b.CYSch_SF_ID				AS CY_SCHOOLHOUSE_ID, 
	b.CYCh_Account_#			AS CY_CHANNEL_ID, 
    b.CYCh_SF_ID				AS CY_CHANNEL_SF_ID, 
	c.SchoolYear				AS FISCAL_YEAR,

	[Q1_MTH_EnrollGoal],
	[Q2_MTH_EnrollGoal],
	[Q3_MTH_EnrollGoal],
	[Q1_BEH_EnrollGoal],
	[Q2_BEH_EnrollGoal],
	[Q3_BEH_EnrollGoal],
	[Q1_ATT_EnrollGoal],
	[Q2_ATT_EnrollGoal],
	[Q3_ATT_EnrollGoal]

FROM				  SDW_Prod.dbo.FactAll	AS a WITH (nolock)								INNER JOIN
                      SDW_Prod.dbo.DimSchool AS b WITH (nolock) ON a.SchoolID = b.SchoolID	INNER JOIN
                      SDW_Prod.dbo.DimGrade	AS c WITH (nolock) ON a.GradeID	 = c.GradeID	LEFT OUTER JOIN
					  dbo.Goals_Dosage_2	AS d WITH (nolock) ON d.CY_CHANNEL_SF_ID = b.CYCh_SF_ID



GO
