USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_ELA_CG]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[sp_Load_EVAL_ELA_CG]
AS
BEGIN

TRUNCATE TABLE [dbo].[EVAL_ELA_CG] 

--LOGIC FOR THIS TABLE IS TO PICK UP "CUMULATIVE COURSE GRADE" AS FIRST PRIORITY. IF A STUDENT DOESN"T HAVE "CUMULATIVE COURSE GRADE"
--THEN PICK UP "REPORTING PERIOD COURSE GRADE". THUS THE TWO DIFFERENT INSERT STATEMENTS. 
--INSERT SKILL_DESCRIPTION OF CUMULATIVE COURSE GRADE 

INSERT INTO [dbo].[EVAL_ELA_CG] 
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
 WHERE INDICATOR_DESC = 'ELA/Literacy'
 AND TAG = 'pre'									-- MW 5/2/2016: Added "AND TAG <> '' to Only include PRE and POST Tags
 AND SKILL_DESCRIPTION IN ('Cumulative Course Grade','Reporting Period Course Grade')
 AND USED_FOR_SUMMATIVE_REPORTING = '1'
 order by CYSCHOOLHOUSE_STUDENT_ID

 


 /*
 
--INSERT SKILL_DESCRIPTION OF REPORTING PERIOD COURSE GRADE

INSERT INTO [dbo].[EVAL_ELA_CG] 
	SELECT DISTINCT
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
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
 FROM [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] a  LEFT OUTER JOIN [EVAL_ELA_CG] b 
											ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
									
 WHERE a.INDICATOR_DESC = 'ELA/Literacy'
 AND a.SKILL_DESCRIPTION = 'Reporting Period Course Grade'
 AND a.USED_FOR_SUMMATIVE_REPORTING = '1'
 AND TAG <> ''
 AND b.CYSCHOOLHOUSE_STUDENT_ID IS NULL
 order by a.CYSCHOOLHOUSE_STUDENT_ID
 */
 

--PRE
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE PRE FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_ELA_CG SET

PRE_INTERVAL				= b.INTERVAL,
PRE_DATE					= b.ASSESSMENT_DATE,
PRE_VALUE					= b.PERFORMANCE_VALUE,
PRE_VALUE_NUM_LOCAL         = b.SCORE_RANK,
PRE_VALUE_NUM_NORM          = b.SCORE_RANK_NORM,
PRE_SCALE_LOCAL             = b.SCALE_LOCAL,
PRE_SCALE_NORM				= b.SCALE_NORM,
PRE_SCALE_RANK_LOCAL        = b.SCALE_NUM_LOCAL,
PRE_SCALE_NORM_RANK         = b.SCALE_NUM_NORM

FROM EVAL_ELA_CG a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
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
--UPDATE EVAL_ELA_ASSESSMENT: MY FIELDS MY_ASSESSMENT_DATE, MY_INTERVAL, MY_VALUE,MY_SCALE_LOCAL,MY_SCALE_NORM,
--										MY_SCALE_RANK_LOCAL, MY_SCALE_RANK_NORM,MY_TARGET_SCORE,MY_MET_TARGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

MY_INTERVAL				= b.INTERVAL,
MY_DATE					= b.ASSESSMENT_DATE,
MY_VALUE				= b.PERFORMANCE_VALUE,
MY_VALUE_NUM_LOCAL		= b.SCORE_RANK,
MY_VALUE_NUM_NORM		= b.SCORE_RANK_NORM,
MY_SCALE_LOCAL			= b.SCALE_LOCAL,
MY_SCALE_NORM			= b.SCALE_NORM,
MY_SCALE_RANK_LOCAL		= b.SCALE_NUM_LOCAL,
MY_SCALE_NORM_RANK		= b.SCALE_NUM_NORM

FROM EVAL_ELA_CG  a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
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
--UPDATE EVAL_ELA_ASSESSMENT: MY FIELDS MY_ASSESSMENT_DATE, MY_INTERVAL, MY_VALUE,MY_SCALE_LOCAL,MY_SCALE_NORM,
--										MY_SCALE_RANK_LOCAL, MY_SCALE_RANK_NORM,MY_TARGET_SCORE,MY_MET_TARGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

