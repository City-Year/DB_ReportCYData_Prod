USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_MATH_CG]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

















-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Load_EVAL_MATH_CG]
AS
BEGIN

TRUNCATE TABLE [dbo].[EVAL_MATH_CG] 


--LOGIC FOR THIS TABLE IS TO PICK UP "CUMULATIVE COURSE GRADE" AS FIRST PRIORITY. IF A STUDENT DOESN"T HAVE "CUMULATIVE COURSE GRADE"
--THEN PICK UP "REPORTING PERIOD COURSE GRADE". THUS THE TWO DIFFERENT INSERT STATEMENTS. 

--INSERT SKILL_DESCRIPTION OF CUMULATIVE COURSE GRADE  
INSERT INTO [dbo].[EVAL_MATH_CG] 
	SELECT DISTINCT
	CYSCHOOLHOUSE_STUDENT_ID,
	SCHOOL_ID,
	SITE_NAME,
	STUDENT_NAME,
	GRADE,
	DIPLOMAS_NOW_SCHOOL,
	SCHOOL_NAME,
	INDICATOR_DESC,
	SKILL_DESCRIPTION,
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
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	FISCAL_YEAR,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	GETDATE()
 FROM [dbo].[9_RPT_PERFORMANCE_LEVEL_CG]
 WHERE INDICATOR_DESC = 'MATH'
 AND USED_FOR_SUMMATIVE_REPORTING = 1
 -- MW 5/2/2016: Added "AND TAG <> '' to Only include PRE and POST Tags
 AND TAG = 'PRE'
 --AND SKILL_DESCRIPTION = 'Cumulative Course Grade'
 
 /*
--INSERT SKILL_DESCRIPTION OF REPORTING PERIOD COURSE GRADE

INSERT INTO [dbo].[EVAL_MATH_CG] 
	SELECT  DISTINCT
	a.CYSCHOOLHOUSE_STUDENT_ID,
	a.SCHOOL_ID,
	a.SITE_NAME,
	a.STUDENT_NAME,
	a.GRADE,
	a.DIPLOMAS_NOW_SCHOOL,
	a.SCHOOL_NAME,
	a.INDICATOR_DESC,
	a.SKILL_DESCRIPTION,
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
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	a.FISCAL_YEAR,
	NULL,
	NULL
 FROM [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] a  LEFT OUTER JOIN [EVAL_MATH_CG] b 
											ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
									
 WHERE a.INDICATOR_DESC = 'MATH'
 AND a.SKILL_DESCRIPTION = 'Reporting Period Course Grade'
 AND b.CYSCHOOLHOUSE_STUDENT_ID IS NULL


 
 */

--PRE
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE PRE FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_MATH_CG SET

PRE_INTERVAL				= b.INTERVAL,
PRE_DATE					= b.ASSESSMENT_DATE,
PRE_VALUE					= b.PERFORMANCE_VALUE,
PRE_VALUE_NUM_LOCAL         = b.SCORE_RANK,
PRE_VALUE_NUM_NORM          = b.SCORE_RANK_NORM,
PRE_SCALE_LOCAL             = b.SCALE_LOCAL,
PRE_SCALE_NORM				= b.SCALE_NORM,
PRE_SCALE_RANK_LOCAL        = b.SCALE_NUM_LOCAL,
PRE_SCALE_NORM_RANK         = b.SCALE_NUM_NORM

FROM EVAL_MATH_CG a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						 
WHERE TAG = 'PRE'

--MY
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_MATH_ASSESSMENT: MY FIELDS MY_ASSESSMENT_DATE, MY_INTERVAL, MY_VALUE,MY_SCALE_LOCAL,MY_SCALE_NORM,
--										MY_SCALE_RANK_LOCAL, MY_SCALE_RANK_NORM,MY_TARGET_SCORE,MY_MET_TARGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

MY_INTERVAL				= b.INTERVAL,
MY_DATE					= b.ASSESSMENT_DATE,
MY_VALUE				= b.PERFORMANCE_VALUE,
MY_VALUE_NUM_LOCAL		= b.SCORE_RANK,
MY_VALUE_NUM_NORM		= b.SCORE_RANK_NORM,
MY_SCALE_LOCAL			= b.SCALE_LOCAL,
MY_SCALE_NORM			= b.SCALE_NORM,
MY_SCALE_RANK_LOCAL		= b.SCALE_NUM_LOCAL,
MY_SCALE_NORM_RANK		= b.SCALE_NUM_NORM

