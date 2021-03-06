USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_EVAL_ATTENDANCE]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[sp_Load_EVAL_ATTENDANCE]
AS
BEGIN


TRUNCATE TABLE [dbo].[EVAL_ATT] 

INSERT INTO [dbo].[EVAL_ATT] 
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
	
 FROM [dbo].[9_RPT_PERFORMANCE_LEVEL_AT]
 WHERE USED_FOR_SUMMATIVE_REPORTING = '1'
 AND TAG = 'PRE'



--PRE
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE "PRE" FIELDS	PRE_DATE, PRE_INTERVAL,PRE_VALUE,PRE_SCALE_LOCAL,PRE_SCALE_NORM,PRE_SCALE_RANK_LOCAL
--						PRE_SCALE_RANK_NORM
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

PRE_DATE					= b.ASSESSMENT_DATE,
PRE_INTERVAL				= b.INTERVAL,
PRE_VALUE					= b.PERFORMANCE_VALUE,
PRE_SCALE_LOCAL				= b.SCALE_LOCAL,
PRE_SCALE_NORM				= b.SCALE_NORM,
PRE_SCALE_RANK_LOCAL		= b.SCALE_NUM_LOCAL,
PRE_SCALE_RANK_NORM			= b.SCALE_NUM_NORM

FROM EVAL_ATT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AT] b
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
--UPDATE "MY" FIELDS	MY_ASSESSMENT_DATE, MY_INTERVAL,MY_VALUE,MY_SCALE_LOCAL,MY_SCALE_NORM,MY_SCALE_RANK_LOCAL
--						MY_SCALE_RANK_NORM
----------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

MY_DATE				= b.ASSESSMENT_DATE,
MY_INTERVAL			= b.INTERVAL,
MY_VALUE			= b.PERFORMANCE_VALUE,
MY_SCALE_LOCAL		= b.SCALE_LOCAL,
MY_SCALE_NORM		= b.SCALE_NORM,
MY_SCALE_RANK_LOCAL	= b.SCALE_NUM_LOCAL,
MY_SCALE_RANK_NORM	= b.SCALE_NUM_NORM

FROM EVAL_ATT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AT] b
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
AND a.PRE_DATE <> b.ASSESSMENT_DATE      --ADDED LOGIC PER EVAL 11/30/2015



--POST
----------------------------------------------------------------------------------------------------------------------------------
--UPDATE "POST" FIELDS	POST_ASSESSMENT_DATE, POST_INTERVAL,POST_VALUE,POST_SCALE_LOCAL,POST_SCALE_NORM,POST_SCALE_RANK_LOCAL
--						POST_SCALE_RANK_NORM
----------------------------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

POST_DATE				= b.ASSESSMENT_DATE,
INTERVAL				= b.INTERVAL,
POST_VALUE				= b.PERFORMANCE_VALUE,
POST_SCALE_LOCAL		= b.SCALE_LOCAL,
POST_SCALE_NORM			= b.SCALE_NORM,
POST_SCALE_RANK_LOCAL	= b.SCALE_NUM_LOCAL,
POST_SCALE_RANK_NORM	= b.SCALE_NUM_NORM

FROM EVAL_ATT a	INNER JOIN [dbo].[9_RPT_PERFORMANCE_LEVEL_AT] b
							ON a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID
						   AND a.SCHOOL_ID					= b.SCHOOL_ID
						   AND a.SITE_NAME					= b.SITE_NAME
						   AND a.STUDENT_NAME				= b.STUDENT_NAME
						   AND a.GRADE						= b.GRADE
						   AND a.SCHOOL_NAME				= b.SCHOOL_NAME
						   AND a.DIPLOMAS_NOW_SCHOOL		= b.DIPLOMAS_NOW_SCHOOL
						   AND a.INDICATOR_DESC				= b.INDICATOR_DESC
						   AND a.SKILL_DESCRIPTION			= b.SKILL_DESCRIPTION
				  
WHERE TAG = 'Post'

--MY_RAWCHANGE----------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

	MY_RAWCHANGE	 		=  CASE WHEN MY_VALUE IS NOT NULL AND ISNUMERIC(MY_VALUE) = '1'
							  THEN CONVERT(varchar(250),(CONVERT(float,MY_VALUE) - CONVERT(float,PRE_VALUE))) 
							  ELSE NULL 
							  END