POST_INTERVAL				= b.INTERVAL,
POST_DATE					= b.ASSESSMENT_DATE,
POST_VALUE					= b.PERFORMANCE_VALUE,
POST_VALUE_NUM_LOCAL		= b.SCORE_RANK,
POST_VALUE_NUM_NORM			= b.SCORE_RANK_NORM,
POST_SCALE_LOCAL			= b.SCALE_LOCAL,
POST_SCALE_NORM				= b.SCALE_NORM,
POST_SCALE_RANK_LOCAL		= b.SCALE_NUM_LOCAL,
POST_SCALE_NORM_RANK		= b.SCALE_NUM_NORM

FROM EVAL_ELA_CG  a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
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

UPDATE EVAL_ELA_CG SET

	MY_RAWCHANGE			= CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '0'
							  THEN CONCAT(PRE_VALUE,' to ',MY_VALUE) 
							  WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN CONVERT(VARCHAR,(CONVERT(DECIMAL(6,2),MY_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE)))
							  ELSE NULL 
							  END

FROM EVAL_ELA_CG
WHERE MY_RAWCHANGE = '' OR MY_RAWCHANGE IS NULL



--RAWCHANGE---------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	RAWCHANGE				=  CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(PRE_VALUE) = '0'
							  THEN CONCAT(PRE_VALUE,' to ',POST_VALUE) 
							  WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(PRE_VALUE) = '1'
							  THEN CONVERT(VARCHAR,(CONVERT(DECIMAL(6,2),POST_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE)))
							  ELSE NULL 
							  END

FROM EVAL_ELA_CG
WHERE RAWCHANGE = '' OR RAWCHANGE IS NULL


--MY_RAWCHANGE_NUM_LOCAL------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_CG SET 

	MY_RAWCHANGE_NUM_LOCAL = CASE WHEN MY_VALUE_NUM_LOCAL IS NOT NULL
							       THEN CONVERT(INT,MY_VALUE_NUM_LOCAL) - CONVERT(INT,PRE_VALUE_NUM_LOCAL) 
							       ELSE NULL 
							  END 

FROM EVAL_ELA_CG
WHERE MY_RAWCHANGE_NUM_LOCAL = ''


--RAWCHANGE_NUM_LOCAL------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET 

	RAWCHANGE_NUM_LOCAL	= CASE WHEN POST_VALUE_NUM_LOCAL IS NOT NULL
							       THEN CONVERT(INT,POST_VALUE_NUM_LOCAL) - CONVERT(INT,PRE_VALUE_NUM_LOCAL) 
							       ELSE NULL 
							  END 

FROM EVAL_ELA_CG
WHERE RAWCHANGE_NUM_LOCAL = ''

--MY_RAWCHANGE_NUM_NORM----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET  

MY_RAWCHANGE_NUM_NORM	= CASE WHEN MY_VALUE_NUM_NORM IS NOT NULL
							   THEN CONVERT(VARCHAR,CONVERT(INT,MY_VALUE_NUM_NORM) - CONVERT(INT,PRE_VALUE_NUM_NORM))
							   ELSE NULL 
							  END 

FROM EVAL_ELA_CG
WHERE MY_RAWCHANGE_NUM_NORM = ''

--RAWCHANGE_NUM_NORM----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET  

RAWCHANGE_NUM_NORM	= CASE	WHEN POST_VALUE_NUM_NORM IS NOT NULL
							THEN CONVERT(VARCHAR,CONVERT(INT,POST_VALUE_NUM_NORM) - CONVERT(INT,PRE_VALUE_NUM_NORM))
							ELSE NULL 
					  END 

FROM EVAL_ELA_CG
WHERE RAWCHANGE_NUM_LOCAL = ''


--MY_RAWCHANGE_NUM_LOCAL_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	MY_RAWCHANGE_NUM_LOCAL_DEGREE = CASE WHEN CONVERT(decimal(3,2),MY_RAWCHANGE_NUM_LOCAL) > 0 THEN 'INCREASED'
										 WHEN CONVERT(decimal(3,2),MY_RAWCHANGE_NUM_LOCAL) = 0 THEN 'NO CHANGE'
										 WHEN CONVERT(decimal(3,2),MY_RAWCHANGE_NUM_LOCAL) < 0 THEN 'DECREASED'
						                 ELSE NULL
									END