FROM EVAL_MATH_CG  a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   /* MW 5/2/2016: Added AND PRE_DATE <> Assesment_Date. If the mid year date 
						    is the same as the pre-date, the midyear fields should be null. 
						    We want to ensure we don't compare a data point to itself.*/ 
						   AND a.PRE_DATE					<> b.ASSESSMENT_DATE					  

WHERE USED_AS_MID_YEAR_DATA_POINT = '1'


--POST
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_MATH_ASSESSMENT: MY FIELDS MY_ASSESSMENT_DATE, MY_INTERVAL, MY_VALUE,MY_SCALE_LOCAL,MY_SCALE_NORM,
--										MY_SCALE_RANK_LOCAL, MY_SCALE_RANK_NORM,MY_TARGET_SCORE,MY_MET_TARGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

POST_INTERVAL				= b.INTERVAL,
POST_DATE					= b.ASSESSMENT_DATE,
POST_VALUE					= b.PERFORMANCE_VALUE,
POST_VALUE_NUM_LOCAL		= b.SCORE_RANK,
POST_VALUE_NUM_NORM			= b.SCORE_RANK_NORM,
POST_SCALE_LOCAL			= b.SCALE_LOCAL,
POST_SCALE_NORM				= b.SCALE_NORM,
POST_SCALE_RANK_LOCAL		= b.SCALE_NUM_LOCAL,
POST_SCALE_NORM_RANK		= b.SCALE_NUM_NORM

FROM EVAL_MATH_CG  a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						  

WHERE  TAG = 'POST'  

--MY_RAWCHANGE-------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	MY_RAWCHANGE			=  CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN CONVERT(VARCHAR,(CONVERT(DECIMAL(6,2),MY_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE)))
							  ELSE NULL 
							  END

FROM EVAL_MATH_CG
WHERE MY_VALUE <> ''


--RAWCHANGE---------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	RAWCHANGE				=  CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(PRE_VALUE) <> '1'
							  THEN CONCAT(PRE_VALUE,' to ',POST_VALUE) 
							  WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(POST_VALUE) = '1' AND ISNUMERIC(PRE_VALUE) = '1'
							  THEN  CONVERT(VARCHAR,(CONVERT(DECIMAL(6,2),POST_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE)))
							  ELSE NULL 
							  END

FROM EVAL_MATH_CG
WHERE RAWCHANGE = '' OR RAWCHANGE IS NULL




/*
UPDATE EVAL_MATH_CG SET

	RAWCHANGE				= CASE WHEN POST_VALUE IS NOT NULL 
							       THEN PRE_VALUE + ' to ' + POST_VALUE
							       ELSE NULL 
							  END 

FROM EVAL_MATH_CG
WHERE POST_VALUE <> ''
*/
--MY_RAWCHANGE_NUM_LOCAL------------------------------------------------------------------------------------------------------


UPDATE EVAL_MATH_CG SET 

	MY_RAWCHANGE_NUM_LOCAL	= CASE WHEN MY_VALUE_NUM_LOCAL IS NOT NULL 
							       THEN CAST(MY_VALUE_NUM_LOCAL AS INT) - CAST(PRE_VALUE_NUM_LOCAL AS INT) 
							       ELSE NULL 
							  END 

FROM EVAL_MATH_CG
WHERE  MY_VALUE_NUM_LOCAL <> ''

--RAWCHANGE_NUM_LOCAL------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET 

	RAWCHANGE_NUM_LOCAL	= CASE WHEN POST_VALUE_NUM_LOCAL IS NOT NULL 
							       THEN CAST(POST_VALUE_NUM_LOCAL AS INT) - CAST(PRE_VALUE_NUM_LOCAL AS INT) 
							       ELSE NULL 
							  END 

FROM EVAL_MATH_CG
WHERE POST_VALUE_NUM_LOCAL <> ''

--MY_RAWCHANGE_NUM_NORM----------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET  

MY_RAWCHANGE_NUM_NORM	= CASE WHEN MY_VALUE_NUM_NORM IS NOT NULL
							   THEN CAST(MY_VALUE_NUM_NORM AS INT) - CAST(PRE_VALUE_NUM_NORM AS INT) 
							   ELSE NULL 
						  END 

