USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_load_2_RPT_SCHOOL_MAIN]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE   PROCEDURE [dbo].[sp_load_2_RPT_SCHOOL_MAIN]
AS
BEGIN

SELECT DISTINCT 
	b.SchoolID AS SCHOOL_ID, 
	b.CYCh_Account_# AS CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	b.SchoolName AS SCHOOL_NAME, 
	b.Region AS REGION_NAME, 
	b.Business_Unit AS SITE_NAME, 
    CASE Diplomas_Now WHEN 'No' THEN 0 WHEN 'Yes' THEN 1 END AS DIPLOMAS_NOW_SCHOOL, 
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
		
		
	b.CYSch_SF_ID				AS CY_SCHOOLHOUSE_SCHOOL_ID, 
	b.CYCh_Account_#			AS CY_CHANNEL_ID, 
    b.CYCh_SF_ID				AS CY_CHANNEL_SF_ID, 
	'2015-2016'					AS FISCAL_YEAR,			--	c.SchoolYear				
	
	[Q1_MTH_EnrollGoal],
	[Q2_MTH_EnrollGoal],
	[Q3_MTH_EnrollGoal],
	[Q1_BEH_EnrollGoal],
	[Q2_BEH_EnrollGoal],
	[Q3_BEH_EnrollGoal],
	[Q1_ATT_EnrollGoal],
	[Q2_ATT_EnrollGoal],
	[Q3_ATT_EnrollGoal]

INTO   #TABLE2  

FROM				 
		            SDW_Prod.dbo.DimSchool AS b WITH (nolock) INNER JOIN
                    --SDW_Prod.dbo.DimGrade	AS c WITH (nolock) ON a.GradeID	 = c.GradeID	LEFT OUTER JOIN
					ReportCYData_Prod.dbo.Goals_Dosage_2	AS d WITH (nolock) ON d.CY_CHANNEL_SF_ID = b.CYCh_SF_ID --substring(b.CYCh_SF_ID,1,15)

/*
FROM				  SDW_Prod.dbo.FactAll	AS a WITH (nolock)								INNER JOIN
					  SDW_Prod.dbo.DimSchool AS b WITH (nolock) ON a.SchoolID = b.SchoolID	INNER JOIN
                      SDW_Prod.dbo.DimGrade	AS c WITH (nolock) ON a.GradeID	 = c.GradeID	LEFT OUTER JOIN
					  dbo.Goals_Dosage_2	AS d WITH (nolock) ON d.CY_CHANNEL_SF_ID = b.CYCh_SF_ID --substring(b.CYCh_SF_ID,1,15)
*/

UNION ALL