FROM EVAL_ELA_CG


--RAWCHANGE_NUM_LOCAL_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	RAWCHANGE_NUM_LOCAL_DEGREE = CASE WHEN CONVERT(decimal(3,2),RAWCHANGE_NUM_LOCAL) > 0 THEN 'INCREASED'
									  WHEN CONVERT(decimal(3,2),RAWCHANGE_NUM_LOCAL) = 0 THEN 'NO CHANGE'
									  WHEN CONVERT(decimal(3,2),RAWCHANGE_NUM_LOCAL) < 0 THEN 'DECREASED'
						              ELSE NULL
								 END


FROM EVAL_ELA_CG


--MY_RAWCHANGE_NUM_NORM_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	MY_RAWCHANGE_NUM_NORM_DEGREE = CASE  WHEN CONVERT(decimal(3,2),MY_RAWCHANGE_NUM_NORM) > 0 THEN 'INCREASED'
										 WHEN CONVERT(decimal(3,2),MY_RAWCHANGE_NUM_NORM) = 0 THEN 'NO CHANGE'
										 WHEN CONVERT(decimal(3,2),MY_RAWCHANGE_NUM_NORM) < 0 THEN 'DECREASED'
						                 ELSE NULL
									END
FROM EVAL_ELA_CG

--RAWCHANGE_NUM_NORM_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	RAWCHANGE_NUM_NORM_DEGREE = CASE     WHEN CONVERT(decimal(3,2),RAWCHANGE_NUM_NORM) > 0 THEN 'INCREASED'
										 WHEN CONVERT(decimal(3,2),RAWCHANGE_NUM_NORM) = 0 THEN 'NO CHANGE'
										 WHEN CONVERT(decimal(3,2),RAWCHANGE_NUM_NORM) < 0 THEN 'DECREASED'
						                 ELSE NULL
									END
FROM EVAL_ELA_CG


--MY_SCALE_CHANGE_LOCAL--------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	MY_SCALE_CHANGE_LOCAL = CASE WHEN MY_SCALE_RANK_LOCAL IS NOT NULL
							THEN CONVERT(INT,MY_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL) 
							ELSE NULL 
					  END 
FROM EVAL_ELA_CG

--SCALE_CHANGE_LOCAL--------------------------------------------------------------------------------------------------------

 UPDATE EVAL_ELA_CG SET

	SCALE_CHANGE_LOCAL = CASE WHEN POST_SCALE_RANK_LOCAL IS NOT NULL
							  THEN CONVERT(INT,POST_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL) 
							  ELSE NULL 
					  END 
FROM EVAL_ELA_CG

--MY_SCALE_CHANGE_NORM--------------------------------------------------------------------------------------------------------

 UPDATE EVAL_ELA_CG SET

	MY_SCALE_CHANGE_NORM = CASE WHEN MY_SCALE_NORM_RANK IS NOT NULL
							  THEN CONVERT(INT,MY_SCALE_NORM_RANK) - CONVERT(INT,PRE_SCALE_NORM_RANK) 
							  ELSE NULL 
					  END 
FROM EVAL_ELA_CG

--SCALE_CHANGE_NORM--------------------------------------------------------------------------------------------------------

 UPDATE EVAL_ELA_CG SET

	SCALE_CHANGE_NORM = CASE WHEN POST_SCALE_NORM_RANK IS NOT NULL
							  THEN CONVERT(INT,POST_SCALE_NORM_RANK) - CONVERT(INT,PRE_SCALE_NORM_RANK) 
							  ELSE NULL 
					  END 
FROM EVAL_ELA_CG

--MY_SCALE_CHANGE_LOCAL_TEXT----------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_CG SET

	MY_SCALE_CHANGE_LOCAL_TEXT =  CASE	WHEN MY_SCALE_LOCAL IS NOT NULL and MY_SCALE_LOCAL <> '' 
										THEN PRE_SCALE_LOCAL + ' to ' + MY_SCALE_LOCAL
										ELSE NULL
								 END