FROM EVAL_MATH_CG
WHERE MY_VALUE_NUM_NORM <> ''

--RAWCHANGE_NUM_NORM----------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET  

RAWCHANGE_NUM_NORM	= CASE	WHEN POST_VALUE_NUM_NORM IS NOT NULL
							--MW 5/3/2016: Removed THEN CONVERT(VARCHAR,CONVERT(INT,POST_VALUE_NUM_NORM) - CONVERT(INT,PRE_VALUE_NUM_NORM))
							THEN CAST(POST_VALUE_NUM_NORM AS INT)-CAST(PRE_VALUE_NUM_NORM AS INT)
							ELSE NULL 
					  END 

FROM EVAL_MATH_CG
--MW 5/3/2016: Removed WHERE RAWCHANGE_NUM_LOCAL = '' OR RAWCHANGE_NUM_LOCAL IS NULL
WHERE POST_VALUE_NUM_NORM <> ''

--MY_RAWCHANGE_NUM_LOCAL_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	MY_RAWCHANGE_NUM_LOCAL_DEGREE = CASE WHEN CAST(MY_RAWCHANGE_NUM_LOCAL AS decimal(6,2)) > 0 THEN 'INCREASED'
										 WHEN CAST(MY_RAWCHANGE_NUM_LOCAL AS decimal(6,2)) = 0 THEN 'NO CHANGE'
										 WHEN CAST(MY_RAWCHANGE_NUM_LOCAL AS decimal(6,2)) < 0 THEN 'DECREASED'
						                 ELSE NULL
									END


FROM EVAL_MATH_CG
WHERE MY_RAWCHANGE_NUM_LOCAL <> ''

--RAWCHANGE_NUM_LOCAL_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	RAWCHANGE_NUM_LOCAL_DEGREE = CASE WHEN CAST(RAWCHANGE_NUM_LOCAL AS decimal(6,2)) > 0 THEN 'INCREASED'
									  WHEN CAST(RAWCHANGE_NUM_LOCAL AS decimal(6,2)) = 0 THEN 'NO CHANGE'
									  WHEN CAST(RAWCHANGE_NUM_LOCAL AS decimal(6,2)) < 0 THEN 'DECREASED'
						              ELSE NULL
								 END
								 
FROM EVAL_MATH_CG
WHERE RAWCHANGE_NUM_LOCAL <> ''


--MY_RAWCHANGE_NUM_NORM_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	MY_RAWCHANGE_NUM_NORM_DEGREE = CASE  WHEN CAST(MY_RAWCHANGE_NUM_NORM AS decimal(3,2)) > 0 THEN 'INCREASED'
										 WHEN CAST(MY_RAWCHANGE_NUM_NORM AS decimal(3,2)) = 0 THEN 'NO CHANGE'
										 WHEN CAST(MY_RAWCHANGE_NUM_NORM AS decimal(3,2)) < 0 THEN 'DECREASED'
						                 ELSE NULL
									END
FROM EVAL_MATH_CG
WHERE MY_RAWCHANGE_NUM_NORM <> ''

--RAWCHANGE_NUM_NORM_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	RAWCHANGE_NUM_NORM_DEGREE = CASE WHEN CAST(RAWCHANGE_NUM_NORM AS DECIMAL(3,2)) > 0 THEN 'INCREASED'
										 WHEN CAST(RAWCHANGE_NUM_NORM AS DECIMAL(3,2)) = 0 THEN 'NO CHANGE'
										 WHEN CAST(RAWCHANGE_NUM_NORM AS DECIMAL(3,2)) < 0 THEN 'DECREASED'
						                 ELSE NULL
								END  
FROM EVAL_MATH_CG
WHERE RAWCHANGE_NUM_NORM <> ''


--MY_SCALE_CHANGE_LOCAL--------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	MY_SCALE_CHANGE_LOCAL = CASE WHEN MY_SCALE_RANK_LOCAL IS NOT NULL
							THEN CAST(MY_SCALE_RANK_LOCAL AS INT) - CAST(PRE_SCALE_RANK_LOCAL AS INT) 
							ELSE NULL 
					  END 
FROM EVAL_MATH_CG
WHERE MY_SCALE_RANK_LOCAL <> ''

