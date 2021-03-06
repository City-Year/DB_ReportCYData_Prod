USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_ELA_SB]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_Load_EVAL_ELA_SB]
AS
BEGIN


TRUNCATE TABLE [dbo].[EVAL_ELA_SB] 

INSERT INTO [dbo].[EVAL_ELA_SB] 
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
	DATA_TYPE, 
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	FISCAL_YEAR
	
 FROM [dbo].[9_RPT_PERFORMANCE_LEVEL_SB]
  WHERE indicator_Desc = 'ELA/Literacy'
 AND SKILL_DESCRIPTION NOT IN ('Cumulative Course Grade','Reporting Period Course Grade')



  --PRE
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE PRE FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_ELA_SB SET

PRE_DATE					= b.ASSESSMENT_DATE,
PRE_INTERVAL				= b.INTERVAL,
PRE_VALUE					= b.PERFORMANCE_VALUE,
PRE_SCALE_LOCAL             = b.SCALE_LOCAL,
PRE_SCALE_RANK_LOCAL        = b.SCALE_NUM_LOCAL,
PRE_SCALE_NORM				= b.SCALE_NORM,
PRE_SCALE_RANK_NORM         = b.SCALE_NUM_NORM

FROM EVAL_ELA_SB a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE                  = b.DATA_TYPE
						 
WHERE TAG = 'PRE'


--MY
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE PRE FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_ELA_SB SET

MY_DATE					= b.ASSESSMENT_DATE,
MY_INTERVAL				= b.INTERVAL,
MY_VALUE				= b.PERFORMANCE_VALUE,
MY_SCALE_LOCAL          = b.SCALE_LOCAL,
MY_SCALE_RANK_LOCAL     = b.SCALE_NUM_LOCAL,
MY_SCALE_NORM			= b.SCALE_NORM,
MY_SCALE_RANK_NORM      = b.SCALE_NUM_NORM

FROM EVAL_ELA_SB a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE                  = b.DATA_TYPE
						 
WHERE USED_AS_MID_YEAR_DATA_POINT = '1'


 --POST
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE PRE FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_ELA_SB SET

POST_DATE					= b.ASSESSMENT_DATE,
POST_INTERVAL				= b.INTERVAL,
POST_VALUE					= b.PERFORMANCE_VALUE,
POST_SCALE_LOCAL            = b.SCALE_LOCAL,
POST_SCALE_RANK_LOCAL       = b.SCALE_NUM_LOCAL,
POST_SCALE_NORM				= b.SCALE_NORM,
POST_SCALE_RANK_NORM        = b.SCALE_NUM_NORM

FROM EVAL_ELA_SB a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_CG] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE                  = b.DATA_TYPE
						 
WHERE TAG = 'POST'


--MY_RAWCHANGE-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

	MY_RAWCHANGE			= CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN CONVERT(INT,(CONVERT(DECIMAL(6,2),MY_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE))) 
							  ELSE NULL 
							  END

FROM EVAL_ELA_SB
WHERE MY_RAWCHANGE IS NULL
OR    MY_RAWCHANGE = ''

--MY_RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_SB SET

	MY_RAWCHANGE_DEGREE		= CASE WHEN MY_RAWCHANGE	> '0' THEN 'INCREASED'
							   WHEN MY_RAWCHANGE		= '0' THEN 'NO CHANGE'
							   WHEN MY_RAWCHANGE		< '0' THEN 'DECREASED'
						       ELSE NULL
						  END

FROM EVAL_ELA_SB


--RAWCHANGE---------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_SB SET

	RAWCHANGE				=  CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(POST_VALUE) = '1'
							       THEN convert(varchar(250), CONVERT(DECIMAL(4,2),POST_VALUE) - CONVERT(DECIMAL(4,2),PRE_VALUE))
							       ELSE NULL 
							  END 

FROM EVAL_ELA_SB
WHERE RAWCHANGE IS NULL
OR    RAWCHANGE = ''


--RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

	RAWCHANGE_DEGREE		= CASE WHEN RAWCHANGE > '0' THEN 'INCREASED'
							   WHEN RAWCHANGE = '0' THEN 'NO CHANGE'
							   WHEN RAWCHANGE < '0' THEN 'DECREASED'
						       ELSE NULL
						  END


FROM EVAL_ELA_SB


--MY_SCALE_CHANGE_LOCAL----------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

	MY_SCALE_CHANGE_LOCAL	= CASE WHEN MY_SCALE_RANK_LOCAL IS NOT NULL
							   THEN CONVERT(INT,CONVERT(INT,MY_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL))
							   ELSE NULL
						  END

FROM EVAL_ELA_SB


--SCALE_CHANGE_LOCAL-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

	SCALE_CHANGE_LOCAL	= CASE WHEN MY_SCALE_RANK_LOCAL IS NOT NULL
							   THEN CONVERT(INT,CONVERT(INT,POST_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL))
							   ELSE NULL
						  END

FROM EVAL_ELA_SB


--MY_SCALE_CHANGE_NORM-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

MY_SCALE_CHANGE_NORM	= CASE WHEN MY_SCALE_RANK_NORM IS NOT NULL
							   THEN CONVERT(INT,MY_SCALE_RANK_NORM) - CONVERT(INT,PRE_SCALE_RANK_NORM)
							   ELSE NULL
						  END
	

