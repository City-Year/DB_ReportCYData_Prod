USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_ELA_ASSESSMENT]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE      PROCEDURE [dbo].[sp_Load_EVAL_ELA_ASSESSMENT]
AS
BEGIN


TRUNCATE TABLE [dbo].[EVAL_ELA_ASSESSMENT] 

INSERT INTO [dbo].[EVAL_ELA_ASSESSMENT] 
	SELECT DISTINCT
	CYSCHOOLHOUSE_STUDENT_ID,
	SCHOOL_ID,
	SITE_NAME,
	STUDENT_NAME,
	GRADE,
	SCHOOL_NAME,
	DIPLOMAS_NOW_SCHOOL,
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
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
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
	GETDATE()
 FROM  [dbo].[9_RPT_PERFORMANCE_LEVEL_AS]
 WHERE indicator_Desc = 'ELA/Literacy'
 --AND SKILL_DESCRIPTION NOT IN ('Cumulative Course Grade','Reporting Period Course Grade')
 AND TAG = 'Pre'
 and used_for_summative_reporting = '1'



 
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_ELA_ASSESSMENT:PRE FIELDS	PRE_ASSESSMENT_DATE, PRE_INTERVAL,PRE_VALUE,PRE_SCALE_LOCAL,PRE_SCALE_NORM,PRE_SCALE_RANK_LOCAL
--										PRE_SCALE_RANK_NORM,PRE_TAGET_SCORE,PRE_MET_TAGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

PRE_ASSESSMENT_DATE			= b.ASSESSMENT_DATE,
PRE_INTERVAL				= b.INTERVAL,
PRE_VALUE					= b.PERFORMANCE_VALUE,
PRE_SCALE_LOCAL				= b.SCALE_LOCAL,
PRE_SCALE_NORM				= b.SCALE_NORM,
PRE_SCALE_RANK_LOCAL		= b.SCALE_NUM_LOCAL,
PRE_SCALE_RANK_NORM			= b.SCALE_NUM_NORM,
PRE_TARGET_SCORE			= b.TARGET_SCORE,
pre_alpha_score_rank	    = b.Score_Rank,
pre_alpha_score_rank_norm    = b.Score_rank_Norm,
pre_alpha_target_score_rank = b.Alpha_Target_Score_Rank,
pre_alpha_target_score_rank_norm = b.alpha_target_score_rank_norm


FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE TAG = 'PRE'

--MY
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_ELA_ASSESSMENT: MY FIELDS MY_ASSESSMENT_DATE, MY_INTERVAL, MY_VALUE,MY_SCALE_LOCAL,MY_SCALE_NORM,
--										MY_SCALE_RANK_LOCAL, MY_SCALE_RANK_NORM,MY_TARGET_SCORE,MY_MET_TARGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

MY_ASSESSMENT_DATE	= b.ASSESSMENT_DATE,
MY_INTERVAL			= b.INTERVAL,
MY_VALUE			= b.PERFORMANCE_VALUE,
MY_SCALE_LOCAL		= b.SCALE_LOCAL,
MY_SCALE_NORM		= b.SCALE_NORM,
MY_SCALE_RANK_LOCAL	= b.SCALE_NUM_LOCAL,
MY_SCALE_RANK_NORM	= b.SCALE_NUM_NORM,
MY_TARGET_SCORE		= b.TARGET_SCORE,
my_alpha_score_rank			= b.Score_Rank,
my_alpha_score_rank_norm    = b.Score_rank_Norm,
my_alpha_target_score_rank	= b.Alpha_Target_Score_Rank,
my_alpha_target_score_rank_norm = b.alpha_target_score_rank_norm

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
						   

WHERE USED_AS_MID_YEAR_DATA_POINT = '1'



--UPDATE MY DATA TO NULL WHERE MY DATA = PRE DATA. --------------------ADDED 2/16/16------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET
MY_ASSESSMENT_DATE = NULL,
MY_INTERVAL        = NULL,
MY_VALUE           = NULL,
MY_SCALE_LOCAL     = NULL,
MY_SCALE_NORM      = NULL,
MY_SCALE_RANK_LOCAL = NULL, 
MY_SCALE_RANK_NORM  = NULL,
MY_ALPHA_SCORE_RANK = NULL,
MY_ALPHA_SCORE_RANK_NORM = NULL,
MY_TARGET_SCORE     = NULL,
MY_ALPHA_TARGET_SCORE_RANK = NULL,
MY_ALPHA_TARGET_SCORE_RANK_NORM = NULL,
MY_MET_TARGET_SCORE = NULL