FROM EVAL_ATT
WHERE MY_RAWCHANGE IS NULL
OR    MY_RAWCHANGE = ''


--MY_RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

	MY_RAWCHANGE_DEGREE		= CASE WHEN MY_RAWCHANGE		> 0 THEN 'INCREASED'
							   WHEN		MY_RAWCHANGE		= 0 THEN 'NO CHANGE'
							   WHEN		MY_RAWCHANGE		< 0 THEN 'DECREASED'
						       ELSE NULL
						  END

FROM EVAL_ATT




--RAWCHANGE---------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

	RAWCHANGE				=  CASE WHEN POST_VALUE IS NOT NULL AND ISNUMERIC(POST_VALUE) = '1'
							       THEN convert(varchar(250), CONVERT(float,POST_VALUE) - CONVERT(float,PRE_VALUE))
							       --THEN CONVERT(float,POST_VALUE) - CONVERT(float,PRE_VALUE)
								   ELSE NULL 
							  END 

FROM EVAL_ATT
WHERE RAWCHANGE IS NULL
OR    RAWCHANGE = ''


--RAWCHANGE_DEGREE----------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	RAWCHANGE_DEGREE		= CASE WHEN RAWCHANGE  > 0 THEN 'INCREASED'
							   WHEN		RAWCHANGE	 = 0 THEN 'NO CHANGE'
							   WHEN		RAWCHANGE	 < 0 THEN 'DECREASED'
						       ELSE NULL
						  END


FROM EVAL_ATT


--MY_SCALE_CHANGE_LOCAL----------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	MY_SCALE_CHANGE_LOCAL	= CASE WHEN MY_SCALE_RANK_LOCAL IS NOT NULL
							   THEN CONVERT(INT,CONVERT(INT,MY_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL))
							   ELSE NULL
						  END

FROM EVAL_ATT

--MY_SCALE_CHANGE_LOCAL_TEXT-------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

  MY_SCALE_CHANGE_LOCAL_TEXT	= CASE WHEN MY_SCALE_CHANGE_LOCAL IS NOT NULL 
							       THEN PRE_SCALE_LOCAL + '  ' + 'TO' + '  ' + MY_SCALE_LOCAL
							       ELSE NULL
							  END

FROM EVAL_ATT


--SCALE_CHANGE_LOCAL-------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	SCALE_CHANGE_LOCAL		= CASE WHEN POST_SCALE_RANK_LOCAL IS NOT NULL
							   THEN CONVERT(INT,POST_SCALE_RANK_LOCAL) - CONVERT(INT,PRE_SCALE_RANK_LOCAL)
							   ELSE NULL
						  END

FROM EVAL_ATT


--SCALE_CHANGE_LOCAL_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

   SCALE_CHANGE_LOCAL_TEXT		= CASE WHEN POST_SCALE_LOCAL IS NOT NULL 
								   THEN PRE_SCALE_LOCAL + '  ' + 'TO' + '  ' + POST_SCALE_LOCAL
								   ELSE NULL
							  END

FROM EVAL_ATT


--MY_SCALE_CHANGE_NORM-------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

MY_SCALE_CHANGE_NORM	= CASE WHEN MY_SCALE_RANK_NORM IS NOT NULL
							   THEN CONVERT(INT,MY_SCALE_RANK_NORM) - CONVERT(INT,PRE_SCALE_RANK_NORM)
							   ELSE NULL
						  END
	

FROM EVAL_ATT


--MY_SCALE_CHANGE_NORM_TEXT-------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

MY_SCALE_CHANGE_NORM_TEXT	= CASE WHEN MY_SCALE_NORM IS NOT NULL 
								   THEN PRE_SCALE_NORM + '  ' + 'TO' + '  ' + MY_SCALE_NORM
								   ELSE NULL
							  END
 FROM EVAL_ATT


--SCALE_CHANGE_NORM-------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

SCALE_CHANGE_NORM		= CASE WHEN POST_SCALE_RANK_NORM IS NOT NULL
							   THEN CONVERT(INT,POST_SCALE_RANK_NORM) - CONVERT(INT,PRE_SCALE_RANK_NORM)
							   ELSE NULL
						  END
FROM EVAL_ATT


--SCALE_CHANGE_NORM_TEXT-------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