SELECT DISTINCT

    '' AS SCHOOL_ID, 
	Channel_Account_# AS CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	a.SchoolName AS SCHOOL_NAME,
	'' AS REGION_NAME, 
	Business_Unit AS SITE_NAME, 
    CASE DN WHEN 'No' THEN 0 WHEN 'Yes' THEN 1 END AS DIPLOMAS_NOW_SCHOOL, 
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
		
		
	a.CYSH_Account_ID			AS CY_SCHOOLHOUSE_SCHOOL_ID, 
	a.Channel_Account_#			AS CY_CHANNEL_ID,
    a.CYCh_Account_ID			AS CY_CHANNEL_SF_ID, 
	a.SchoolYear				AS FISCAL_YEAR,
	
	[Q1_MTH_EnrollGoal],
	[Q2_MTH_EnrollGoal],
	[Q3_MTH_EnrollGoal],
	[Q1_BEH_EnrollGoal],
	[Q2_BEH_EnrollGoal],
	[Q3_BEH_EnrollGoal],
	[Q1_ATT_EnrollGoal],
	[Q2_ATT_EnrollGoal],
	[Q3_ATT_EnrollGoal]
	FROM
	SDW_Stage_Prod.dbo.vw_SchoolAccounts_WO_Students a left outer join 
	ReportCYData_Prod.dbo.Goals_Dosage_2	AS b WITH (nolock) ON a.CYCH_Account_ID = b.CY_CHANNEL_SF_ID    --substring(a.CYCH_Account_ID,1,15)




	--UPDATE REGION

	UPDATE #Table2 set Region_name = 'Careforce' WHERE site_name = 'Careforce'
	UPDATE #Table2 set Region_name = 'Headquarters' WHERE site_name = 'Headquarters'
	UPDATE #Table2 set Region_name = 'Headquarters' WHERE site_name = 'Baltimore'
	UPDATE #Table2 set Region_name = 'Central' WHERE site_name = 'Dallas'
	UPDATE #Table2 set Region_name = 'Midwest' WHERE site_name = 'Kansas City'
	UPDATE #Table2 set Region_name = 'Headquarters' WHERE site_name = 'Las Vegas'
	UPDATE #Table2 set Region_name = 'South' WHERE site_name = 'Jacksonville'
	UPDATE #Table2 set Region_name = 'South' WHERE site_name = 'Miami'
	UPDATE #Table2 set Region_name = 'South' WHERE site_name = 'Orlando'
	UPDATE #Table2 set Region_name = 'Midwest' WHERE site_name = 'Chicago'
	UPDATE #Table2 set Region_name = 'Midwest' WHERE site_name = 'Cleveland'
	UPDATE #Table2 set Region_name = 'Midwest' WHERE site_name = 'Columbus'
	UPDATE #Table2 set Region_name = 'Midwest' WHERE site_name = 'Detroit'
	UPDATE #Table2 set Region_name = 'Midwest' WHERE site_name = 'Milwaukee'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'Boston'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'New Hampshire'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'New York'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'Philadelphia'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'Providence'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'Rhode Island'
	UPDATE #Table2 set Region_name = 'East' WHERE site_name = 'Washington, DC'
	UPDATE #Table2 set Region_name = 'Central' WHERE site_name = 'Baton Rouge'
	UPDATE #Table2 set Region_name = 'South' WHERE site_name = 'Columbia'
	UPDATE #Table2 set Region_name = 'South' WHERE site_name = 'Little Rock'
	UPDATE #Table2 set Region_name = 'Central' WHERE site_name = 'New Orleans'
	UPDATE #Table2 set Region_name = 'Central' WHERE site_name = 'San Antonio'
	UPDATE #Table2 set Region_name = 'Central' WHERE site_name = 'Tulsa'
	UPDATE #Table2 set Region_name = 'Central' WHERE site_name = 'Denver'

	UPDATE #Table2 set Region_name = 'West' WHERE site_name = 'Los Angeles'
	UPDATE #Table2 set Region_name = 'West' WHERE site_name = 'Sacramento'
	UPDATE #Table2 set Region_name = 'West' WHERE site_name = 'San Jose'
	UPDATE #Table2 set Region_name = 'West' WHERE site_name = 'Seattle'
	
	
	

	--UPDATE DIPLOMAS_NOW_SCHOOL FIELD----------------------------------------------------------------------------------

	UPDATE #Table2 set DIPLOMAS_NOW_SCHOOL = '0'

	UPDATE #Table2 set DIPLOMAS_NOW_SCHOOL = '1'
	WHERE School_Name IN (
							'Broadmoor Middle'
							,'Capitol Middle'
							,'English'
							,'McCormack Middle School'
							,'John Hope College Prepatory High School'
							,'Gage Park High School'
							,'Linden McKinley STEM Academy' 
							,'Mifflin High School'
							,'South High School'
							,'Noble Elementary-Middle School'
							,'Detroit Collegiate Preparatory High School @ Northwestern'
							,'Clinton MS'
							,'Jefferson HS'
							,'Manual Arts High School'
							,'Booker T. Washington HS'
							,'Miami Carol City HS'
							,'Homestead HS'
							,'Georgia Jones-Ayers Middle School'
							,'Newtown High School'
							,'M.S. 126K John Ericsson Middle School'
							,'Dimner Beeber Middle School'
							,'Grover Washington Middle School'
							,'Woodrow Wilson Middle School'
							,'Burbank High School'
							,'Rhodes Middle School (Philadelphia)'
							,'Rhodes Middle School (San Antonio)'
							,'Aki Kurose Middle School'
							,'Denny Middle School'
							,'Clinton Middle School'
							,'Webster High School'
							,'Cardozo Education Campus'
							
							)
	
	