FROM EVAL_ELA_CG

--SCALE_CHANGE_LOCAL_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	SCALE_CHANGE_LOCAL_TEXT = CASE	WHEN POST_SCALE_LOCAL IS NOT NULL 
									THEN PRE_SCALE_LOCAL + ' to ' + POST_SCALE_LOCAL
									ELSE NULL
								 END
FROM EVAL_ELA_CG

--MY_SCALE_CHANGE_NORM_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

 SCALE_CHANGE_NORM_TEXT = CASE WHEN MY_SCALE_NORM IS NOT NULL 
							   THEN PRE_SCALE_NORM + ' to ' + MY_SCALE_NORM 
							   ELSE NULL END 

FROM EVAL_ELA_CG

--SCALE_CHANGE_NORM_TEXT----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

 SCALE_CHANGE_NORM_TEXT = CASE WHEN POST_SCALE_NORM IS NOT NULL 
								THEN PRE_SCALE_NORM + '  to  ' + POST_SCALE_NORM 
								ELSE NULL 
						  END 
 FROM EVAL_ELA_CG


 --START_OFF_SLIDING-------------------------------------------------------------------------------------------------------
    

	UPDATE EVAL_ELA_CG SET

	STARTOFFSLIDING =   CASE WHEN PRE_SCALE_NORM LIKE 'OF%' OR PRE_SCALE_NORM LIKE 'SL%' 
	                      THEN '1'
						  WHEN PRE_SCALE_NORM LIKE 'ON%' THEN '0'
						  ELSE NULL
					 END
	FROM EVAL_ELA_CG
	WHERE PRE_SCALE_NORM  IS NOT NULL AND PRE_SCALE_NORM  <> ''
	AND   POST_SCALE_NORM IS NOT NULL AND POST_SCALE_NORM <> ''

