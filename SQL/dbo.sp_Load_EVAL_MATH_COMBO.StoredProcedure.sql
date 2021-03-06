USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_MATH_COMBO]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_EVAL_MATH_COMBO]
AS
BEGIN

TRUNCATE TABLE [dbo].[EVAL_MATH_COMBO] 

INSERT INTO [dbo].[EVAL_MATH_COMBO] 
	SELECT DISTINCT
	a.CYSCHOOLHOUSE_STUDENT_ID,
	a.SCHOOL_ID,
	a.SITE_NAME,
	a.STUDENT_NAME,
	a.GRADE,
	a.DIPLOMAS_NOW_SCHOOL,
	a.SCHOOL_NAME,
	a.INDICATOR_DESC,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	b.Fiscal_Year,
	NULL,
	NULL
	
 FROM [dbo].[EVAL_MATH_ASSESSMENT] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                                           ON  a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
										   AND a.SCHOOL_ID                = b.SCHOOL_ID
										   AND a.SITE_NAME                = b.SITE_NAME
										   AND a.STUDENT_NAME             = b.STUDENT_NAME
										   AND a.GRADE                    = b.GRADE
										   AND a.SCHOOL_NAME              = b.SCHOOL_NAME
										   AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
										   AND a.INDICATOR_DESC		      = b.INDICATOR_DESC

 WHERE (a.PRE_VALUE IS NOT NULL OR a.MY_VALUE IS NOT NULL OR a.POST_VALUE IS NOT NULL)
   AND (b.PRE_VALUE IS NOT NULL OR b.MY_VALUE IS NOT NULL OR b.POST_VALUE IS NOT NULL)
   

   
--PRE_SCALE_COMPARE-----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET

	PRE_SCALE_COMPARE = CASE WHEN a.PRE_SCALE_NORM IS NOT NULL AND b.PRE_SCALE_NORM IS NOT NULL 
							 THEN a.PRE_SCALE_NORM + '  in Assessments' + ',  ' + b.PRE_SCALE_NORM + '  in ELA CG'
							 ELSE NULL
						END


	FROM [dbo].[EVAL_MATH_ASSESSMENT] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
										   AND a.SCHOOL_ID                = b.SCHOOL_ID
										   AND a.SITE_NAME                = b.SITE_NAME
										   AND a.STUDENT_NAME             = b.STUDENT_NAME
										   AND a.GRADE                    = b.GRADE
										   AND a.SCHOOL_NAME              = b.SCHOOL_NAME
										   AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
										   AND a.INDICATOR_DESC		      = b.INDICATOR_DESC


--MY_SCALE_COMPARE-----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET

	MY_SCALE_COMPARE =  CASE WHEN a.MY_SCALE_NORM IS NOT NULL AND b.MY_SCALE_NORM IS NOT NULL 
							 THEN a.MY_SCALE_NORM + '  in Assessments' + ',  ' + b.MY_SCALE_NORM + '  in ELA CG'
							 ELSE NULL
						END


	FROM [dbo].[EVAL_MATH_ASSESSMENT] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
										   AND a.SCHOOL_ID                = b.SCHOOL_ID
										   AND a.SITE_NAME                = b.SITE_NAME
										   AND a.STUDENT_NAME             = b.STUDENT_NAME
										   AND a.GRADE                    = b.GRADE
										   AND a.SCHOOL_NAME              = b.SCHOOL_NAME
										   AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
										   AND a.INDICATOR_DESC		      = b.INDICATOR_DESC


--POST_SCALE_COMPARE-----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET

	POST_SCALE_COMPARE =  CASE WHEN a.POST_SCALE_NORM IS NOT NULL AND b.POST_SCALE_NORM IS NOT NULL 
							 THEN a.POST_SCALE_NORM +'  in Assessments' + ',  ' + b.POST_SCALE_NORM + '  in ELA CG'
							 ELSE NULL
						END


	FROM [dbo].[EVAL_MATH_ASSESSMENT] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
										   AND a.SCHOOL_ID                = b.SCHOOL_ID
										   AND a.SITE_NAME                = b.SITE_NAME
										   AND a.STUDENT_NAME             = b.STUDENT_NAME
										   AND a.GRADE                    = b.GRADE
										   AND a.SCHOOL_NAME              = b.SCHOOL_NAME
										   AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
										   AND a.INDICATOR_DESC		      = b.INDICATOR_DESC