WHERE  
    PRE_ASSESSMENT_DATE			= MY_ASSESSMENT_DATE
AND PRE_INTERVAL				= MY_INTERVAL
AND PRE_VALUE					= MY_VALUE



--POST
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_ELA_ASSESSMENT: POST FIELDS POST_ASSESSMENT_DATE, POST_INTERVAL, POST_VALUE,POST_SCALE_LOCAL,POST_SCALE_NORM,
--										POST_SCALE_RANK_LOCAL, POST_SCALE_RANK_NORM,POST_TARGET_SCORE,POST_MET_TARGET_SCORE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

POST_ASSESSMENT_DATE	= b.ASSESSMENT_DATE,
POST_INTERVAL			= b.INTERVAL,
POST_VALUE				= b.PERFORMANCE_VALUE,
POST_SCALE_LOCAL		= b.SCALE_LOCAL,
POST_SCALE_NORM			= b.SCALE_NORM,
POST_SCALE_RANK_LOCAL	= b.SCALE_NUM_LOCAL,
POST_SCALE_RANK_NORM	= b.SCALE_NUM_NORM,
POST_TARGET_SCORE		= b.TARGET_SCORE,
post_alpha_score_rank	      = b.Score_Rank,
post_alpha_score_rank_norm    = b.Score_rank_Norm,
post_alpha_target_score_rank  = b.Alpha_Target_Score_Rank,
post_alpha_target_score_rank_norm = b.alpha_target_score_rank_norm

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE

WHERE TAG = 'POST'



-----------------------------------------------------------------------------------------------------------------------
--UPDATE MET_TARGET_SCORES FOR NUMERIC SCORES
-----------------------------------------------------------------------------------------------------------------------



--UPDATE PRE_MET_TARGET_SCORE FOR NUMERIC SCORES

UPDATE EVAL_ELA_ASSESSMENT SET
PRE_MET_TARGET_SCORE =  

 CASE WHEN convert(decimal(6,2),b.PERFORMANCE_VALUE) >= convert(decimal(6,2),b.TARGET_SCORE) 
							AND  b.TARGET_SCORE <> '0'
							THEN '1'
							WHEN convert(decimal(6,2),b.PERFORMANCE_VALUE) < convert(decimal(6,2),b.TARGET_SCORE)
							THEN '0'
							WHEN  b.TARGET_SCORE = '' 
							THEN NULL 
					    END 

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE TAG = 'PRE'					   
AND ISNUMERIC(b.PERFORMANCE_VALUE) = 1
AND ISNUMERIC(b.TARGET_SCORE) = 1



----UPDATE MY_MET_TARGET_SCORE FOR NUMERIC SCORES

UPDATE EVAL_ELA_ASSESSMENT SET
MY_MET_TARGET_SCORE = CASE WHEN convert(decimal(6,2),b.PERFORMANCE_VALUE) >= convert(decimal(6,2),b.TARGET_SCORE) 
							AND  b.TARGET_SCORE <> '0'
							THEN '1'
							WHEN convert(decimal(6,2),b.PERFORMANCE_VALUE) < convert(decimal(6,2),b.TARGET_SCORE)
							THEN '0'
							WHEN  b.TARGET_SCORE = '' 
							THEN NULL 
					   END 

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE USED_AS_MID_YEAR_DATA_POINT = '1'	
AND ISNUMERIC(b.PERFORMANCE_VALUE) = 1
AND ISNUMERIC(b.TARGET_SCORE) = 1
and a.MY_VALUE IS NOT NULL



 
--UPDATE POST_MET_TARGET_SCORE FOR NUMERIC SCORES---------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET
POST_MET_TARGET_SCORE = CASE WHEN convert(decimal(6,2),b.PERFORMANCE_VALUE) >= convert(decimal(6,2),b.TARGET_SCORE) 
							AND  b.TARGET_SCORE <> '0'
							THEN '1'
							WHEN convert(decimal(6,2),b.PERFORMANCE_VALUE) < convert(decimal(6,2),b.TARGET_SCORE)
							THEN '0'
							WHEN  b.TARGET_SCORE = '' 
							THEN NULL 
					   END 

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE TAG = 'POST'					   
AND ISNUMERIC(b.PERFORMANCE_VALUE) = 1
AND ISNUMERIC(b.TARGET_SCORE) = 1 