SCALE_CHANGE_NORM_TEXT		= CASE WHEN POST_SCALE_NORM IS NOT NULL 
								   THEN PRE_SCALE_NORM + '  ' + 'TO' + '  ' + POST_SCALE_NORM
								   ELSE NULL
							  END

FROM EVAL_ATT



--MY_INC_1_PERC----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

MY_INC_1_PERC = CASE WHEN convert(float,MY_RAWCHANGE) >= .01 THEN '1' 
					 WHEN convert(float,MY_RAWCHANGE) < .01 THEN '0'	
					 ELSE NULL
                END

FROM EVAL_ATT


--INC_1_PERC----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

INC_1_PERC = CASE WHEN CONVERT(float,RAWCHANGE) >= .01 THEN '1' 
				  WHEN CONVERT(float,RAWCHANGE) <  .01 THEN '0'	
					 ELSE NULL
                END

FROM EVAL_ATT



--MY_INC_2_PERC----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

MY_INC_2_PERC = CASE WHEN convert(float,MY_RAWCHANGE) >= .02 THEN '1' 
					 WHEN convert(float,MY_RAWCHANGE) <  .02 THEN '0'	
					 ELSE NULL
                END

FROM EVAL_ATT



--INC_2_PERC----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

INC_2_PERC = CASE WHEN convert(float,RAWCHANGE) >= .02 THEN '1' 
				  WHEN convert(float,RAWCHANGE) <  .02 THEN '0'	
					 ELSE NULL
                END

FROM EVAL_ATT


--START OFF SLIDING----------------------------------------------------------------------------------------------------------- 

UPDATE EVAL_ATT SET

STARTOFFSLIDING = CASE WHEN convert(float,PRE_VALUE) < .9  THEN 1
					   WHEN convert(float,PRE_VALUE) >= .9 THEN 0
					   ELSE NULL
				  END
FROM EVAL_ATT
WHERE PRE_VALUE IS NOT NULL and POST_VALUE IS NOT NULL




--MY_SOS_MoveOn--------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

 MY_SOS_MoveOn = CASE WHEN STARTOFFSLIDING = 1 AND convert(float,MY_VALUE) >= .9
					  THEN 1
					  WHEN STARTOFFSLIDING = 1 AND convert(float,MY_VALUE) < .9
					  THEN 0
					  ELSE NULL
                 END
FROM EVAL_ATT


--SOS_MoveOn--------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

 SOS_MoveOn = CASE WHEN STARTOFFSLIDING = '1' AND convert(float,POST_VALUE) >= .9
				   THEN '1'
				   WHEN STARTOFFSLIDING = '1' AND convert(float,POST_VALUE) < .9
				   THEN '0'
					  ELSE NULL
                 END
FROM EVAL_ATT



--START_LTE99----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	START_LTE99 = CASE WHEN CONVERT(float,PRE_VALUE) <= .99 THEN '1'
                       WHEN CONVERT(float,PRE_VALUE) >  .99 THEN '0'
					   ELSE NULL
				  END

FROM EVAL_ATT
WHERE PRE_VALUE IS NOT NULL and POST_VALUE IS NOT NULL


--MY_SHOW_1PERC_INC---------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	MY_SHOW_1PERC_INC = CASE WHEN START_LTE99 = '1' AND MY_INC_1_PERC = '1' THEN '1'
							 WHEN START_LTE99 = '1' AND MY_INC_1_PERC = '0' THEN '0'
							 ELSE NULL
						END
FROM EVAL_ATT


--SHOW_1PERC_INC---------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	SHOW_1PERC_INC = CASE WHEN START_LTE99 = '1' AND INC_1_PERC = '1' THEN '1'
						  WHEN START_LTE99 = '1' AND INC_1_PERC = '0' THEN '0'
							 ELSE NULL
						END
FROM EVAL_ATT


--START_LTE98----------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	START_LTE98 = CASE WHEN CONVERT(float,PRE_VALUE) <= .98 THEN '1'
                       WHEN CONVERT(float,PRE_VALUE) >  .98 THEN '0'
					   ELSE NULL
				  END

FROM EVAL_ATT
WHERE PRE_VALUE IS NOT NULL and POST_VALUE IS NOT NULL