FROM EVAL_ELA_SB

--SCALE_CHANGE_NORM-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

SCALE_CHANGE_NORM		= CASE WHEN POST_SCALE_RANK_NORM IS NOT NULL
							   THEN CONVERT(INT,POST_SCALE_RANK_NORM) - CONVERT(INT,PRE_SCALE_RANK_NORM)
							   ELSE NULL
						  END
FROM EVAL_ELA_SB

--MY_SCALE_CHANGE_LOCAL_TEXT-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

  MY_SCALE_CHANGE_LOCAL_TEXT	= CASE WHEN MY_SCALE_CHANGE_LOCAL IS NOT NULL 
							       THEN PRE_SCALE_LOCAL + '  ' + 'TO' + '  ' + MY_SCALE_LOCAL
							       ELSE NULL
							  END

FROM EVAL_ELA_SB


--SCALE_CHANGE_LOCAL_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_SB SET

   SCALE_CHANGE_LOCAL_TEXT		= CASE WHEN POST_SCALE_LOCAL IS NOT NULL 
								   THEN PRE_SCALE_LOCAL + '  ' + 'TO' + '  ' + POST_SCALE_LOCAL
								   ELSE NULL
							  END

FROM EVAL_ELA_SB

--MY_SCALE_CHANGE_NORM_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_SB SET

MY_SCALE_CHANGE_NORM_TEXT	= CASE WHEN MY_SCALE_NORM IS NOT NULL 
								   THEN PRE_SCALE_NORM + '  ' + 'TO' + '  ' + MY_SCALE_NORM
								   ELSE NULL
							  END
 FROM EVAL_ELA_SB

 --SCALE_CHANGE_NORM_TEXT-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

SCALE_CHANGE_NORM_TEXT		= CASE WHEN POST_SCALE_NORM IS NOT NULL 
								   THEN PRE_SCALE_NORM + '  ' + 'TO' + '  ' + POST_SCALE_NORM
								   ELSE NULL
							  END

FROM EVAL_ELA_SB

--START OFF SLIDING----------------------------------------------------------------------------------------------------------- 

UPDATE EVAL_ELA_SB SET

STARTOFFSLIDING = CASE WHEN PRE_SCALE_NORM LIKE '%OF%' OR PRE_SCALE_NORM LIKE '%SL%'
                       THEN 1
					   WHEN PRE_SCALE_NORM LIKE '%ON%'
					   THEN 0
					   ELSE NULL
				  END
FROM EVAL_ELA_SB


--MY_SOS_MoveOn-----------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_SB SET

 MY_SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND MY_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (MY_SCALE_NORM LIKE 'OF%' OR MY_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ELA_SB


--SOS_MoveOn---------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

 SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND POST_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (POST_SCALE_NORM LIKE 'OF%' OR POST_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ELA_SB

--IA FIELDS------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM EVAL_ELA_SB a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
						  AND a.SCHOOL_NAME               = b.SCHOOL_NAME


--TEAM_JUNE_DOSAGE_GOAL-------------------------------------------------------------------------------------------------

UPDATE  EVAL_ELA_SB SET

	TEAM_JUNE_DOSAGE_GOAL = b.[JUN_ELA_DosageGoal]

FROM EVAL_ELA_SB a INNER JOIN [dbo].[Goals_Dosage] b 
                   ON a.school_ID = b.ID


--TEAM_MONTH_DOSAGE_GOAL----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET 

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
							  
FROM EVAL_ELA_SB a INNER JOIN [dbo].[Goals_Dosage] b 
                           ON a.SCHOOL_ID = b.ID


--TTL_TIME --------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

TTL_TIME	= b.TTL_SUM

FROM EVAL_ELA_SB a INNER JOIN (SELECT CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC,SUM(TTL_TIME) AS TTL_SUM
										FROM [8_RPT_STUDENT_TIME_LINEAR] 
										GROUP BY  CYSCHOOLHOUSE_STUDENT_ID, INDICATOR_AREA_DESC) AS b
										ON b.CYSCHOOLHOUSE_STUDENT_ID = a.CYSCHOOLHOUSE_STUDENT_ID


--STATUS_JUNE_DOSAGE_GOAL-----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

	STATUS_JUNE_DOSAGE_GOAL = CASE	WHEN TTL_TIME >= TEAM_JUNE_DOSAGE_GOAL THEN '1' 
									WHEN TTL_TIME <  TEAM_JUNE_DOSAGE_GOAL THEN '0'
									ELSE NULL
							  END
FROM EVAL_ELA_SB

--STATUS_MONTH_DOSAGE_GOAL-----------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

	STATUS_MONTH_DOSAGE_GOAL = CASE WHEN TTL_TIME >= TEAM_MONTH_DOSAGE_GOAL THEN '1'
									WHEN TTL_TIME <  TEAM_MONTH_DOSAGE_GOAL THEN '0'
									ELSE NULL
							   END
FROM EVAL_ELA_SB

--CURRENTLY_ENROLLED AND ENROLLED_DAYS----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_SB SET

 CURRENTLY_ENROLLED = b.CURRENTLY_ENROLLED,
 ENROLLED_DAYS      = b.ENROLLED_DAYS

FROM EVAL_ELA_SB a INNER JOIN [3_RPT_STUDENT_ENROLLMENT] b
                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
                          AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC



END





GO