--MY_SOS_MoveOn-----------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_CG SET

 MY_SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND MY_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (MY_SCALE_NORM LIKE 'OF%' OR MY_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ELA_CG


/*

UPDATE EVAL_ELA_CG SET

 MY_SOS_MoveOn =  CASE WHEN STARTOFFSLIDING = '1' AND MY_VALUE_NUM_NORM >= '3'
 					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND MY_VALUE_NUM_NORM <= '2'
					  THEN '0'
					  WHEN STARTOFFSLIDING IS NULL OR STARTOFFSLIDING = '0'
					  THEN NULL
                 END
FROM EVAL_ELA_CG


*/




--SOS_MoveOn---------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

 SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND POST_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (POST_SCALE_NORM LIKE 'OF%' OR POST_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ELA_CG


/*
UPDATE EVAL_ELA_CG SET

 SOS_MoveOn =  CASE WHEN STARTOFFSLIDING = '1' AND POST_VALUE_NUM_NORM >= '3'
 					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND POST_VALUE_NUM_NORM <= '2'
					  THEN '0'
					  WHEN STARTOFFSLIDING IS NULL OR STARTOFFSLIDING = '0'
					  THEN NULL
                 END
FROM EVAL_ELA_CG
*/

--STARTBELOWB---------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_CG SET

STARTBELOWB =    CASE WHEN PRE_VALUE_NUM_NORM <= '4' and  PRE_VALUE_NUM_NORM <> ''  
                   THEN '1'
				   WHEN PRE_VALUE_NUM_NORM > '4'
				   THEN '0'
				   ELSE NULL
              END

FROM EVAL_ELA_CG
WHERE PRE_VALUE_NUM_NORM IS NOT NULL



--MY_INCGRADELEVEL----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	MY_INCGRADELEVEL = CASE WHEN STARTBELOWB = '1' AND MY_RAWCHANGE_NUM_NORM >= '1'
	                        THEN '1'
							WHEN STARTBELOWB = '1' AND MY_RAWCHANGE_NUM_NORM < '1'
							THEN '0'
							ELSE NULL
						END
FROM EVAL_ELA_CG

--INCGRADELEVEL----------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

	INCGRADELEVEL = CASE WHEN STARTBELOWB = '1' AND RAWCHANGE_NUM_NORM >= '1'
	                        THEN '1'
							WHEN STARTBELOWB = '1' AND RAWCHANGE_NUM_NORM < '1'
							THEN '0'
							ELSE NULL
						END
FROM EVAL_ELA_CG

--IA FIELDS------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM EVAL_ELA_CG a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN_WIP] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
						--  AND a.SCHOOL_NAME               = b.SCHOOL_NAME

						  
--TEAM_JUNE_DOSAGE_GOAL-------------------------------------------------------------------------------------------------


/* ORGINAL CODE??
UPDATE  EVAL_ELA_CG SET

	TEAM_JUNE_DOSAGE_GOAL =  b.[JUN_ELA_DosageGoal]

FROM EVAL_ELA_CG a INNER JOIN [dbo].[Goals_Dosage_2] b 
                   ON a.school_ID = b.ID

*/

UPDATE  EVAL_ELA_CG SET

	TEAM_JUNE_DOSAGE_GOAL =  c.[JUN_ELA_DosageGoal]
FROM EVAL_ELA_CG a INNER JOIN SDW_PROD.dbo.Dimschool b  
                           --ON a.school_ID = b.schoolID          REMOVED BECAUSE OF MULTIPLE SPLIT SCHOOL ID's ON DIMSCHOOL 
						   ON a.school_name = b.SchoolName
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CYCH_SF_ID = c.CY_CHANNEL_SF_ID




--TEAM_MONTH_DOSAGE_GOAL----------------------------------------------------------------------------------------------------
/*
UPDATE EVAL_ELA_CG SET 

TEAM_MONTH_DOSAGE_GOAL =  CASE	WHEN month(getdate()) = 1 THEN  b.[DEC_ELA_DosageGoal]
								WHEN month(getdate()) = 2 THEN  b.[JAN_ELA_DosageGoal]
								WHEN month(getdate()) = 3 THEN	b.[FEB_ELA_DosageGoal]
								WHEN month(getdate()) = 4 THEN  b.[MAR_ELA_DosageGoal]
								WHEN month(getdate()) = 5 THEN  b.[APR_ELA_DosageGoal]
								WHEN month(getdate()) = 6 THEN  b.[MAY_ELA_DosageGoal]
								WHEN month(getdate()) = 7 THEN  b.[JUN_ELA_DosageGoal]
								WHEN month(getdate()) = 9 THEN  b.[AUG_ELA_DosageGoal]
								WHEN month(getdate()) = 10 THEN b.[SEP_ELA_DosageGoal] 
								WHEN month(getdate()) = 11 THEN b.[OCT_ELA_DosageGoal] 
								WHEN month(getdate()) = 12 THEN b.[NOV_ELA_DosageGoal]
								ELSE NULL
						END		 
							  
FROM EVAL_ELA_CG a INNER JOIN [dbo].[Goals_Dosage] b 
                           ON a.SCHOOL_ID = b.ID

*/


UPDATE EVAL_ELA_CG SET 

TEAM_MONTH_DOSAGE_GOAL =  CASE	WHEN month(getdate()) = 1 THEN  c.[DEC_ELA_DosageGoal]
								WHEN month(getdate()) = 2 THEN  c.[JAN_ELA_DosageGoal]
								WHEN month(getdate()) = 3 THEN	c.[FEB_ELA_DosageGoal]
								WHEN month(getdate()) = 4 THEN  c.[MAR_ELA_DosageGoal]
								WHEN month(getdate()) = 5 THEN  c.[APR_ELA_DosageGoal]
								WHEN month(getdate()) = 6 THEN  c.[MAY_ELA_DosageGoal]
								WHEN month(getdate()) = 7 THEN  c.[JUN_ELA_DosageGoal]
								WHEN month(getdate()) = 9 THEN  c.[AUG_ELA_DosageGoal]
								WHEN month(getdate()) = 10 THEN c.[SEP_ELA_DosageGoal] 
								WHEN month(getdate()) = 11 THEN c.[OCT_ELA_DosageGoal] 
								WHEN month(getdate()) = 12 THEN c.[NOV_ELA_DosageGoal]
								ELSE NULL
						END		 
FROM EVAL_ELA_CG a INNER JOIN SDW_PROD.dbo.Dimschool b
							ON a.school_name = b.SchoolName  
                           --ON a.school_ID = b.schoolID    REMOVED BECAUSE OF MULTIPLE SPLIT SCHOOL ID's ON DIMSCHOOL
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CYCH_SF_ID = c.CY_CHANNEL_SF_ID




--TTL_TIME --------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_CG SET TTL_TIME = NULL

UPDATE EVAL_ELA_CG SET
TTL_TIME	= b.TTL_TIME
FROM EVAL_ELA_CG a INNER JOIN [dbo].[8_RPT_STUDENT_TIME_LINEAR] b
                          ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
                         AND a.INDICATOR_DESC            = b.INDICATOR_AREA_DESC


/*

UPDATE EVAL_ELA_CG SET

TTL_TIME	=   b.TTL_SUM


FROM EVAL_ELA_CG a INNER JOIN (SELECT CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC,SUM(TTL_TIME) AS TTL_SUM
										FROM [8_RPT_STUDENT_TIME_LINEAR] 
										GROUP BY  CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC) AS b
										ON b.CYSCHOOLHOUSE_STUDENT_ID = a.CYSCHOOLHOUSE_STUDENT_ID
										AND b.INDICATOR_AREA_DESC = a.INDICATOR_DESC
*/

--DOSAGE_CATEGORY-----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET
DOSAGE_CATEGORY         = b.DOSAGE_CATEGORY
FROM EVAL_ELA_CG a INNER JOIN [dbo].[8_RPT_STUDENT_TIME_LINEAR] b
                          ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
                         AND a.INDICATOR_DESC            = b.INDICATOR_AREA_DESC

						

--STATUS_JUNE_DOSAGE_GOAL-----------------------------------------------------------------------------------------------------



UPDATE EVAL_ELA_CG SET

	STATUS_JUNE_DOSAGE_GOAL = CASE	WHEN convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) >= convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '1' 
									WHEN convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) < convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							  END
