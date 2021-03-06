USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_DESSA_MINI]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_Load_EVAL_DESSA_MINI]
AS
BEGIN


TRUNCATE TABLE [dbo].[EVAL_DESSA_MINI] 

INSERT INTO [dbo].[EVAL_DESSA_MINI] 
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
	NUll,
	NULL,
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
	GETDATE()
	
 FROM [dbo].[9_RPT_PERFORMANCE_LEVEL_BH]
WHERE SKILL_DESCRIPTION = 'Dessa-Mini'



 --PRE
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE PRE FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_DESSA_MINI SET

PRE_DATE					= b.ASSESSMENT_DATE,
PRE_VALUE					= b.PERFORMANCE_VALUE,
PRE_VALUE_DESC				= b.SCALE_NORM,
PRE_INTERVAL				= b.INTERVAL

FROM EVAL_DESSA_MINI a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] b
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
--UPDATE MY FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_DESSA_MINI SET

MY_DATE					= b.ASSESSMENT_DATE,
MY_VALUE				= b.PERFORMANCE_VALUE,
MY_VALUE_DESC			= b.SCALE_NORM,
MY_INTERVAL				= b.INTERVAL


FROM EVAL_DESSA_MINI a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   
						 
WHERE USED_AS_MID_YEAR_DATA_POINT = '1'
AND PRE_DATE <> b.ASSESSMENT_DATE


 --POST
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE POST FIELDS
---------------------------------------------------------------------------------------------------------------------------------
 
 
UPDATE EVAL_DESSA_MINI SET

POST_DATE					= b.ASSESSMENT_DATE,
POST_VALUE					= b.PERFORMANCE_VALUE,
POST_VALUE_DESC  			= b.SCALE_NORM,
POST_INTERVAL				= b.INTERVAL

FROM EVAL_DESSA_MINI a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
						   
						 
WHERE TAG = 'POST'


--MY_DAYS_BETWEEN_ASSESSMENTS-------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	MY_DAYS_BETWEEN_ASSESSMENTS = ABS(DATEDIFF(DAY, CONVERT(DATE,MY_DATE),CONVERT(DATE,PRE_DATE)))

FROM EVAL_DESSA_MINI



--DAYS_BETWEEN_ASSESSMENTS-------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	DAYS_BETWEEN_ASSESSMENTS = ABS(DATEDIFF(DAY, CONVERT(DATE,POST_DATE),CONVERT(DATE,PRE_DATE)))

FROM EVAL_DESSA_MINI


--MY_RAWCHANGE-------------------------------------------------------------------------------------------------

UPDATE EVAL_DESSA_MINI SET

	MY_RAWCHANGE			= CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN CONVERT(INT,(CONVERT(DECIMAL(6,2),MY_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE))) 
							  ELSE NULL 
							  END

FROM EVAL_DESSA_MINI
WHERE MY_RAWCHANGE IS NULL
OR    MY_RAWCHANGE = ''


--RAWCHANGE---------------------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	RAWCHANGE				=  CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(POST_VALUE) = '1'
							       THEN convert(float, CONVERT(DECIMAL(4,2),POST_VALUE) - CONVERT(DECIMAL(4,2),PRE_VALUE))
							       ELSE NULL 
							  END 

FROM EVAL_DESSA_MINI
WHERE RAWCHANGE IS NULL
OR    RAWCHANGE = ''

--MY_RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	MY_RAWCHANGE_DEGREE		= CASE	WHEN MY_RAWCHANGE	> '0' THEN 'INCREASED'
									WHEN MY_RAWCHANGE	= '0' THEN 'NO CHANGE'
									WHEN MY_RAWCHANGE	< '0' THEN 'DECREASED'
						       ELSE NULL
						  END

FROM EVAL_DESSA_MINI


--RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_DESSA_MINI SET

	RAWCHANGE_DEGREE     	= CASE	WHEN RAWCHANGE > '0.00' THEN 'INCREASED'
									WHEN RAWCHANGE = '0.00' THEN 'NO CHANGE'
									WHEN RAWCHANGE < '0.00' THEN 'DECREASED'
						       ELSE NULL
						  END


FROM EVAL_DESSA_MINI


--MY_DESC_CHANGE---------------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	MY_DESC_CHANGE = CASE WHEN MY_VALUE_DESC IS NOT NULL 
						  THEN PRE_VALUE_DESC + '  to  ' + MY_VALUE_DESC
						  ELSE NULL
					 END
FROM EVAL_DESSA_MINI


--DESC_CHANGE---------------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	   DESC_CHANGE = CASE WHEN POST_VALUE_DESC IS NOT NULL 
						  THEN PRE_VALUE_DESC + '  to  ' + POST_VALUE_DESC
						  ELSE NULL
					 END
FROM EVAL_DESSA_MINI


--MY_RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	MY_DESC_CHANGE_DEGREE = CASE WHEN MY_DESC_CHANGE IN ('N  to  S','N  to  T','T  to  S') THEN 'INCREASED'
							     WHEN MY_DESC_CHANGE IN ('N  to  N','T  to  T','S  to  S') THEN 'NO CHANGE'
							     WHEN MY_DESC_CHANGE IN ('S  to  N','S  to  T','T  to  N') THEN 'DECREASED'
						         ELSE NULL
						  END

FROM EVAL_DESSA_MINI