--MY_SCALE_COMPARE_CHANGE-----------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET

	MY_SCALE_COMPARE_CHANGE =  CASE WHEN  a.PRE_SCALE_NORM IS NOT NULL AND b.MY_SCALE_NORM IS NOT NULL
											AND   a.PRE_SCALE_NORM = a.MY_SCALE_NORM
											AND   b.PRE_SCALE_NORM = b.MY_SCALE_NORM
											THEN  'REMAINED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' REMAINED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											WHEN  a.PRE_SCALE_NORM <> a.MY_SCALE_NORM
											AND   b.PRE_SCALE_NORM  = b.MY_SCALE_NORM
											THEN  'MOVED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' REMAINED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											WHEN  a.PRE_SCALE_NORM = a.MY_SCALE_NORM
											AND   b.PRE_SCALE_NORM <>  b.MY_SCALE_NORM
											THEN  'REMAINED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' MOVED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											WHEN  a.PRE_SCALE_NORM <> a.MY_SCALE_NORM
											AND   b.PRE_SCALE_NORM <>  b.MY_SCALE_NORM
											THEN  'MOVED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' MOVED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											ELSE NULL
											END

											

FROM [dbo].[EVAL_MATH_ASSESSMENT] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
											AND a.SCHOOL_ID                = b.SCHOOL_ID
										   AND a.SITE_NAME                = b.SITE_NAME
										   AND a.STUDENT_NAME             = b.STUDENT_NAME
										   AND a.GRADE                    = b.GRADE
										   AND a.SCHOOL_NAME              = b.SCHOOL_NAME
										   AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
										   AND a.INDICATOR_DESC		      = b.INDICATOR_DESC

--POST_SCALE_COMPARE_CHANGE----------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET

	POST_SCALE_COMPARE_CHANGE =  CASE WHEN  a.PRE_SCALE_NORM IS NOT NULL AND b.POST_SCALE_NORM IS NOT NULL
											AND   a.PRE_SCALE_NORM = a.POST_SCALE_NORM
											AND   b.PRE_SCALE_NORM = b.POST_SCALE_NORM
											THEN  'REMAINED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' REMAINED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											WHEN  a.PRE_SCALE_NORM <> a.POST_SCALE_NORM
											AND   b.PRE_SCALE_NORM  = b.POST_SCALE_NORM
											THEN  'MOVED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' REMAINED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											WHEN  a.PRE_SCALE_NORM = a.POST_SCALE_NORM
											AND   b.PRE_SCALE_NORM <>  b.POST_SCALE_NORM
											THEN  'REMAINED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' MOVED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											WHEN  a.PRE_SCALE_NORM <> a.POST_SCALE_NORM
											AND   b.PRE_SCALE_NORM <>  b.POST_SCALE_NORM
											THEN  'MOVED   ' + a.PRE_SCALE_NORM + '   in Assessments  ' + ' MOVED    ' + b.PRE_SCALE_NORM + '   in ELA CG'
											ELSE NULL
											END

											

FROM [dbo].[EVAL_MATH_ASSESSMENT] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
											AND a.SCHOOL_ID                = b.SCHOOL_ID
										   AND a.SITE_NAME                = b.SITE_NAME
										   AND a.STUDENT_NAME             = b.STUDENT_NAME
										   AND a.GRADE                    = b.GRADE
										   AND a.SCHOOL_NAME              = b.SCHOOL_NAME
										   AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
										   AND a.INDICATOR_DESC		      = b.INDICATOR_DESC

--ASSESSMENT_FIELDS-------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET 

PRE_ASSESSMENT_VALUE		= b.PRE_VALUE,
PRE_ASSESSMENT_DATE			= b.PRE_ASSESSMENT_DATE,
PRE_ASSESSMENT_SCALE_LOCAL	= b.PRE_SCALE_LOCAL,
PRE_ASSESSMENT_SCALE_NORM	= b.PRE_SCALE_NORM,

MY_ASSESSMENT_VALUE			= b.MY_VALUE,
MY_ASSESSMENT_DATE			= b.MY_ASSESSMENT_DATE,
MY_ASSESSMENT_SCALE_LOCAL	= b.MY_SCALE_LOCAL,
MY_ASSESSMENT_SCALE_NORM	= b.MY_SCALE_NORM,

POST_ASSESSMENT_VALUE		= b.POST_VALUE,
POST_ASSESSMENT_DATE		= b.POST_ASSESSMENT_DATE,
POST_ASSESSMENT_SCALE_LOCAL	= b.POST_SCALE_LOCAL,
POST_ASSESSMENT_SCALE_NORM	= b.POST_SCALE_NORM,