--SCALE_CHANGE_LOCAL--------------------------------------------------------------------------------------------------------

 UPDATE EVAL_MATH_CG SET

	SCALE_CHANGE_LOCAL = CASE WHEN POST_SCALE_RANK_LOCAL IS NOT NULL
							  THEN CAST(POST_SCALE_RANK_LOCAL AS INT) - CAST(PRE_SCALE_RANK_LOCAL AS INT) 
							  ELSE NULL 
					  END 
FROM EVAL_MATH_CG
WHERE POST_SCALE_RANK_LOCAL <> ''

--MY_SCALE_CHANGE_NORM--------------------------------------------------------------------------------------------------------

 UPDATE EVAL_MATH_CG SET

	MY_SCALE_CHANGE_NORM = CASE WHEN MY_SCALE_NORM_RANK IS NOT NULL
							  THEN CAST(MY_SCALE_NORM_RANK AS INT) - CAST(PRE_SCALE_NORM_RANK AS INT) 
							  ELSE NULL 
					  END 
FROM EVAL_MATH_CG
WHERE MY_SCALE_NORM_RANK <> ''

--SCALE_CHANGE_NORM--------------------------------------------------------------------------------------------------------

 UPDATE EVAL_MATH_CG SET

	SCALE_CHANGE_NORM = CASE WHEN POST_SCALE_NORM_RANK IS NOT NULL
							  THEN CAST(POST_SCALE_NORM_RANK AS INT) - CAST(PRE_SCALE_NORM_RANK AS INT) 
							  ELSE NULL 
					  END 
FROM EVAL_MATH_CG
WHERE POST_SCALE_NORM_RANK <> ''

--MY_SCALE_CHANGE_LOCAL_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	MY_SCALE_CHANGE_LOCAL_TEXT = CASE	WHEN MY_SCALE_LOCAL IS NOT NULL 
										THEN PRE_SCALE_LOCAL + ' to ' + MY_SCALE_LOCAL
										ELSE NULL
								 END
FROM EVAL_MATH_CG

--SCALE_CHANGE_LOCAL_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	SCALE_CHANGE_LOCAL_TEXT = CASE	WHEN POST_SCALE_LOCAL IS NOT NULL 
									THEN PRE_SCALE_LOCAL + ' to ' + POST_SCALE_LOCAL
									ELSE NULL
								 END
FROM EVAL_MATH_CG

--MY_SCALE_CHANGE_NORM_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

 MY_SCALE_CHANGE_NORM_TEXT = CASE WHEN MY_SCALE_NORM IS NOT NULL 
							   THEN PRE_SCALE_NORM + ' to ' + MY_SCALE_NORM 
							   ELSE NULL END 

FROM EVAL_MATH_CG

--SCALE_CHANGE_NORM_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

 SCALE_CHANGE_NORM_TEXT = CASE WHEN POST_SCALE_NORM IS NOT NULL 
								THEN PRE_SCALE_NORM + ' to ' + POST_SCALE_NORM 
								ELSE NULL 
					 	  END 
 FROM EVAL_MATH_CG


 --START_OFF_SLIDING-------------------------------------------------------------------------------------------------------


    UPDATE EVAL_MATH_CG SET
	STARTOFFSLIDING =  CASE WHEN PRE_SCALE_NORM LIKE 'OF%' OR PRE_SCALE_NORM LIKE 'SL%' 
	                      THEN '1'
						  WHEN PRE_SCALE_NORM LIKE 'ON%' THEN '0'
						  ELSE NULL
					 END

	WHERE PRE_SCALE_NORM  IS NOT NULL AND PRE_SCALE_NORM  <> ''
	AND   POST_SCALE_NORM IS NOT NULL AND POST_SCALE_NORM <> ''

	


	/* 
	STARTOFFSLIDING =  CASE WHEN CAST(PRE_VALUE_NUM_NORM AS INT) < 3 THEN '1'
						  WHEN CAST(PRE_VALUE_NUM_NORM AS INT) >= 3 THEN '0'
						  ELSE NULL
					 END
	FROM EVAL_MATH_CG
	WHERE PRE_VALUE_NUM_NORM IS NOT NULL AND PRE_VALUE_NUM_NORM <>''  
	AND   POST_VALUE_NUM_NORM IS NOT NULL AND POST_VALUE_NUM_NORM <> ''
	*/

--MY_SOS_MoveOn-----------------------------------------------------------------------------------------------------------