--DESC_CHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	DESC_CHANGE_DEGREE = CASE  WHEN DESC_CHANGE IN ('N  to  S','N  to  T','T  to  S') THEN 'INCREASED'
							   WHEN DESC_CHANGE IN ('N  to  N','T  to  T','S  to  S') THEN 'NO CHANGE'
							   WHEN DESC_CHANGE IN ('S  to  N','S  to  T','T  to  N') THEN 'DECREASED'
						       ELSE NULL
						  END

FROM EVAL_DESSA_MINI



--IA FIELDS------------------------------------------------------------------------------------------------------------

UPDATE EVAL_DESSA_MINI SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM EVAL_DESSA_MINI a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN_WIP] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
						--  AND a.SCHOOL_NAME               = b.SCHOOL_NAME


--ENROLLED_DAYS----------------------------------------------------------------------------------------------------




 
		--SELECT DATEDIFF BETWEEN MIN AND MAX INTERVENTION DATE INTO #BEHAVIOR 
		 SELECT
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC,
		 datediff(dd,MIN(first_intervention), Max(last_intervention)) DAYS_ENROLLED,
		 Max(last_intervention) max_last_intervention
		 INTO  #BEHAVIOR
		 FROM [3_RPT_STUDENT_ENROLLMENT_WIP]
		 WHERE INDICATOR_AREA_DESC = 'Behavior'   
		 group by 
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC

		--UPDATE EVAL_DESSA_MINI ENROLLED_DAYS FROM #BEHAVIOR TABLE WHERE INDICATOR DESC IS BEHAVIOR-----------------
 
		UPDATE EVAL_DESSA_MINI SET
		ENROLLED_DAYS      = b.DAYS_ENROLLED
		FROM EVAL_DESSA_MINI a INNER JOIN #BEHAVIOR b
								   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
		WHERE a.INDICATOR_DESC = 'Behavior'
 
		--UPDATE CURRENTLY_ENROLLED WHERE LAST INTERVENTION EQUAlS TODAYS DATE-----------------------------------------

		

--CURRENTLY ENROLLED---------------------------------------------------------------------------------------------------------------


		--SET CURRENTLY_ENROLLED TO BLANK----------------------------------------------------------------------------

			UPDATE EVAL_DESSA_MINI SET CURRENTLY_ENROLLED = ''

		--UPDATE TO YES WHERE LAST INTERVENTION EQUALS TODAY----------------------------------------------	
			
		UPDATE EVAL_DESSA_MINI SET
		CURRENTLY_ENROLLED =  'YES'
		FROM EVAL_DESSA_MINI a 
								INNER JOIN #BEHAVIOR c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'Behavior'
		AND c.max_last_intervention = convert(date,GETDATE())
		 

		UPDATE EVAL_DESSA_MINI SET
		CURRENTLY_ENROLLED =  'NO'
		FROM EVAL_DESSA_MINI a
								INNER JOIN #BEHAVIOR c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'Behavior'
		AND c.max_last_intervention <> convert(date,GETDATE()) 
		--AND a.CURRENTLY_ENROLLED <> 'YES'
		

		UPDATE EVAL_DESSA_MINI SET
		CURRENTLY_ENROLLED = NULL 
		FROM EVAL_DESSA_MINI a left outer join  #BEHAVIOR  b
		ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
		AND a.INDICATOR_DESC  = b.INDICATOR_AREA_DESC
		WHERE b.CYSCHOOLHOUSE_STUDENT_ID IS NULL 
		AND  b.INDICATOR_AREA_DESC IS NULL 
		AND  a.CURRENTLY_ENROLLED NOT IN ('YES','NO')



--MET_56_DAYS----------------------------------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	MET_56_DAYS = CASE WHEN ENROLLED_DAYS >= 56
					   THEN '1'
					   WHEN ENROLLED_DAYS < 56
					   THEN '0'
				  END
FROM EVAL_DESSA_MINI


--GRADE_GROUP----------------------------------------------------------------------------------------------------------------------------


UPDATE EVAL_DESSA_MINI SET

	GRADE_GROUP = CASE WHEN GRADE BETWEEN 3 and 5 THEN 'GRADES 3 - 5'
	                   WHEN GRADE BETWEEN 6 and 9 THEN 'GRADES 6 - 9'
					   WHEN GRADE < 3 OR GRADE > 9 THEN 'GRADES OUTSIDE 3 - 9'
					   ELSE NULL
				  END
FROM EVAL_DESSA_MINI
WHERE GRADE <> 'K'

UPDATE EVAL_DESSA_MINI SET

	GRADE_GROUP = CASE WHEN GRADE = 'K' THEN 'GRADES OUTSIDE 3 - 9'
					               
					   ELSE GRADE_GROUP
				  END
FROM EVAL_DESSA_MINI
WHERE GRADE = 'K'


--GRANTSITENUM----------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_DESSA_MINI SET
	
	GRANTSITENUM   = c.GRANTSITENUM,
	GRANTCATEGORY  = c.GRANTCATEGORY

FROM EVAL_DESSA_MINI a INNER JOIN SDW_PROD.dbo.DimSchool b  
                           ON a.school_ID = b.schoolID
						   INNER JOIN [dbo].[FY16_Schools_And_ACGrants] c ON b.CYCh_SF_ID =  c.CY_CHANNEL_SF_ID
	





--GRANTCATEGORY---------------------------------------------------------------------------------------------------------------------------






END 













GO