--MY_SHOW_2PERC_INC---------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	MY_SHOW_2PERC_INC = CASE WHEN START_LTE98 = '1' AND MY_INC_2_PERC = '1' THEN '1'
							 WHEN START_LTE98 = '1' AND MY_INC_2_PERC = '0' THEN '0'
							 ELSE NULL
						END
FROM EVAL_ATT

--SHOW_2PERC_INC---------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

	SHOW_2PERC_INC = CASE WHEN START_LTE98 = '1' AND INC_2_PERC = '1' THEN '1'
						  WHEN START_LTE98 = '1' AND INC_2_PERC = '0' THEN '0'
							 ELSE NULL
						END
FROM EVAL_ATT

--IA FIELDS-------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

ATTENDANCE_IA = b.Attendance_IA,
ELA_IA        = b.ELA_IA,
Math_IA       = b.MAth_IA,
Behavior_IA   = b.Behavior_IA

FROM EVAL_ATT a INNER JOIN [dbo].[1_RPT_STUDENT_MAIN_WIP] b
						   ON a.CYSCHOOLHOUSE_STUDENT_ID  = b.CYSCHOOLHOUSE_STUDENT_ID
						  AND a.SITE_NAME                 = b.SITE_NAME
					--	  AND a.SCHOOL_NAME               = b.SCHOOL_NAME

 
 

--CURRENTLY_ENROLLED AND ENROLLED_DAYS---------------------------------------------------------------------------------------------------------


/*

UPDATE EVAL_ATT SET

	CURRENTLY_ENROLLED = b.CURRENTLY_ENROLLED,
	ENROLLED_DAYS      = b.ENROLLED_DAYS

FROM EVAL_ATT a INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] b
                ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
               AND a.INDICATOR_DESC           = b.INDICATOR_AREA_DESC
		  	
*/



--SELECT DATEDIFF BETWEEN MIN AND MAX INTERVENTION DATE INTO #BEHAVIOR 
		 SELECT
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC,
		 datediff(dd,MIN(first_intervention), Max(last_intervention)) DAYS_ENROLLED
		 INTO  #Attendance
		 FROM [3_RPT_STUDENT_ENROLLMENT_WIP]
		 WHERE INDICATOR_AREA_DESC = 'Attendance'   
		 group by 
		 CYSCHOOLHOUSE_STUDENT_ID,
		 INDICATOR_AREA_DESC

		--UPDATE EVAL_DESSA_MINI ENROLLED_DAYS FROM #BEHAVIOR TABLE WHERE INDICATOR DESC IS BEHAVIOR-----------------
 
		UPDATE EVAL_ATT SET
		ENROLLED_DAYS      = b.DAYS_ENROLLED
		FROM EVAL_ATT a INNER JOIN #Attendance b
								   ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = b.INDICATOR_AREA_DESC
		WHERE a.INDICATOR_DESC = 'Attendance'
 
		--UPDATE CURRENTLY_ENROLLED WHERE LAST INTERVENTION EQUAlS TODAYS DATE-----------------------------------------

		

--CURRENTLY ENROLLED---------------------------------------------------------------------------------------------------------------


		--SET CURRENTLY_ENROLLED TO BLANK----------------------------------------------------------------------------

			UPDATE EVAL_ATT SET CURRENTLY_ENROLLED = ''

		--UPDATE TO YES WHERE LAST INTERVENTION EQUALS TODAY----------------------------------------------	
		

	
		UPDATE EVAL_ATT SET
		CURRENTLY_ENROLLED =  'YES'
		FROM EVAL_ATT a 
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'Attendance'
		AND c.last_intervention = convert(date,GETDATE()) 

		UPDATE EVAL_ATT SET
		CURRENTLY_ENROLLED =  'NO'
		FROM EVAL_ATT a
								INNER JOIN [3_RPT_STUDENT_ENROLLMENT_WIP] c 
								  ON a.CYSCHOOLHOUSE_STUDENT_ID = c.CYSCHOOLHOUSE_STUDENT_ID
								  AND a.INDICATOR_DESC			 = c.INDICATOR_AREA_DESC
								  
		WHERE a.INDICATOR_DESC = 'Attendance'
		AND c.last_intervention <> convert(date,GETDATE()) 
		AND a.CURRENTLY_ENROLLED <> 'YES'
		

		UPDATE EVAL_ATT SET
		CURRENTLY_ENROLLED = NULL 
		FROM EVAL_ATT a left outer join  [3_RPT_STUDENT_ENROLLMENT_WIP]  b
		ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
		AND a.INDICATOR_DESC  = b.INDICATOR_AREA_DESC
		WHERE b.CYSCHOOLHOUSE_STUDENT_ID IS NULL 
		AND  b.INDICATOR_AREA_DESC IS NULL 
		AND  a.CURRENTLY_ENROLLED NOT IN ('YES','NO')


		
		
		