-----------------------------------------------------------------------------------------------------------------------
--UPDATE MET_TARGET_SCORES FOR ALPHA SCORES
-----------------------------------------------------------------------------------------------------------------------




--UPDATE PRE_MET_TARGET_SCORE FOR ALPHA SCORES----------------------------------------------------------------------



UPDATE EVAL_ELA_ASSESSMENT SET
PRE_MET_TARGET_SCORE = CASE WHEN convert(INT,b.SCORE_RANK)  >= convert(INT,b.ALPHA_TARGET_SCORE_RANK)
							AND  b.ALPHA_TARGET_SCORE_RANK <> ''
							THEN 1
							WHEN convert(INT,b.SCORE_RANK)  < convert(INT,b.ALPHA_TARGET_SCORE_RANK)
							THEN 0
						ELSE NULL
						END 

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE TAG = 'Pre'
AND ISNUMERIC(b.PERFORMANCE_VALUE) = 0
AND ISNUMERIC(b.TARGET_SCORE) = 0

--UPDATE MY_MET_TARGET_SCORE FOR ALPHA SCORES----------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

MY_MET_TARGET_SCORE =  CASE WHEN convert(INT,b.SCORE_RANK)  >= convert(INT,b.ALPHA_TARGET_SCORE_RANK)
							AND  b.ALPHA_TARGET_SCORE_RANK <> ''
							THEN 1
							WHEN convert(INT,b.SCORE_RANK)  < convert(INT,b.ALPHA_TARGET_SCORE_RANK)
							THEN 0
						ELSE NULL
						END 

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE 
USED_AS_MID_YEAR_DATA_POINT = '1'
AND ISNUMERIC(b.PERFORMANCE_VALUE) = 0
AND ISNUMERIC(b.TARGET_SCORE) = 0
AND MY_VALUE IS NOT NULL

--UPDATE POST_MET_TARGET_SCORE FOR ALPHA SCORES----------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

POST_MET_TARGET_SCORE =  CASE WHEN convert(INT,b.SCORE_RANK)  >= convert(INT,b.ALPHA_TARGET_SCORE_RANK)
							AND  b.ALPHA_TARGET_SCORE_RANK <> ''
							THEN 1
							WHEN convert(INT,b.SCORE_RANK)  < convert(INT,b.ALPHA_TARGET_SCORE_RANK)
							THEN 0
						ELSE NULL
						END 

FROM EVAL_ELA_ASSESSMENT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AS] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   AND a.DATA_TYPE					= b.DATA_TYPE
WHERE TAG = 'Post'	
AND ISNUMERIC(b.PERFORMANCE_VALUE) = 0
AND ISNUMERIC(b.TARGET_SCORE) = 0



-------------------------------------------------------------------------------------------------------------------
--CALCULATED FIELDS
-------------------------------------------------------------------------------------------------------------------

--MY_RAWCHANGE----------------------------------------------------------------------------------------------------

--NUMERIC---------------------
UPDATE EVAL_ELA_ASSESSMENT SET

	MY_RAWCHANGE			= CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN (CONVERT(decimal(7,2),MY_VALUE) - CONVERT(decimal(7,2),PRE_VALUE))
							  ELSE NULL 
							  END

FROM EVAL_ELA_ASSESSMENT
WHERE MY_RAWCHANGE IS NULL
OR    MY_RAWCHANGE = ''



--ALPHA-------------------------
UPDATE EVAL_ELA_ASSESSMENT SET

	MY_RAWCHANGE			= CASE WHEN MY_ALPHA_SCORE_RANK IS NOT NULL AND ISNUMERIC(MY_ALPHA_SCORE_RANK) = '1'
							  THEN CONVERT(float,MY_ALPHA_SCORE_RANK) - CONVERT(float,PRE_ALPHA_SCORE_RANK) 
							  ELSE MY_RAWCHANGE 
							  END
WHERE MY_RAWCHANGE IS NULL
OR    MY_RAWCHANGE = ''