ASSESSMENT_SKILL_DESCRIPTION       = b.SKILL_DESCRIPTION,
ASSESSMENT_DATA_TYPE			   = b.DATA_TYPE

FROM [dbo].[EVAL_MATH_COMBO] a INNER JOIN [dbo].[EVAL_MATH_ASSESSMENT] b
                              ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
							  AND a.SCHOOL_ID                = b.SCHOOL_ID
							  AND a.SITE_NAME                = b.SITE_NAME
							  AND a.STUDENT_NAME             = b.STUDENT_NAME
							  AND a.GRADE                    = b.GRADE
							  AND a.SCHOOL_NAME              = b.SCHOOL_NAME
							  AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
							  AND a.INDICATOR_DESC		      = b.INDICATOR_DESC

select * from [EVAL_MATH_ASSESSMENT]


--CG FIELDS-----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_COMBO SET

PRE_CG_INTERVAL			= b.PRE_INTERVAL, 
PRE_CG_DATE				= b.PRE_DATE,
PRE_CG_VALUE			= b.PRE_VALUE,
PRE_CG_VALUE_NUM		= b.PRE_VALUE_NUM_LOCAL,
PRE_CG_VALUE_NUM_NORM	= b.PRE_VALUE_NUM_NORM,
PRE_CG_SCALE_LOCAL		= b.PRE_SCALE_LOCAL,
PRE_CG_SCALE_NORM		= b.PRE_SCALE_NORM,
PRE_CG_SCALE_RANK_LOCAL = b.PRE_SCALE_RANK_LOCAL,
PRE_CG_SCALE_NORM_RANK  = b.PRE_SCALE_NORM_RANK,

MY_CG_INTERVAL			= b.MY_INTERVAL, 
MY_CG_DATE				= b.MY_DATE,
MY_CG_VALUE				= b.MY_VALUE,
MY_CG_VALUE_NUM			= b.MY_VALUE_NUM_LOCAL,
MY_CG_VALUE_NUM_NORM	= b.MY_VALUE_NUM_NORM,
MY_CG_SCALE_LOCAL		= b.MY_SCALE_LOCAL,
MY_CG_SCALE_NORM		= b.MY_SCALE_NORM,
MY_CG_SCALE_RANK_LOCAL	= b.MY_SCALE_RANK_LOCAL,
MY_CG_SCALE_NORM_RANK	= b.MY_SCALE_NORM_RANK,

POST_CG_INTERVAL			= b.POST_INTERVAL,
POST_CG_DATE				= b.POST_DATE,
POST_CG_VALUE				= b.POST_VALUE,
POST_CG_VALUE_NUM			= b.POST_VALUE_NUM_LOCAL,
POST_CG_VALUE_NUM_NORM		= b.POST_VALUE_NUM_NORM,
POST_CG_SCALE_LOCAL			= b.POST_SCALE_LOCAL,
POST_CG_SCALE_NORM			= b.POST_SCALE_NORM,
POST_CG_SCALE_RANK_LOCAL	= b.POST_SCALE_RANK_LOCAL,
POST_CG_SCALE_NORM_RANK		= b.POST_SCALE_NORM_RANK

FROM [dbo].[EVAL_MATH_COMBO] a INNER JOIN [dbo].[EVAL_MATH_CG] b
                              ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
							  AND a.SCHOOL_ID                = b.SCHOOL_ID
							  AND a.SITE_NAME                = b.SITE_NAME
							  AND a.STUDENT_NAME             = b.STUDENT_NAME
							  AND a.GRADE                    = b.GRADE
							  AND a.SCHOOL_NAME              = b.SCHOOL_NAME
							  AND a.DIPLOMAS_NOW_SCHOOL      = b.DIPLOMAS_NOW_SCHOOL
							  AND a.INDICATOR_DESC		     = b.INDICATOR_DESC

							  select * from EVAL_MATH_COMBO

--IA FIELDS-------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_MATH_COMBO] SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM [EVAL_MATH_COMBO] a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
						  AND a.SCHOOL_NAME               = b.SCHOOL_NAME

--TEAM_JUNE_DOSAGE_GOAL-------------------------------------------------------------------------------------------------

UPDATE  [EVAL_MATH_COMBO] SET

	TEAM_JUNE_DOSAGE_GOAL = b.[JUN_MTH_DosageGoal]