UPDATE EVAL_MATH_CG SET
 MY_SOS_MoveOn =  CASE WHEN STARTOFFSLIDING = '1' AND MY_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (MY_SCALE_NORM LIKE 'OF%' OR MY_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END


/*

MY_SOS_MoveOn = CASE WHEN MY_VALUE_NUM_NORM < 3 THEN '1'
						  WHEN MY_VALUE_NUM_NORM >= 3 THEN '0'
						  ELSE NULL
					 END
FROM EVAL_MATH_CG

*/



--SOS_MoveOn---------------------------------------------------------------------------------------------------------------


UPDATE EVAL_MATH_CG SET
 SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND POST_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (POST_SCALE_NORM LIKE 'OF%' OR POST_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END



/*    
	UPDATE EVAL_MATH_CG SET
	SOS_MoveOn = CASE WHEN POST_VALUE_NUM_NORM < 3 THEN '1'
						  WHEN POST_VALUE_NUM_NORM >= 3 THEN '0'
						  ELSE NULL
				END


FROM EVAL_MATH_CG

*/

--STARTBELOWB---------------------------------------------------------------------------------------------------------------


UPDATE EVAL_MATH_CG SET 

STARTBELOWB =    CASE WHEN PRE_VALUE_NUM_NORM <= '4' and  PRE_VALUE_NUM_NORM <> ''  
                   THEN '1'
				   WHEN PRE_VALUE_NUM_NORM > '4'
				   THEN '0'
				   ELSE NULL
              END

FROM EVAL_MATH_CG
WHERE PRE_VALUE_NUM_NORM IS NOT NULL



--MY_INCGRADELEVEL----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	MY_INCGRADELEVEL = CASE WHEN STARTBELOWB = '1' AND MY_RAWCHANGE_NUM_NORM >= '1'
	                        THEN '1'
							WHEN STARTBELOWB = '1' AND MY_RAWCHANGE_NUM_NORM < '1'
							THEN '0'
							ELSE NULL
						END
FROM EVAL_MATH_CG

--INCGRADELEVEL----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	INCGRADELEVEL = CASE WHEN STARTBELOWB = '1' AND RAWCHANGE_NUM_NORM >= '1'
	                        THEN '1'
							WHEN STARTBELOWB = '1' AND RAWCHANGE_NUM_NORM < '1'
							THEN '0'
							ELSE NULL
						END
FROM EVAL_MATH_CG

--IA FIELDS------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM EVAL_MATH_CG a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN_WIP] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
						--  AND a.SCHOOL_NAME               = b.SCHOOL_NAME



--TEAM_JUNE_DOSAGE_GOAL-------------------------------------------------------------------------------------------------

UPDATE  EVAL_MATH_CG SET
TEAM_JUNE_DOSAGE_GOAL =  c.[JUN_MTH_DosageGoal]
FROM EVAL_MATH_CG a INNER JOIN SDW_PROD.dbo.Dimschool b  
                           --ON a.school_ID = b.schoolID          REMOVED BECAUSE OF MULTIPLE SPLIT SCHOOL ID's ON DIMSCHOOL 
						   ON a.school_name = b.SchoolName
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CYCH_SF_ID = c.CY_CHANNEL_SF_ID





/*
UPDATE  EVAL_MATH_CG SET

	TEAM_JUNE_DOSAGE_GOAL = b.[JUN_MTH_DosageGoal]

FROM EVAL_MATH_CG a INNER JOIN [dbo].[Goals_Dosage_2] b 
                   ON a.school_ID = b.ID
*/

--TEAM_MONTH_DOSAGE_GOAL----------------------------------------------------------------------------------------------------


UPDATE EVAL_MATH_CG SET 

TEAM_MONTH_DOSAGE_GOAL =  CASE	WHEN month(getdate()) = 1 THEN  c.[DEC_MTH_DosageGoal]
								WHEN month(getdate()) = 2 THEN  c.[JAN_MTH_DosageGoal]
								WHEN month(getdate()) = 3 THEN	c.[FEB_MTH_DosageGoal]
								WHEN month(getdate()) = 4 THEN  c.[MAR_MTH_DosageGoal]
								WHEN month(getdate()) = 5 THEN  c.[APR_MTH_DosageGoal]
								WHEN month(getdate()) = 6 THEN  c.[MAY_MTH_DosageGoal]
								WHEN month(getdate()) = 7 THEN  c.[JUN_MTH_DosageGoal]
								WHEN month(getdate()) = 9 THEN  c.[AUG_MTH_DosageGoal]
								WHEN month(getdate()) = 10 THEN c.[SEP_MTH_DosageGoal] 
								WHEN month(getdate()) = 11 THEN c.[OCT_MTH_DosageGoal] 
								WHEN month(getdate()) = 12 THEN c.[NOV_MTH_DosageGoal]
								ELSE NULL
						END		 
FROM EVAL_MATH_CG a INNER JOIN SDW_PROD.dbo.Dimschool b
							ON a.school_name = b.SchoolName  
                           --ON a.school_ID = b.schoolID    REMOVED BECAUSE OF MULTIPLE SPLIT SCHOOL ID's ON DIMSCHOOL
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CYCH_SF_ID = c.CY_CHANNEL_SF_ID


/*
UPDATE EVAL_MATH_CG SET 

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
							  
FROM EVAL_MATH_CG a INNER JOIN [dbo].[Goals_Dosage] b 
                           ON a.SCHOOL_ID = b.ID
*/

--TTL_TIME --------------------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET TTL_TIME = NULL

UPDATE EVAL_MATH_CG SET
TTL_TIME	= b.TTL_TIME
FROM EVAL_MATH_CG a INNER JOIN [dbo].[8_RPT_STUDENT_TIME_LINEAR] b
                          ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
                         AND a.INDICATOR_DESC            = b.INDICATOR_AREA_DESC

/*
FROM EVAL_MATH_CG a INNER JOIN (SELECT CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC,SUM(TTL_TIME) AS TTL_SUM
										FROM [8_RPT_STUDENT_TIME_LINEAR] 
										GROUP BY  CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC) AS b
										ON b.CYSCHOOLHOUSE_STUDENT_ID = a.CYSCHOOLHOUSE_STUDENT_ID
										AND b.INDICATOR_AREA_DESC = a.INDICATOR_DESC
										*/

--DOSAGE_CATEGORY-----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET
DOSAGE_CATEGORY         = b.DOSAGE_CATEGORY
FROM EVAL_MATH_CG a INNER JOIN [dbo].[8_RPT_STUDENT_TIME_LINEAR] b
                          ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
                         AND a.INDICATOR_DESC            = b.INDICATOR_AREA_DESC


--STATUS_JUNE_DOSAGE_GOAL-----------------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

	STATUS_JUNE_DOSAGE_GOAL = CASE	WHEN convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) >= convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '1' 
									WHEN convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) < convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							  END