--MET_56_DAYS------------------------------------------------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

MET_56_DAYS = CASE WHEN ENROLLED_DAYS >= 56 THEN '1'
				   WHEN ENROLLED_DAYS <  56 THEN '0'
				   ELSE NULL
			  END
FROM EVAL_ATT




--GRADE_GROUP-----------------------------------------------------------------------------------------------------------------------------------


UPDATE EVAL_ATT SET

	GRADE_GROUP = CASE WHEN GRADE BETWEEN 3 and 5  THEN 'GRADES 3 - 5'
	                   WHEN GRADE BETWEEN 6 and 9  THEN 'GRADES 6 - 9'
					   WHEN GRADE < 3 OR GRADE > 9 THEN 'GRADES OUTSIDE 3 - 9'
					               
					   ELSE NULL
				  END
FROM EVAL_ATT
WHERE GRADE <> 'K'

UPDATE EVAL_ATT SET

	GRADE_GROUP = CASE WHEN GRADE = 'K' THEN 'GRADES OUTSIDE 3 - 9'
					               
					   ELSE GRADE_GROUP
				  END
FROM EVAL_ATT
WHERE GRADE = 'K'



--GRANTSITENUM AND GRANTCATEGORY-----------------------------------------------------------------------------------------

UPDATE EVAL_ATT SET
	
	GRANTSITENUM   = c.GRANTSITENUM,
	GRANTCATEGORY  = c.GRANTCATEGORY

FROM EVAL_ATT a INNER JOIN SDW_Prod.dbo.DimSchool b  
                           ON a.school_ID = b.schoolID
						   INNER JOIN [dbo].[FY16_Schools_And_ACGrants] c ON b.CYCh_SF_ID =  c.CY_CHANNEL_SF_ID
	
	
--SOYReport , MYReport , EOYReport ------------------------------------------------------------------------------------------



UPDATE EVAL_ATT SET
SOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'       AND Pre_Value IS NOT NULL THEN '1' 
                  WHEN SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE' AND Pre_Value IS NOT NULL THEN '2'
				  ELSE NULL
			END,
MY_Report  = CASE WHEN SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'       AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '1' 
                  WHEN SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE' AND Pre_Value IS NOT NULL AND MY_Value IS NOT NULL THEN '2'
				  ELSE NULL
			END,
EOY_Report = CASE WHEN SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'       AND Pre_Value IS NOT NULL  AND Post_Value IS NOT NULL THEN '1' 
                  WHEN SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE' AND Pre_Value IS NOT NULL  AND Post_Value IS NOT NULL THEN '2'
				  ELSE NULL
END

------New Field: StartOnStayOn. Added 5/18/2016-----------------------------------------------------------------------------------

UPDATE EVAL_ATT SET

STARTONSTAYON = CASE WHEN STARTOFFSLIDING = '0' AND POST_SCALE_NORM = 'On Track' THEN '1'
                     WHEN STARTOFFSLIDING = '0' AND POST_SCALE_NORM in ('Off Track', 'Sliding') THEN '0'
				     WHEN STARTOFFSLIDING <>'0' THEN NULL
				END

--SCALE_CHANGE_NORM_DEGREE

	UPDATE EVAL_ATT SET
	SCALE_CHANGE_NORM_DEGREE = CASE WHEN SCALE_CHANGE_NORM<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_NORM=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_NORM>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_ATT

--SCALE_CHANGE_LOCAL_DEGREE

	UPDATE EVAL_ATT SET
	SCALE_CHANGE_LOCAL_DEGREE = CASE WHEN SCALE_CHANGE_LOCAL<0 
	THEN 'DECREASED' 
	WHEN SCALE_CHANGE_LOCAL=0 
	THEN 'NO CHANGE' 
	WHEN SCALE_CHANGE_LOCAL>0 
	THEN 'INCREASED' 
	ELSE NULL
	END
	FROM EVAL_ATT

END















GO