--MY_RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

	MY_RAWCHANGE_DEGREE	 	=  CASE WHEN convert(decimal(7,2),MY_RAWCHANGE)	> 0 THEN 'INCREASED'
							   WHEN convert(decimal(7,2),MY_RAWCHANGE)		= 0 THEN 'NO CHANGE'
							   WHEN convert(decimal(7,2),MY_RAWCHANGE)		< 0 THEN 'DECREASED'
						       ELSE NULL
						  END

FROM EVAL_ELA_ASSESSMENT 



--RAWCHANGE---------------------------------------------------------------------------------------------------------------

--NUMERIC
UPDATE EVAL_ELA_ASSESSMENT SET

	RAWCHANGE				= CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(POST_VALUE) = '1'
							       THEN  (CONVERT(decimal(7,2),POST_VALUE) - CONVERT(decimal(7,2),PRE_VALUE))
							       ELSE NULL 
							  END 

FROM EVAL_ELA_ASSESSMENT
WHERE RAWCHANGE IS NULL
OR    RAWCHANGE = ''

--ALPHA

UPDATE EVAL_ELA_ASSESSMENT SET

	RAWCHANGE				= CASE WHEN post_alpha_score_rank IS NOT NULL AND ISNUMERIC(post_alpha_score_rank) = '1'
							       THEN CONVERT(float,post_alpha_score_rank) - CONVERT(float,pre_alpha_score_rank) 
							       ELSE RAWCHANGE
							  END 

FROM EVAL_ELA_ASSESSMENT
WHERE RAWCHANGE IS NULL
OR    RAWCHANGE = ''



--RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

	RAWCHANGE_DEGREE		= CASE WHEN RAWCHANGE > '0' THEN 'INCREASED'
							   WHEN RAWCHANGE = '0' THEN 'NO CHANGE'
							   WHEN RAWCHANGE < '0' THEN 'DECREASED'
						       ELSE NULL
						  END


FROM EVAL_ELA_ASSESSMENT



--MY_SCALE_CHANGE_LOCAL----------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

	MY_SCALE_CHANGE_LOCAL = CASE WHEN MY_SCALE_RANK_LOCAL IS NOT NULL 
							   THEN CONVERT(INT,CONVERT(INT,MY_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL))
							   ELSE NULL
						  END

FROM EVAL_ELA_ASSESSMENT
WHERE MY_SCALE_RANK_LOCAL <> 'NULL' 
 


--select cyschoolhouse_student_id,school_id,site_name, MY_SCALE_RANK_LOCAL, PRE_SCALE_RANK_LOCAL 
--from EVAL_ELA_ASSESSMENT where MY_SCALE_RANK_LOCAL is not null and pre_scale_rank_local is null


--select * from EVAL_ELA_ASSESSMENT where cyschoolhouse_student_id = 'CY-14062'


--SCALE_CHANGE_LOCAL-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

	SCALE_CHANGE_LOCAL		=  CASE WHEN POST_SCALE_RANK_LOCAL IS NOT NULL AND PRE_SCALE_RANK_LOCAL IS NOT NULL
							   THEN CONVERT(INT,POST_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL)
							   ELSE NULL
						  END

FROM EVAL_ELA_ASSESSMENT
WHERE MY_SCALE_RANK_LOCAL <> 'NULL'

--select * from EVAL_ELA_ASSESSMENT

--select cyschoolhouse_student_id,skill_description,school_id,site_name,POST_SCALE_RANK_LOCAL, PRE_SCALE_RANK_LOCAL from EVAL_ELA_ASSESSMENT 
--where MY_SCALE_RANK_LOCAL is not null and pre_scale_rank_local is null

--MY_SCALE_CHANGE_NORM-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

MY_SCALE_CHANGE_NORM	= CASE WHEN MY_SCALE_RANK_NORM IS NOT NULL
							   THEN CONVERT(INT,MY_SCALE_RANK_NORM) - CONVERT(INT,PRE_SCALE_RANK_NORM)
							   ELSE NULL
						  END
	

FROM EVAL_ELA_ASSESSMENT

--SCALE_CHANGE_NORM-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

SCALE_CHANGE_NORM		= CASE WHEN POST_SCALE_RANK_NORM IS NOT NULL
							   THEN CONVERT(INT,POST_SCALE_RANK_NORM) - CONVERT(INT,PRE_SCALE_RANK_NORM)
							   ELSE NULL
						  END