FROM EVAL_ELA_CG



--STATUS_MONTH_DOSAGE_GOAL-----------------------------------------------------------------------------------------



UPDATE EVAL_ELA_CG SET

	STATUS_MONTH_DOSAGE_GOAL =  CASE WHEN round(convert(float,TTL_TIME)/Convert(float,60),2) >= convert(float,TEAM_MONTH_DOSAGE_GOAL) THEN '1'
									WHEN round(convert(float,TTL_TIME)/Convert(float,60),2) <  convert(float,TEAM_MONTH_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							   END
FROM EVAL_ELA_CG



--CURRENTLY_ENROLLED AND ENROLLED_DAYS----------------------------------------------------------------------------------------------------
/*
UPDATE EVAL_ELA_CG SET

 CURRENTLY_ENROLLED = b.CURRENTLY_ENROLLED,
 ENROLLED_DAYS      = b.ENROLLED_DAYS

FROM EVAL_ELA_CG a INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] b
                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
                          AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
*/






--SELECT DATEDIFF BETWEEN MIN AND MAX INTERVENTION DATE INTO #BEHAVIOR 
		 SELECT
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC,
		 datediff(dd,MIN(first_intervention), Max(last_intervention)) DAYS_ENROLLED
		 INTO  #ELACG
		 FROM [3_RPT_STUDENT_ENROLLMENT_WIP]
		 WHERE INDICATOR_AREA_DESC = 'ELA/Literacy'   
		 group by 
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC

		--UPDATE EVAL_DESSA_MINI ENROLLED_DAYS FROM #BEHAVIOR TABLE WHERE INDICATOR DESC IS BEHAVIOR-----------------
 
		UPDATE EVAL_ELA_CG SET
		ENROLLED_DAYS      = b.DAYS_ENROLLED
		FROM EVAL_ELA_CG a INNER JOIN #ELACG b
								   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
		WHERE a.INDICATOR_DESC = 'ELA/Literacy'
 
		--UPDATE CURRENTLY_ENROLLED WHERE LAST INTERVENTION EQUAlS TODAYS DATE-----------------------------------------

		

--CURRENTLY ENROLLED---------------------------------------------------------------------------------------------------------------


		--SET CURRENTLY_ENROLLED TO BLANK----------------------------------------------------------------------------

			UPDATE EVAL_ELA_CG SET CURRENTLY_ENROLLED = ''



		--UPDATE TO YES WHERE LAST INTERVENTION EQUALS TODAY----------------------------------------------	
			
		UPDATE EVAL_ELA_CG SET
		CURRENTLY_ENROLLED =  'YES'
		FROM EVAL_ELA_CG a 
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'ELA/Literacy'
		AND c.last_intervention = convert(date,GETDATE()) 

		UPDATE EVAL_ELA_CG SET
		CURRENTLY_ENROLLED =  'NO'
		FROM EVAL_ELA_CG a
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'ELA/Literacy'
		AND c.last_intervention <> convert(date,GETDATE()) 
		AND a.CURRENTLY_ENROLLED <> 'YES'
		

		UPDATE EVAL_ELA_CG SET
		CURRENTLY_ENROLLED = NULL 
		FROM EVAL_ELA_CG a left outer join  [3_RPT_STUDENT_ENROLLMENT_WIP]  b
		ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
		AND a.INDICATOR_DESC  = b.INDICATOR_AREA_DESC
		WHERE b.CYSCHOOLHOUSE_STUDENT_ID IS NULL 
		AND  b.INDICATOR_AREA_DESC IS NULL 
		AND  a.CURRENTLY_ENROLLED NOT IN ('YES','NO')


		

--GRANTSITENUM AND GRANTCATEGORY-----------------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET
	
	GRANTSITENUM   = c.GRANTSITENUM,
	GRANTCATEGORY  = c.GRANTCATEGORY

FROM EVAL_ELA_CG a INNER JOIN SDW_PROD.dbo.DimSchool b  
                           ON a.school_name = b.schoolname
						   INNER JOIN  [dbo].[FY16_Schools_And_ACGrants] c ON b.CYch_SF_ID = c.CY_CHANNEL_SF_ID --c.cyschSchoolRefID

						  

--SOYReport , MYReport , EOYReport ------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_CG SET

SOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Cumulative Course Grade'      AND Pre_Value IS NOT NULL THEN '1' 
                 WHEN SKILL_DESCRIPTION = 'Reporting Period Course Grade' AND Pre_Value IS NOT NULL THEN '2'
				 ELSE NULL
			END,
                      	
MY_Report  = CASE WHEN SKILL_DESCRIPTION = 'Cumulative Course Grade'      AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '1' 
                 WHEN SKILL_DESCRIPTION = 'Reporting Period Course Grade' AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '2'
				 ELSE NULL
			END,

EOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Cumulative Course Grade'       AND Pre_Value IS NOT NULL AND Post_Value IS NOT NULL THEN '1' 
                 WHEN SKILL_DESCRIPTION = 'Reporting Period Course Grade'  AND Pre_Value IS NOT NULL AND Post_Value IS NOT NULL THEN '2'
				 ELSE NULL
			END

------New Field: StartOnStayOn. Added 5/18/2016-----------------------------------------------------------------------------------

UPDATE EVAL_ELA_CG SET
				
STARTONSTAYON = CASE WHEN STARTOFFSLIDING = '0' AND POST_SCALE_NORM = 'On Track' THEN '1'
                     WHEN STARTOFFSLIDING = '0' AND POST_SCALE_NORM in ('Off Track', 'Sliding') THEN '0'
				     WHEN STARTOFFSLIDING <>'0' THEN NULL
				END

--SCALE_CHANGE_NORM_DEGREE

	UPDATE EVAL_ELA_CG SET
	SCALE_CHANGE_NORM_DEGREE = CASE WHEN SCALE_CHANGE_NORM<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_NORM=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_NORM>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_ELA_CG

--SCALE_CHANGE_LOCAL_DEGREE

	UPDATE EVAL_ELA_CG SET
	SCALE_CHANGE_LOCAL_DEGREE = CASE WHEN SCALE_CHANGE_LOCAL<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_LOCAL=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_LOCAL>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_ELA_CG


END




 












GO