truncate table [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN]

insert into   [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN]
    (SCHOOL_ID, 
	CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	SCHOOL_NAME,
	REGION_NAME, 
	SITE_NAME, 
    DIPLOMAS_NOW_SCHOOL, 
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
	CY_CHANNEL_ID, 
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

select
	SCHOOL_ID, 
	CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
	SCHOOL_NAME,
	REGION_NAME, 
	SITE_NAME, 
    DIPLOMAS_NOW_SCHOOL, 
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
	CY_CHANNEL_ID, 
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
	[Q3_ATT_EnrollGoal] 
	FROM
	#TABLE2
	WHERE [CY_CHANNEL_SF_ID] NOT IN ('001U000000oEj3uIAC','001U000001WBWSRIA5','001U000000NAz7bIAD')



--UPDATE GRANT FIELDS

UPDATE [dbo].[2_RPT_SCHOOL_MAIN] SET

[GrantCategory]  = b.[GrantCategory],
[GrantSiteNum]   = b.[GrantSiteNum],
[GrantSite]      = b.[GrantSite]

FROM [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN] a inner join [ReportCYData_Prod].[dbo].[FY16_Schools_And_ACGrants] b
                                 ON a.[CY_CHANNEL_SF_ID] = b.[CY_CHANNEL_SF_ID]


--UPDATE GOALS FIELDS

	

UPDATE [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN] SET
	[GrantSite_GR]          =   b.[GrantSite_GR],
	[ACREPORTLIT]			=   b.[ACREPORTLIT],
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


--UPDATE THE TEAM FIELDS-------------------------------------------------------

UPDATE [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN] SET

TEAMNUMBER = b.TEAM_NUMBER,
TEAMNAME   = b.TEAM_NAME

FROM [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN] a inner join [ReportCYData_Prod].[dbo].[SCHOOL_BASED_TEAMS] b
ON a.CYCHANNEL_SCHOOL_ACCOUNT_NBR = b.CY_CHANNEL_ACCT_# 
 

--DELETE WHERE THE SCHOOL IS SELECTED FROM THE MART AND THE VIEW CAUSING A DUP. DELETE THE RECORD WHERE SCHOOL_ID = '0'

DELETE FROM [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN] 
WHERE SCHOOL_NAME IN (Select school_name from [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN]
                      group by School_name
					  Having count(*) > 1)
AND School_ID = '0'					                                 

--REMOVE SPLIT SCHOOLS -------------------------------------------------------------------------------------

--'HENNIGAN ELEMENTARY SCHOOL (6-7)', 'FATHER KEITH B. KENNY (7-8)',Higginson Lewis K-8 School(6-8) and Mildred Ave K-8 School(6-8) SHOULD BE DELETED HERE:

DELETE  [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN] 
where CY_CHANNEL_SF_ID IN (select CY_CHANNEL_SF_ID  FROM [ReportCYData_Prod].[dbo].[2_RPT_SCHOOL_MAIN]
							group by CY_CHANNEL_SF_ID
							having count(*) > 1)
and SCHOOL_NAME like '%(%-%)%'


--DELETE THE REMAINING 12 SPLIT SCHOOL RECORDS
set rowcount 1
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Aptitude Community at Goss ES'
DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Condon Elementary School'
DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Curley K-8'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Higginson Lewis K-8 School'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'McKay K-8 School'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Mildred Ave K-8 School'
DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Orchard Gardens'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'PS 96M'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'PS- MS 57M'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Rosa Parks K-8 School'
DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Sarah Greenwood K-8'
--DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'Trotter Elementary School'
DELETE FROM [ReportCYData_Prod].dbo.[2_RPT_SCHOOL_MAIN] WHERE SCHOOL_NAME = 'PS- MS 57M (8)'
set rowcount 0


END














GO
