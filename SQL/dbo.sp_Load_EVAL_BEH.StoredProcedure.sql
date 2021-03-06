USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_BEH]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Load_EVAL_BEH]
AS
BEGIN


TRUNCATE TABLE [dbo].[EVAL_BEH] 

INSERT INTO [dbo].[EVAL_BEH]
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
	FISCAL_YEAR,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	GETDATE()
 FROM  [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] 
 WHERE skill_description IN ('Reporting Period Time Based Behavior Tracker - BEHAVIOR','Cumulative Time Based Behavior Tracker - BEHAVIOR')
 and TAG <> ''


 --PRE
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_ELA_ASSESSMENT:PRE FIELDS	PRE_DATE, PRE_INTERVAL, PRE_VALUE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_BEH SET

PRE_INTERVAL				= b.INTERVAL,
PRE_DATE			        = b.ASSESSMENT_DATE,
PRE_VALUE					= b.PERFORMANCE_VALUE


FROM EVAL_BEH  a INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
							AND a.SCHOOL_ID					= b.SCHOOL_ID
							AND a.SITE_NAME					= b.SITE_NAME
							AND a.STUDENT_NAME				= b.STUDENT_NAME
							AND a.GRADE						= b.GRADE
							AND a.SCHOOL_NAME				= b.SCHOOL_NAME
							AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
							AND a.INDICATOR_DESC			= b.INDICATOR_DESC
							AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
							AND a.DATA_TYPE					= b.DATA_TYPE
WHERE TAG = 'PRE'


--MY
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_ELA_ASSESSMENT: MY FIELDS MY_DATE, MY_INTERVAL, MY_VALUE
----------------------------------------------------------------------------------------------------------------------------------


UPDATE EVAL_BEH SET

MY_INTERVAL				= b.INTERVAL,
MY_DATE			        = b.ASSESSMENT_DATE,
MY_VALUE				= b.PERFORMANCE_VALUE


FROM EVAL_BEH  a INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
							AND a.SCHOOL_ID					= b.SCHOOL_ID
							AND a.SITE_NAME					= b.SITE_NAME
							AND a.STUDENT_NAME				= b.STUDENT_NAME
							AND a.GRADE						= b.GRADE
							AND a.SCHOOL_NAME				= b.SCHOOL_NAME
							AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
							AND a.INDICATOR_DESC			= b.INDICATOR_DESC
							AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
							AND a.DATA_TYPE					= b.DATA_TYPE

WHERE USED_AS_MID_YEAR_DATA_POINT = '1'



--UPDATE MY DATA TO NULL WHERE MY DATA = PRE DATA. --------------------ADDED 5/16/16------------------------------------------------------

UPDATE EVAL_BEH SET
MY_DATE		 = NULL,
MY_INTERVAL  = NULL,
MY_VALUE     = NULL

WHERE  
    PRE_DATE = MY_DATE
AND PRE_INTERVAL = MY_INTERVAL
AND PRE_VALUE = MY_VALUE


--POST
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE EVAL_ELA_ASSESSMENT: MY FIELDS MY_DATE, MY_INTERVAL, MY_VALUE
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_BEH SET

POST_INTERVAL				= b.INTERVAL,
POST_DATE			        = b.ASSESSMENT_DATE,
POST_VALUE				    = b.PERFORMANCE_VALUE


FROM EVAL_BEH  a INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_BH] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
							AND a.SCHOOL_ID					= b.SCHOOL_ID
							AND a.SITE_NAME					= b.SITE_NAME
							AND a.STUDENT_NAME				= b.STUDENT_NAME
							AND a.GRADE						= b.GRADE
							AND a.SCHOOL_NAME				= b.SCHOOL_NAME
							AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
							AND a.INDICATOR_DESC			= b.INDICATOR_DESC
							AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
							AND a.DATA_TYPE					= b.DATA_TYPE

WHERE TAG = 'POST'

--MY_RAWCHANGE----------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	MY_RAWCHANGE			= CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN CONVERT(INT,(CONVERT(DECIMAL(6,2),MY_VALUE) - CONVERT(DECIMAL(6,2),PRE_VALUE))) 
							  ELSE NULL 
							  END

FROM [EVAL_BEH]
WHERE MY_RAWCHANGE IS NULL
OR    MY_RAWCHANGE = ''

--MY_RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE [EVAL_BEH] SET

	MY_RAWCHANGE_DEGREE		= CASE WHEN MY_RAWCHANGE	> '0' THEN 'INCREASED'
							   WHEN MY_RAWCHANGE		= '0' THEN 'NO CHANGE'
							   WHEN MY_RAWCHANGE		< '0' THEN 'DECREASED'
						       ELSE NULL
						  END