FROM EVAL_MATH_CG


--STATUS_MONTH_DOSAGE_GOAL-----------------------------------------------------------------------------------------


UPDATE EVAL_MATH_CG SET

	STATUS_MONTH_DOSAGE_GOAL =  CASE WHEN round(convert(float,TTL_TIME)/Convert(float,60),2) >= convert(float,TEAM_MONTH_DOSAGE_GOAL) THEN '1'
									WHEN round(convert(float,TTL_TIME)/Convert(float,60),2) <  convert(float,TEAM_MONTH_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							   END
FROM EVAL_MATH_CG


--CURRENTLY_ENROLLED AND ENROLLED_DAYS----------------------------------------------------------------------------------------------------

/*
UPDATE EVAL_MATH_CG SET

 CURRENTLY_ENROLLED = b.CURRENTLY_ENROLLED,
 ENROLLED_DAYS      = b.ENROLLED_DAYS

FROM EVAL_MATH_CG a INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] b
                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
                          AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC

*/




--SELECT DATEDIFF BETWEEN MIN AND MAX INTERVENTION DATE INTO #BEHAVIOR 
		 SELECT
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC,
		 datediff(dd,MIN(first_intervention), Max(last_intervention)) DAYS_ENROLLED
		 INTO  #MATHCG
		 FROM [3_RPT_STUDENT_ENROLLMENT_WIP]
		 WHERE INDICATOR_AREA_DESC = 'Math'   
		 group by 
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC

		--UPDATE EVAL_DESSA_MINI ENROLLED_DAYS FROM #BEHAVIOR TABLE WHERE INDICATOR DESC IS BEHAVIOR-----------------
 
		UPDATE EVAL_MATH_CG SET
		ENROLLED_DAYS      = b.DAYS_ENROLLED
		FROM EVAL_MATH_CG a INNER JOIN #MATHCG b
								   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
		WHERE a.INDICATOR_DESC = 'Math'
 
		--UPDATE CURRENTLY_ENROLLED WHERE LAST INTERVENTION EQUAlS TODAYS DATE-----------------------------------------

		

--CURRENTLY ENROLLED---------------------------------------------------------------------------------------------------------------


		--SET CURRENTLY_ENROLLED TO BLANK----------------------------------------------------------------------------

			UPDATE EVAL_MATH_CG SET CURRENTLY_ENROLLED = ''



		--UPDATE TO YES WHERE LAST INTERVENTION EQUALS TODAY----------------------------------------------	
			
		UPDATE EVAL_MATH_CG SET
		CURRENTLY_ENROLLED =  'YES'
		FROM EVAL_MATH_CG a 
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'Math'
		AND c.last_intervention = convert(date,GETDATE()) 

		UPDATE EVAL_MATH_CG SET
		CURRENTLY_ENROLLED =  'NO'
		FROM EVAL_MATH_CG a
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'Math'
		AND c.last_intervention <> convert(date,GETDATE()) 
		AND a.CURRENTLY_ENROLLED <> 'YES'
		

		UPDATE EVAL_MATH_CG SET
		CURRENTLY_ENROLLED = NULL 
		FROM EVAL_MATH_CG a left outer join  [3_RPT_STUDENT_ENROLLMENT_WIP]  b
		ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
		AND a.INDICATOR_DESC  = b.INDICATOR_AREA_DESC
		WHERE b.CYSCHOOLHOUSE_STUDENT_ID IS NULL 
		AND  b.INDICATOR_AREA_DESC IS NULL 
		AND  a.CURRENTLY_ENROLLED NOT IN ('YES','NO')









	

--GRANTSITENUM AND GRANTCATEGORY-----------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET
	
	GRANTSITENUM   = c.GRANTSITENUM,
	GRANTCATEGORY  = c.GRANTCATEGORY

FROM EVAL_MATH_CG a inner join SDW_PROD.dbo.DimSchool    b ON SCHOOL_NAME = b.SCHOOLNAME   -- on a.School_ID = b.schoolID  
                       inner join [dbo].[FY16_Schools_And_ACGrants] c on b.CYch_SF_ID = c.CY_CHANNEL_SF_ID



--SOYReport , MYReport , EOYReport ------------------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET
SOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Cumulative Course Grade'      AND Pre_Value IS NOT NULL THEN '1' 
                 WHEN SKILL_DESCRIPTION = 'Reporting Period Course Grade' AND Pre_Value IS NOT NULL THEN '2'
				 ELSE NULL
			END,
MY_Report  = CASE WHEN SKILL_DESCRIPTION = 'Cumulative Course Grade'      AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '1' 
                 WHEN SKILL_DESCRIPTION = 'Reporting Period Course Grade' AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '2'
				 ELSE NULL
			END,
EOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Cumulative Course Grade'      AND Pre_Value IS NOT NULL  AND Post_Value IS NOT NULL THEN '1' 
                 WHEN SKILL_DESCRIPTION = 'Reporting Period Course Grade' AND Pre_Value IS NOT NULL  AND Post_Value IS NOT NULL THEN '2'
				 ELSE NULL
END


------New Field: StartOnStayOn. Added 5/18/2016-----------------------------------------------------------------------------------

UPDATE EVAL_MATH_CG SET

STARTONSTAYON = CASE WHEN STARTOFFSLIDING = '0' AND POST_SCALE_NORM = 'On Track' THEN '1'
                     WHEN STARTOFFSLIDING = '0' AND POST_SCALE_NORM in ('Off Track', 'Sliding') THEN '0'
				     WHEN STARTOFFSLIDING <>'0' THEN NULL
				END

--SCALE_CHANGE_NORM_DEGREE

	UPDATE EVAL_MATH_CG SET
	SCALE_CHANGE_NORM_DEGREE = CASE WHEN SCALE_CHANGE_NORM<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_NORM=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_NORM>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_MATH_CG

--SCALE_CHANGE_LOCAL_DEGREE

	UPDATE EVAL_MATH_CG SET
	SCALE_CHANGE_LOCAL_DEGREE = CASE WHEN SCALE_CHANGE_LOCAL<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_LOCAL=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_LOCAL>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_MATH_CG

END















GO