FROM EVAL_ELA_ASSESSMENT


--MY_SCALE_CHANGE_LOCAL_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

  MY_SCALE_CHANGE_LOCAL_TEXT	= CASE WHEN MY_SCALE_CHANGE_LOCAL IS NOT NULL 
							       THEN PRE_SCALE_LOCAL + '  ' + 'TO' + '  ' + MY_SCALE_LOCAL
							       ELSE NULL
							  END

FROM EVAL_ELA_ASSESSMENT

--SCALE_CHANGE_LOCAL_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

   SCALE_CHANGE_LOCAL_TEXT		= CASE WHEN POST_SCALE_LOCAL IS NOT NULL 
								   THEN PRE_SCALE_LOCAL + '  ' + 'TO' + '  ' + POST_SCALE_LOCAL
								   ELSE NULL
							  END

FROM EVAL_ELA_ASSESSMENT


--MY_SCALE_CHANGE_NORM_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

MY_SCALE_CHANGE_NORM_TEXT	= CASE WHEN MY_SCALE_NORM IS NOT NULL 
								   THEN PRE_SCALE_NORM + '  ' + 'TO' + '  ' + MY_SCALE_NORM
								   ELSE NULL
							  END
 FROM EVAL_ELA_ASSESSMENT


  
--SCALE_CHANGE_NORM_TEXT-------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

SCALE_CHANGE_NORM_TEXT		= CASE WHEN POST_SCALE_NORM IS NOT NULL 
								   THEN PRE_SCALE_NORM + '  ' + 'TO' + '  ' + POST_SCALE_NORM
								   ELSE NULL
							  END

FROM EVAL_ELA_ASSESSMENT

--START OFF SLIDING----------------------------------------------------------------------------------------------------------- 

UPDATE EVAL_ELA_ASSESSMENT SET

STARTOFFSLIDING = CASE WHEN PRE_SCALE_NORM LIKE '%OF%' OR PRE_SCALE_NORM LIKE '%SL%'
                       THEN 1
					   WHEN PRE_SCALE_NORM LIKE '%ON%'
					   THEN 0
					   ELSE NULL
				  END
FROM EVAL_ELA_ASSESSMENT
WHERE PRE_SCALE_NORM is not NULL AND POST_SCALE_NORM is not null