FROM [EVAL_BEH]


--RAWCHANGE---------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	RAWCHANGE				= CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(POST_VALUE) = '1'
							       THEN  CONVERT(INT,(CONVERT(float,POST_VALUE) - CONVERT(float,PRE_VALUE)))
							       ELSE NULL 
							  END 

FROM [EVAL_BEH]
WHERE RAWCHANGE IS NULL
OR    RAWCHANGE = ''

--RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	RAWCHANGE_DEGREE		= CASE WHEN RAWCHANGE > '0' THEN 'INCREASED'
							   WHEN RAWCHANGE = '0' THEN 'NO CHANGE'
							   WHEN RAWCHANGE < '0' THEN 'DECREASED'
						       ELSE NULL
						  END


FROM [EVAL_BEH]

--PRE_EWI--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	PRE_EWI		= CASE WHEN PRE_VALUE >= '2' THEN '1'
					   WHEN PRE_VALUE  < '2' THEN '0'
				       ELSE NULL
				  END
FROM [EVAL_BEH]

--PRE_EWI_TEXT--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	PRE_EWI_TEXT = CASE WHEN PRE_EWI = '0' THEN 'No EWI'
	                    WHEN PRE_EWI > '0' THEN 'Has EWI'
						ELSE NULL
				  END
FROM [EVAL_BEH]
 

--MY_EWI--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	MY_EWI		= CASE WHEN MY_VALUE >= '2' THEN '1'
					   WHEN MY_VALUE  < '2' THEN '0'
				       ELSE NULL
				  END
FROM [EVAL_BEH]


--MY_EWI_TEXT--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	MY_EWI_TEXT = CASE WHEN MY_EWI = '0' THEN 'No EWI'
	                   WHEN MY_EWI > '0' THEN 'Has EWI'
						ELSE NULL
				  END
FROM [EVAL_BEH]


--POST_EWI--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	POST_EWI	= CASE WHEN POST_VALUE >= '2' THEN '1'
					   WHEN POST_VALUE  < '2' THEN '0'
				       ELSE NULL
				  END
FROM [EVAL_BEH]


--POST_EWI_TEXT--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	POST_EWI_TEXT = CASE WHEN POST_EWI = '0' THEN 'No EWI'
	                     WHEN POST_EWI > '0' THEN 'Has EWI'
						ELSE NULL
				  END
FROM [EVAL_BEH]


--MY_EWI_CHANGE--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	MY_EWI_CHANGE = CASE WHEN PRE_EWI_TEXT IS NOT NULL AND MY_EWI_TEXT IS NOT NULL 
						 THEN PRE_EWI_TEXT +'  '+'TO'+'  '+ MY_EWI_TEXT
						 ELSE NULL
					 END
FROM [EVAL_BEH]


--MY_EWI_CHANGE--------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

	POST_EWI_CHANGE = CASE WHEN PRE_EWI_TEXT IS NOT NULL AND POST_EWI_TEXT IS NOT NULL 
						   THEN PRE_EWI_TEXT +'  '+'TO'+'  '+ POST_EWI_TEXT
						 ELSE NULL
					 END
FROM [EVAL_BEH]

--ATTENDANCE_IA-------------------------------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM [EVAL_BEH] a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN_WIP] b
				  ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
				  AND a.SITE_NAME                 = b.SITE_NAME
			--	  AND a.SCHOOL_NAME               = b.SCHOOL_NAME