FROM [EVAL_MATH_COMBO] a INNER JOIN [dbo].[Goals_Dosage] b 
                           ON a.school_ID = b.ID

select * from [Goals_Dosage]
--TEAM_MONTH_DOSAGE_GOAL----------------------------------------------------------------------------------------------------

UPDATE [EVAL_MATH_COMBO] SET 

TEAM_MONTH_DOSAGE_GOAL =  CASE	WHEN month(getdate()) = 1 THEN  b.[DEC_MTH_DosageGoal]
								WHEN month(getdate()) = 2 THEN  b.[JAN_MTH_DosageGoal]
								WHEN month(getdate()) = 3 THEN	b.[FEB_MTH_DosageGoal]
								WHEN month(getdate()) = 4 THEN  b.[MAR_MTH_DosageGoal]
								WHEN month(getdate()) = 5 THEN  b.[APR_MTH_DosageGoal]
								WHEN month(getdate()) = 6 THEN  b.[MAY_MTH_DosageGoal]
								WHEN month(getdate()) = 7 THEN  b.[JUN_MTH_DosageGoal]
								WHEN month(getdate()) = 9 THEN  b.[AUG_MTH_DosageGoal]
								WHEN month(getdate()) = 10 THEN b.[SEP_MTH_DosageGoal] 
								WHEN month(getdate()) = 11 THEN b.[OCT_MTH_DosageGoal] 
								WHEN month(getdate()) = 12 THEN b.[NOV_MTH_DosageGoal]
								ELSE NULL
						END		 
							  
FROM [EVAL_MATH_COMBO] a INNER JOIN [dbo].[Goals_Dosage] b 
                           ON a.SCHOOL_ID = b.ID


--TTL_TIME --------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_MATH_COMBO] SET

TTL_TIME	= b.TTL_SUM

FROM [EVAL_MATH_COMBO] a INNER JOIN (SELECT CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC,SUM(TTL_TIME) AS TTL_SUM
										FROM [8_RPT_STUDENT_TIME_LINEAR] 
										GROUP BY  CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC) AS b
										ON b.CYSCHOOLHOUSE_STUDENT_ID = a.CYSCHOOLHOUSE_STUDENT_ID 
										

--STATUS_JUNE_DOSAGE_GOAL---------------------------------------------------------------------------------------------------------

UPDATE [EVAL_MATH_COMBO] SET

	STATUS_JUNE_DOSAGE_GOAL = CASE WHEN TTL_TIME >= TEAM_JUNE_DOSAGE_GOAL THEN '1'
								   WHEN TTL_TIME < TEAM_JUNE_DOSAGE_GOAL THEN '0'
									ELSE NULL
							   END
FROM [EVAL_MATH_COMBO]



--STATUS_MONTH_DOSAGE_GOAL--------------------------------------------------------------------------------------------------------

UPDATE [EVAL_MATH_COMBO] SET

	STATUS_MONTH_DOSAGE_GOAL = CASE WHEN TTL_TIME >= TEAM_MONTH_DOSAGE_GOAL THEN '1'
									WHEN TTL_TIME <  TEAM_MONTH_DOSAGE_GOAL THEN '0'
									ELSE NULL
							   END
FROM [EVAL_MATH_COMBO]


--CURRENTLY_ENROLLED AND ENROLLED_DAYS----------------------------------------------------------------------------------------------------


UPDATE [EVAL_MATH_COMBO] SET

 CURRENTLY_ENROLLED = b.CURRENTLY_ENROLLED,
 ENROLLED_DAYS      = b.ENROLLED_DAYS

FROM [EVAL_MATH_COMBO] a INNER JOIN [3_RPT_STUDENT_ENROLLMENT] b
                        ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
                        AND a.INDICATOR_DESC		  = b.INDICATOR_AREA_DESC


--GRANTSITENUM AND GRANTCATEGORY-----------------------------------------------------------------------------------------

UPDATE [EVAL_MATH_COMBO] SET
	
	GRANTSITENUM   = c.GRANTSITENUM,
	GRANTCATEGORY  = c.GRANTCATEGORY

FROM [EVAL_MATH_COMBO] a INNER JOIN SDW_Prod.dbo.DimSchool b  
                           ON a.school_ID = b.schoolID
						   INNER JOIN Goals_Ameri_Corps c ON b.CYSch_SF_ID = c.cyschSchoolRefID
	





--GRANTCATEGORY---------------------------------------------------------------------------------------------------------------------------


END





GO