--MY_SOS_MoveOn--------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

 MY_SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND MY_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (MY_SCALE_NORM LIKE 'OF%' OR MY_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ELA_ASSESSMENT



--SOS_MoveOn--------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

 SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND POST_SCALE_NORM LIKE 'ON%'
					  THEN '1'
					  WHEN STARTOFFSLIDING = '1' AND (POST_SCALE_NORM LIKE 'OF%' OR POST_SCALE_NORM LIKE 'SL%')
					  THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ELA_ASSESSMENT



	
--TEAM_JUNE_DOSAGE_GOAL-------------------------------------------------------------------------------------------------

UPDATE  EVAL_ELA_ASSESSMENT SET

	TEAM_JUNE_DOSAGE_GOAL = c.[JUN_ELA_DosageGoal]

FROM EVAL_ELA_ASSESSMENT a INNER JOIN SDW_PROD.dbo.Dimschool b  
                           --ON a.school_ID = b.schoolID          REMOVED BECAUSE OF MULTIPLE SPLIT SCHOOL ID's ON DIMSCHOOL 
						   ON a.school_name = b.SchoolName
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CYCH_SF_ID = c.CY_CHANNEL_SF_ID







				/*INNER JOIN [dbo].[2_RPT_SCHOOL_MAIN] b 
                           ON a.school_ID = b.school_ID
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CY_CHANNEL_SF_ID = c.CY_CHANNEL_SF_ID
				*/



--TEAM_MONTH_DOSAGE_GOAL----------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET 

TEAM_MONTH_DOSAGE_GOAL =   CASE	WHEN month(getdate()) = 1 THEN  convert(decimal(7,2),c.[DEC_ELA_DosageGoal])
								WHEN month(getdate()) = 2 THEN  convert(decimal(7,2),c.[JAN_ELA_DosageGoal])
								WHEN month(getdate()) = 3 THEN	convert(decimal(7,2),c.[FEB_ELA_DosageGoal])
								WHEN month(getdate()) = 4 THEN  convert(decimal(7,2),c.[MAR_ELA_DosageGoal])
								WHEN month(getdate()) = 5 THEN  convert(decimal(7,2),c.[APR_ELA_DosageGoal])
								WHEN month(getdate()) = 6 THEN  convert(decimal(7,2),c.[MAY_ELA_DosageGoal])
								WHEN month(getdate()) = 7 THEN  convert(decimal(7,2),c.[JUN_ELA_DosageGoal])
								WHEN month(getdate()) = 9 THEN  convert(decimal(7,2),c.[AUG_ELA_DosageGoal])
								WHEN month(getdate()) = 10 THEN convert(decimal(7,2),c.[SEP_ELA_DosageGoal])
								WHEN month(getdate()) = 11 THEN convert(decimal(7,2),c.[OCT_ELA_DosageGoal]) 
								WHEN month(getdate()) = 12 THEN convert(decimal(7,2),c.[NOV_ELA_DosageGoal])
								ELSE NULL
						END		 
							  
FROM EVAL_ELA_ASSESSMENT a INNER JOIN SDW_PROD.dbo.Dimschool b
							ON a.school_name = b.SchoolName  
                           --ON a.school_ID = b.schoolID    REMOVED BECAUSE OF MULTIPLE SPLIT SCHOOL ID's ON DIMSCHOOL
						   INNER JOIN [dbo].[Goals_Dosage_2] c
						   ON b.CYCH_SF_ID = c.CY_CHANNEL_SF_ID



--TTL_TIME AND DOSAGE_CATEGORY--------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

TTL_TIME			= b.TTL_TIME,
DOSAGE_CATEGORY		= b.DOSAGE_CATEGORY

FROM EVAL_ELA_ASSESSMENT a INNER JOIN [dbo].[8_RPT_STUDENT_TIME_LINEAR] b
                           ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
                          AND a.INDICATOR_DESC            = b.INDICATOR_AREA_DESC
						  

--STATUS_JUNE_DOSAGE_GOAL-----------------------------------------------------------------------------------------------------


UPDATE EVAL_ELA_ASSESSMENT SET

	STATUS_JUNE_DOSAGE_GOAL = CASE	WHEN convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) >= convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '1' 
									WHEN convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) < convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							  END
FROM EVAL_ELA_ASSESSMENT  


/*
CASE	WHEN convert(float,TTL_TIME/60) >= convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '1' 
									WHEN convert(float,TTL_TIME/60) < convert(float,TEAM_JUNE_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							  END
							  */
--STATUS_MONTH_DOSAGE_GOAL-----------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

	STATUS_MONTH_DOSAGE_GOAL = CASE WHEN round(convert(float,TTL_TIME)/Convert(float,60),2) >= convert(float,TEAM_MONTH_DOSAGE_GOAL) THEN '1'
									WHEN round(convert(float,TTL_TIME)/Convert(float,60),2) <  convert(float,TEAM_MONTH_DOSAGE_GOAL) THEN '0'
									ELSE NULL
							   END
FROM EVAL_ELA_ASSESSMENT 



/*
select	
		round(convert(float,TTL_TIME)/Convert(float,60),2) AS CALC1,
		convert(decimal(7,2),convert(decimal(7,2),TTL_TIME)/60) AS CALC2,
		TEAM_MONTH_DOSAGE_GOAL,
		STATUS_MONTH_DOSAGE_GOAL
				
from EVAL_MATH_ASSESSMENT  where TEAM_MONTH_DOSAGE_GOAL is not null CYSCHOOLHOUSE_STUDENT_ID = 'CY-15877' 
*/


--CURRENTLY_ENROLLED AND ENROLLED_DAYS----------------------------------------------------------------------------------------------------

/*
UPDATE EVAL_ELA_ASSESSMENT SET

 CURRENTLY_ENROLLED = b.CURRENTLY_ENROLLED,
 ENROLLED_DAYS      = b.ENROLLED_DAYS

FROM EVAL_ELA_ASSESSMENT a INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] b
                           ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
                          AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC

*/