--CURRENTLY_ENROLLED AND ENROLLED_DAYS----------------------------------------------------------------------------------------------------

	--SELECT DATEDIFF BETWEEN MIN AND MAX INTERVENTION DATE INTO #TABLE1 
			 SELECT
			 CYSCHOOLHOUSE_STUDENT_ID,
			 INDICATOR_AREA_DESC,
			 datediff(dd,MIN(first_intervention), Max(last_intervention)) DAYS_ENROLLED
			 INTO  #TABLE1
			 FROM [3_RPT_STUDENT_ENROLLMENT_WIP]
			 WHERE INDICATOR_AREA_DESC = 'Behavior'   
			 group by 
			 CYSCHOOLHOUSE_STUDENT_ID,
			 INDICATOR_AREA_DESC

	--UPDATE [EVAL_BEH] ENROLLED_DAYS FROM #TABLE1  WHERE INDICATOR DESC IS BEHAVIOR-----------------
 
			UPDATE [EVAL_BEH] SET
			ENROLLED_DAYS      = b.DAYS_ENROLLED
			FROM [EVAL_BEH] a INNER JOIN #TABLE1 b
									   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
									  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
			WHERE a.INDICATOR_DESC = 'Behavior'
 
	--UPDATE CURRENTLY_ENROLLED WHERE LAST INTERVENTION EQUAlS TODAYS DATE-----------------------------------------

	
	--SET CURRENTLY_ENROLLED TO BLANK----------------------------------------------------------------------------

			UPDATE [EVAL_BEH] SET CURRENTLY_ENROLLED = ''

	--UPDATE TO YES WHERE LAST INTERVENTION EQUALS MAX INTERVENTION----------------------------------------------	
	
	
			UPDATE [EVAL_BEH] SET
			CURRENTLY_ENROLLED =  'YES'
			FROM [EVAL_BEH] a --INNER JOIN #MAX_INTV b
								--	   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								--	  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
									INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
									  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
									  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
			WHERE a.INDICATOR_DESC = 'Behavior'
			AND c.last_intervention = convert(date,GETDATE()) 

			UPDATE [EVAL_BEH] SET
			CURRENTLY_ENROLLED =  'NO'
			FROM [EVAL_BEH] a --INNER JOIN #MAX_INTV b
								--	   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								--	  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
									INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
									  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
									  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
			WHERE a.INDICATOR_DESC = 'Behavior'
			AND c.last_intervention <> convert(date,GETDATE()) 
			AND a.CURRENTLY_ENROLLED <> 'YES'

	--UPDATE TO NO WHERE NOT ON [3_RPT_STUDENT_ENROLLMENT_WIP]

			UPDATE [EVAL_BEH] SET
			CURRENTLY_ENROLLED = NULL 
			FROM [EVAL_BEH] a left outer join  [3_RPT_STUDENT_ENROLLMENT_WIP]  b
			ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
			AND a.INDICATOR_DESC  = b.INDICATOR_AREA_DESC
			WHERE b.CYSCHOOLHOUSE_STUDENT_ID IS NULL 
			AND  b.INDICATOR_AREA_DESC IS NULL 
			AND  a.CURRENTLY_ENROLLED NOT IN ('YES','NO')


--GRADE_GROUP-----------------------------------------------------------------------------------------------------------------------------------


UPDATE [EVAL_BEH] SET

	GRADE_GROUP = CASE WHEN GRADE BETWEEN 3 and 5 THEN 'GRADES 3 - 5'
	                   WHEN GRADE BETWEEN 6 and 9 THEN 'GRADES 6 - 9'
					   WHEN GRADE < 3 OR GRADE > 9 THEN 'GRADES OUTSIDE 3 - 9'
					   ELSE NULL
				  END
FROM [EVAL_BEH]


--GRANTSITENUM AND GRANTCATEGORY-----------------------------------------------------------------------------------------

UPDATE [EVAL_BEH] SET
	
	GRANTSITENUM   = c.GRANTSITENUM,
	GRANTCATEGORY  = c.GRANTCATEGORY

FROM [EVAL_BEH] a INNER JOIN SDW_Prod.dbo.DimSchool b  
                           ON a.school_ID = b.schoolID
						   --INNER JOIN Goals_Ameri_Corps c ON b.CYSch_SF_ID = c.cyschSchoolRefID
						    INNER JOIN [dbo].[FY16_Schools_And_ACGrants] c ON b.CYCh_SF_ID =  c.CY_CHANNEL_SF_ID
	



	--SOYReport , MYReport , EOYReport ------------------------------------------------------------------------------------------


UPDATE EVAL_BEH SET

SOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'  AND Pre_Value IS NOT NULL THEN '2' 
                 WHEN SKILL_DESCRIPTION = 'Cumulative Time Based Behavior Tracker - BEHAVIOR' AND Pre_Value IS NOT NULL THEN '1'
				 ELSE NULL
			END,
                      	
MY_Report  = CASE WHEN SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'      AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '2' 
                 WHEN SKILL_DESCRIPTION = 'Cumulative Time Based Behavior Tracker - BEHAVIOR' AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '1'
				 ELSE NULL
			END,

EOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'       AND Pre_Value IS NOT NULL AND Post_Value IS NOT NULL THEN '2' 
                 WHEN SKILL_DESCRIPTION = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'  AND Pre_Value IS NOT NULL AND Post_Value IS NOT NULL THEN '1'
				 ELSE NULL
			END

END













GO