--SELECT DATEDIFF BETWEEN MIN AND MAX INTERVENTION DATE INTO #BEHAVIOR 
		 SELECT
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC,
		 datediff(dd,MIN(first_intervention), Max(last_intervention)) DAYS_ENROLLED
		 INTO  #Assessment
		 FROM [3_RPT_STUDENT_ENROLLMENT_WIP]
		 WHERE INDICATOR_AREA_DESC = 'ELA/Literacy'  
		 group by 
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC

		--UPDATE EVAL_DESSA_MINI ENROLLED_DAYS FROM #BEHAVIOR TABLE WHERE INDICATOR DESC IS BEHAVIOR-----------------
 
		UPDATE EVAL_ELA_ASSESSMENT SET
		ENROLLED_DAYS      =  b.DAYS_ENROLLED
		FROM EVAL_ELA_ASSESSMENT a INNER JOIN #Assessment b
								   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
		WHERE a.INDICATOR_DESC = 'ELA/Literacy'  
 


--CURRENTLY ENROLLED---------------------------------------------------------------------------------------------------------------


		--SET CURRENTLY_ENROLLED TO BLANK----------------------------------------------------------------------------

			UPDATE EVAL_ELA_ASSESSMENT SET CURRENTLY_ENROLLED = ''

		--UPDATE TO YES WHERE LAST INTERVENTION EQUALS TODAY----------------------------------------------	
		
	
		UPDATE EVAL_ELA_ASSESSMENT SET
		CURRENTLY_ENROLLED =  'YES'
		FROM EVAL_ELA_ASSESSMENT a 
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'ELA/Literacy' 
		AND c.last_intervention = convert(date,GETDATE()) 


		UPDATE EVAL_ELA_ASSESSMENT SET
		CURRENTLY_ENROLLED =  'NO'
		FROM EVAL_ELA_ASSESSMENT a
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'ELA/Literacy'  
		AND c.last_intervention <> convert(date,GETDATE()) 
		AND a.CURRENTLY_ENROLLED <> 'YES'
		

		UPDATE EVAL_ELA_ASSESSMENT SET
		CURRENTLY_ENROLLED = NULL 
		FROM EVAL_ELA_ASSESSMENT a left outer join  [3_RPT_STUDENT_ENROLLMENT_WIP]  b
		ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
		AND a.INDICATOR_DESC  = b.INDICATOR_AREA_DESC
		WHERE b.CYSCHOOLHOUSE_STUDENT_ID IS NULL 
		AND  b.INDICATOR_AREA_DESC IS NULL 
		AND  a.CURRENTLY_ENROLLED NOT IN ('YES','NO')

		

--GRANTSITENUM AND GRANTCATEGORY-----------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET
	GRANTSITENUM  = c.GrantSiteNum,
	GRANTCATEGORY = c.GrantCategory
FROM 
 EVAL_ELA_ASSESSMENT a inner join SDW_PROD.dbo.DimSchool    b ON SCHOOL_NAME = b.SCHOOLNAME   -- on a.School_ID = b.schoolID  
                       inner join [dbo].[FY16_Schools_And_ACGrants] c on b.CYch_SF_ID = c.CY_CHANNEL_SF_ID




--RENAME SPLIT SCHOOL NAMES TO NON SPLIT SCHOOL NAME --------------------------------------------------------------------- 

	UPDATE EVAL_ELA_ASSESSMENT SET 
	SCHOOL_NAME = LEFT(SCHOOL_NAME,CHARINDEX('(',SCHOOL_NAME)-1)
	FROM EVAL_ELA_ASSESSMENT 
	WHERE SCHOOL_NAME like '%(%-%)%'



--ATTENDANCE_IA-------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ELA_ASSESSMENT SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM EVAL_ELA_ASSESSMENT a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN_WIP] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
						  AND a.SCHOOL_NAME               = b.SCHOOL_NAME

						  

	

	--SCALE_CHANGE_NORM_DEGREE

	UPDATE EVAL_ELA_ASSESSMENT SET
	SCALE_CHANGE_NORM_DEGREE = CASE WHEN SCALE_CHANGE_NORM<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_NORM=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_NORM>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_ELA_ASSESSMENT

	--SCALE_CHANGE_LOCAL_DEGREE

	UPDATE EVAL_ELA_ASSESSMENT SET
	SCALE_CHANGE_LOCAL_DEGREE = CASE WHEN SCALE_CHANGE_LOCAL<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_LOCAL=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_LOCAL>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_ELA_ASSESSMENT

END





















GO
