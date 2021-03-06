USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_AT]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- HISTORY: 8/24/16 Added -  CASE WHEN b.Grade = 'K' THEN '0' ELSE b.Grade END	AS GRADE to account for K being changed to 0 in the norming tables.
-- =============================================
CREATE     PROCEDURE [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_AT]
AS
BEGIN

truncate  table [dbo].[STAGE_9_RPT_PERFORMANCE_LEVEL_AT]

INSERT INTO [dbo].[STAGE_9_RPT_PERFORMANCE_LEVEL_AT]
SELECT DISTINCT
     		b.CY_StudentID										AS CYSCHOOLHOUSE_STUDENT_ID, 
			b.StudentName										AS STUDENT_NAME, 
			e.Business_Unit										AS SITE_NAME, 
			e.SchoolName										AS SCHOOL_NAME, 
			CASE WHEN b.Grade = 'K' THEN '0' ELSE b.Grade END	AS GRADE,						 
            CASE WHEN e.Diplomas_Now = 'NO' THEN 0 ELSE 1 END	AS DIPLOMAS_NOW_SCHOOL, 
			d.MarkingPeriod										AS INTERVAL,
			''													AS SKILL_ID,
			g.assessmentName   /*h.AssignmentType	*/			AS SKILL_DESCRIPTION, 
			j.DataType											AS DATA_TYPE, 
			j.IndicatorArea    /*i.INDICATOR_AREA_DESC	*/		AS INDICATOR_DESC, 						
			f.Date												AS ASSESSMENT_DATE, 
			''                /*i.PERFORMANCE_VALUE */			AS PERFORMANCE_VALUE,	
			''													AS TARGET_SCORE,
            ''													AS TESTING_GRADE_LEVEL,
			''													AS SCORE_RANK, 
			''													AS SCORE_RANK_NORM, 
        	''													AS SCALE_LOCAL,
			''													AS SCALE_NORM, 
			''													AS SCALE_NUM_LOCAL,
			''													AS SCALE_NUM_NORM, 
			''													AS TAG, 
			''													AS USED_AS_MID_YEAR_DATA_POINT,
			''													AS USED_FOR_SUMMATIVE_REPORTING,
			d.SchoolYear										AS FISCAL_YEAR, 
			e.CYSch_SF_ID										AS CYSCHOOLHOUSE_SCHOOL_ID,
			e.SchoolID											AS SCHOOL_ID,
            ''													AS SITE_ID,
			g.Created_By										AS CREATED_BY, 
			g.Create_Date										AS ENTRY_DATE, 
			GETDATE()											AS LAST_REFRESH
			--g.assessmentID                                      AS ASSESSMENTID



FROM         SDW_PROD.dbo.FactAll AS a INNER JOIN
                      SDW_PROD.dbo.DimStudent		AS b ON a.StudentID			= b.StudentID		INNER JOIN
                      SDW_PROD.dbo.DimIndicatorArea	AS c ON a.IndicatorAreaID	= c.IndicatorAreaID INNER JOIN
                      SDW_PROD.dbo.DimGrade			AS d ON a.GradeID			= d.GradeID			INNER JOIN
                     SDW_PROD.dbo.DimSchool			AS e ON a.SchoolID			= e.SchoolID		INNER JOIN
                      SDW_PROD.dbo.DimDate			AS f ON a.DateID			= f.DateID			INNER JOIN
                      SDW_PROD.dbo.DimAssessment		AS g ON a.AssessmentID		= g.AssessmentID	INNER JOIN
                      SDW_PROD.dbo.DimAssignment		AS h ON a.AssignmentID		= h.AssignmentID	LEFT OUTER JOIN  
			--		  ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]  AS i ON a.STUDENTID	= i.STUDENT_ID
			--												   AND  f.Date				= i.ASSESSMENT_DATE
			--													   AND  g.assessmentName	= i.skill_desc
			--																					LEFT OUTER JOIN
					  SDW_PROD.dbo.Dimpreandposttag AS j ON a.studentID		 = j.StudentID
													AND g.Data_Type_display = j.DATATYPE
											  --     AND g.assessmentName		 = j.GradeType
											--	   AND i.INDICATOR_AREA_DESC = j.IndicatorArea
	
	
where g.assessmentName IN ('Cumulative ADA Tracker - ATTENDANCE','Reporting Period ADA Tracker - ATTENDANCE')

/*

SELECT 
CYSCHOOLHOUSE_STUDENT_ID, 
STUDENT_NAME, 
SITE_NAME, 
SCHOOL_NAME, 
GRADE,						 
DIPLOMAS_NOW_SCHOOL, 
INTERVAL,
SKILL_ID,
SKILL_DESCRIPTION, 
DATA_TYPE, 
INDICATOR_DESC, 						
ASSESSMENT_DATE, 
PERFORMANCE_VALUE,	
TARGET_SCORE,
TESTING_GRADE_LEVEL,
SCORE_RANK, 
SCORE_RANK_NORM, 
SCALE_LOCAL,
SCALE_NORM, 
SCALE_NUM_LOCAL,
SCALE_NUM_NORM, 
TAG, 
USED_AS_MID_YEAR_DATA_POINT,
USED_FOR_SUMMATIVE_REPORTING,
FISCAL_YEAR, 
CYSCHOOLHOUSE_SCHOOL_ID,
SCHOOL_ID,
SITE_ID,
CREATED_BY, 
min(ENTRY_DATE) Entry_date, 
LAST_REFRESH 



INTO #STAGE_AT 
FROM #STAGE 
GROUP BY 
CYSCHOOLHOUSE_STUDENT_ID, 
STUDENT_NAME, 
SITE_NAME, 
SCHOOL_NAME, 
GRADE,						 
DIPLOMAS_NOW_SCHOOL, 
INTERVAL,
SKILL_ID,
SKILL_DESCRIPTION, 
DATA_TYPE, 
INDICATOR_DESC, 						
ASSESSMENT_DATE, 
PERFORMANCE_VALUE,	
TARGET_SCORE,
TESTING_GRADE_LEVEL,
SCORE_RANK, 
SCORE_RANK_NORM, 
SCALE_LOCAL,
SCALE_NORM, 
SCALE_NUM_LOCAL,
SCALE_NUM_NORM, 
TAG, 
USED_AS_MID_YEAR_DATA_POINT,
USED_FOR_SUMMATIVE_REPORTING,
FISCAL_YEAR, 
CYSCHOOLHOUSE_SCHOOL_ID,
SCHOOL_ID,
SITE_ID,
CREATED_BY, 
--ENTRY_DATE, 
LAST_REFRESH 


select * from #STAGE where cyschoolhouse_student_ID = 'CY-99664'
select * from SDW_PROD.dbo.Dimpreandposttag where cyschoolhouse_ID = 'CY-99664'

--REMOVE DUPS FROM STAGE THAT ARE CAUSED BY SPLIT SCHOOL ID's-----------------------------------------------------------------


--IDENTIFY DUPS ------------------------------------------------------------------------------------------------------------
SELECT 
CYSCHOOLHOUSE_STUDENT_ID,STUDENT_NAME,SITE_NAME,SCHOOL_NAME,GRADE,DIPLOMAS_NOW_SCHOOL,INTERVAL,SKILL_ID,SKILL_DESCRIPTION,DATA_TYPE
INDICATOR_DESC,ASSESSMENT_DATE,PERFORMANCE_VALUE,TARGET_SCORE,TESTING_GRADE_LEVEL,SCORE_RANK,SCORE_RANK_NORM,SCALE_LOCAL,SCALE_NORM
SCALE_NUM_LOCAL,SCALE_NUM_NORM,TAG,USED_AS_MID_YEAR_DATA_POINT,USED_FOR_SUMMATIVE_REPORTING,FISCAL_YEAR,CYSCHOOLHOUSE_SCHOOL_ID,
/*SCHOOL_ID,*/SITE_ID,CREATED_BY,ENTRY_DATE,LAST_REFRESH,count(*) AS count

INTO #DUPS 

FROM #STAGE_AT   --[dbo].[STAGE_9_RPT_PERFORMANCE_LEVEL_AT]

GROUP BY 
CYSCHOOLHOUSE_STUDENT_ID,STUDENT_NAME,SITE_NAME,SCHOOL_NAME,GRADE,DIPLOMAS_NOW_SCHOOL,INTERVAL,SKILL_ID,SKILL_DESCRIPTION,DATA_TYPE,
INDICATOR_DESC,ASSESSMENT_DATE,PERFORMANCE_VALUE,TARGET_SCORE,TESTING_GRADE_LEVEL,SCORE_RANK,SCORE_RANK_NORM,SCALE_LOCAL,SCALE_NORM,
SCALE_NUM_LOCAL,SCALE_NUM_NORM,TAG,USED_AS_MID_YEAR_DATA_POINT,USED_FOR_SUMMATIVE_REPORTING,FISCAL_YEAR,CYSCHOOLHOUSE_SCHOOL_ID,
/*SCHOOL_ID,*/SITE_ID,CREATED_BY,ENTRY_DATE,LAST_REFRESH

HAVING count(*) > 1





--SELECT DISTINCT RECORDS OF DUPS:NOT INCLUDING SCHOOL_ID WHICH IS DIFFERENT ON THESE DUPS --------------------------
SELECT DISTINCT
 a.CYSCHOOLHOUSE_STUDENT_ID,a.STUDENT_NAME,a.SITE_NAME,a.SCHOOL_NAME,a.GRADE,a.DIPLOMAS_NOW_SCHOOL,a.INTERVAL,a.SKILL_ID,a.SKILL_DESCRIPTION,a.DATA_TYPE,
a.INDICATOR_DESC,a.ASSESSMENT_DATE,a.PERFORMANCE_VALUE,a.TARGET_SCORE,a.TESTING_GRADE_LEVEL,a.SCORE_RANK,a.SCORE_RANK_NORM,a.SCALE_LOCAL,a.SCALE_NORM,
a.SCALE_NUM_LOCAL,a.SCALE_NUM_NORM,a.TAG,a.USED_AS_MID_YEAR_DATA_POINT,a.USED_FOR_SUMMATIVE_REPORTING,a.FISCAL_YEAR,a.CYSCHOOLHOUSE_SCHOOL_ID,
/*SCHOOL_ID,*/a.SITE_ID,a.CREATED_BY,a.ENTRY_DATE,a.LAST_REFRESH

INTO #FIX_DUPS  

FROM #STAGE_AT a inner join #DUPS b ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID 
                                          AND a.ASSESSMENT_DATE          = b.ASSESSMENT_DATE
										  AND a.ENTRY_DATE				 = b.ENTRY_DATE

order by a.CYSCHOOLHOUSE_SCHOOL_ID




--DELETE ALL DUPS FROM #PRE_STAGE_TABLE------------------------------------------------------------------------------------------------------

	DELETE #STAGE_AT  FROM #STAGE_AT  a 
												 inner join #DUPS b 
												 ON a.CYSCHOOLHOUSE_STUDENT_ID   = b.CYSCHOOLHOUSE_STUDENT_ID
												 AND a.ASSESSMENT_DATE			 = b.ASSESSMENT_DATE
												 AND a.ENTRY_DATE				 = b.ENTRY_DATE


--INSERT DISTINCT RECORDS INTO #PRE_STAGE_TABLE-----------------------------------------------------------------------------------------------

INSERT INTO #STAGE_AT
(CYSCHOOLHOUSE_STUDENT_ID,STUDENT_NAME,SITE_NAME,SCHOOL_NAME,GRADE,DIPLOMAS_NOW_SCHOOL,INTERVAL,SKILL_ID,SKILL_DESCRIPTION,DATA_TYPE,
INDICATOR_DESC,ASSESSMENT_DATE,PERFORMANCE_VALUE,TARGET_SCORE,TESTING_GRADE_LEVEL,SCORE_RANK,SCORE_RANK_NORM,SCALE_LOCAL,SCALE_NORM,
SCALE_NUM_LOCAL,SCALE_NUM_NORM,TAG,USED_AS_MID_YEAR_DATA_POINT,USED_FOR_SUMMATIVE_REPORTING,FISCAL_YEAR,CYSCHOOLHOUSE_SCHOOL_ID,
SCHOOL_ID,SITE_ID,CREATED_BY,ENTRY_DATE,LAST_REFRESH)

SELECT 
 CYSCHOOLHOUSE_STUDENT_ID,STUDENT_NAME,SITE_NAME,SCHOOL_NAME,GRADE,DIPLOMAS_NOW_SCHOOL,INTERVAL,SKILL_ID,SKILL_DESCRIPTION,DATA_TYPE,
INDICATOR_DESC,ASSESSMENT_DATE,PERFORMANCE_VALUE,TARGET_SCORE,TESTING_GRADE_LEVEL,SCORE_RANK,SCORE_RANK_NORM,SCALE_LOCAL,SCALE_NORM,
SCALE_NUM_LOCAL,SCALE_NUM_NORM,TAG,USED_AS_MID_YEAR_DATA_POINT,USED_FOR_SUMMATIVE_REPORTING,FISCAL_YEAR,CYSCHOOLHOUSE_SCHOOL_ID,
'', SITE_ID,CREATED_BY,ENTRY_DATE,LAST_REFRESH

FROM #FIX_DUPS


INSERT INTO [STAGE_9_RPT_PERFORMANCE_LEVEL_AT]
SELECT * FROM #STAGE_AT

*/





-----UPDATE SPLIT SCHOOL NAME TO REMOVE '%(%-%)%'  -------------------------------------------------------------------------------------------------------------------------------
--ADDED 7-1-2016

UPDATE [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] SET
SCHOOL_NAME =  LEFT(school_name, CHARINDEX('(',school_name)-1)
where school_name like '%(%-%)%'




-------------------------------------------------------------------------------------------------------------------------------
--UPDATE INDICATOR_DESC AND DATA_TYPE
-------------------------------------------------------------------------------------------------------------------------------

UPDATE  [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] SET
INDICATOR_DESC =  b.IndicatorArea,
Data_Type      =  b.dataType
from [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] AS a INNER JOIN SDW_PROD.dbo.Dimpreandposttag b
                                        ON a.SKILL_DESCRIPTION = b.GradeType

	 
-------------------------------------------------------------------------------------------------------------------------------
--UPDATE PERFORMANCE_VALUE
-------------------------------------------------------------------------------------------------------------------------------

UPDATE  [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] SET
PERFORMANCE_VALUE =  i.performance_value,
DATA_TYPE         =  i.Data_Type--,
--INDICATOR_DESC    =  i.Indicator_Area_Desc 
from [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] AS a INNER JOIN
ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]  AS i	ON   a.CYSCHOOLHOUSE_STUDENT_ID = i.CYSCHOOLHOUSE_STUDENT_ID
														AND  a.assessment_date	= i.ASSESSMENT_DATE
														AND  a.skill_description = i.skill_desc

DELETE  FROM [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] WHERE PERFORMANCE_VALUE IS NULL or performance_value = ''


-------------------------------------------------------------------------------------------------------------------------------
--REMOVE DUPLICATES 
-------------------------------------------------------------------------------------------------------------------------------


		SELECT 
			CYSCHOOLHOUSE_STUDENT_ID, 
			SKILL_DESCRIPTION, 
			DATA_TYPE, 
			ASSESSMENT_DATE
			INTO  #PRE_STAGE_TABLE_DUPES
			FROM  STAGE_9_RPT_PERFORMANCE_LEVEL_AT 
			GROUP BY CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, DATA_TYPE,ASSESSMENT_DATE
			HAVING COUNT(*) > 1

			DELETE STAGE_9_RPT_PERFORMANCE_LEVEL_AT
			FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT (nolock) a
			INNER JOIN #PRE_STAGE_TABLE_DUPES (nolock) b ON
			a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
			AND a.SKILL_DESCRIPTION = b.SKILL_DESCRIPTION
			AND a.DATA_TYPE = b.DATA_TYPE
			AND CAST(a.ASSESSMENT_DATE as date) = CAST(b.ASSESSMENT_DATE as date)






-------------------------------------------------------------------------------------------------------------------------------
--UPDATE INTERVAL
-------------------------------------------------------------------------------------------------------------------------------

UPDATE [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] SET
INTERVAL =  b.Quarter
FROM [STAGE_9_RPT_PERFORMANCE_LEVEL_AT] AS a INNER JOIN  SDW_PROD.dbo.DimSchoolSetup b
											ON a.SCHOOL_ID = b.SCHOOLID
WHERE a.ASSESSMENT_DATE between b.Start_Date and b.End_Date


-----------------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Cumulative ADA Tracker - ATTENDANCE'  SKILL_DESCRIPTION
-----------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE' AND a.PrYr_MostRecent_Value is not NULL 
																			AND a.Final_MPLatest_Value is not NULL
														--  AND a.PrYr_MostRecent_Value <> ISNULL(a.MY_Proxy_Value,'')
															THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date
								AND a.Gradetype       =  'Cumulative ADA Tracker - ATTENDANCE'
WHERE  TAG = ''





-- b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID 
--												  FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT b	
--												  WHERE TAG = 'Pre' AND b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE')
							


--select * from STAGE_9_RPT_PERFORMANCE_LEVEL_AT where CYSCHOOLHOUSE_STUDENT_ID = 'CY-14039' and  SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'

--select * from SDW_PROD.dbo.Dimpreandposttag where CYSCHOOLHOUSE_ID = 'CY-14039' and  gradeType = 'Cumulative ADA Tracker - ATTENDANCE'
-------


-------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'Cumulative ADA Tracker - ATTENDANCE' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE' AND a.PrYr_MostRecent_Value is not NULL 
																			AND a.Final_MPLatest_Value is not NULL 
																		--  AND a.PrYr_MostRecent_Value <> ISNULL(a.MY_Proxy_Value,'')
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID    = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								AND a.GradeType           = 'Cumulative ADA Tracker - ATTENDANCE'
WHERE TAG = '' 

	

								
--								b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID 
--												  FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT b	
--												  WHERE TAG = 'Post' AND b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE')
  
-------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Reporting Period ADA' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------


---1-----------------------------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
															 	AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date 
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')
										



--2------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.IntStartEnroll_Earliest_Proxy_Value is not NULL 
																AND a.Final_MPLatest_Value				  is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.Final_MPLatest_Date 
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')



---3-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.First_MPEarliest_Value		is not Null
												 				AND a.IntEndExit_Latest_Proxy_Value is not Null
															 	AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')


--4-----------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date 
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')




-------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'Reporting Period ADA Tracker - ATTENDANCE' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

---1-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null 
															 	AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')



--2------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.IntStartEnroll_Earliest_Proxy_Value is not NULL 
																AND a.Final_MPLatest_Value				  is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.Final_MPLatest_Date 
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')




---3-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.First_MPEarliest_Value		is not Null
												 				AND a.IntEndExit_Latest_Proxy_Value is not Null
																AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')



--4-----------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'	
																AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date 
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')



---------------------------------------------------------------------------------------------------------------------
--IF ABOVE SCENARIOS ALL HAD PRE VALUE = MY_PROXY_VALUE OR POST VALUE OF NULL THEN UPDATE PRE USING FIRST AVAILABLE 
--PRE VALUE STARTING WITH SCENARIO 1 UNTIL A VALUE IS FOUND. ALSO SET MY_PROXY_VALUE AND POST TO NULL.
---------------------------------------------------------------------------------------------------------------------


--Cumulative ADA Tracker - ATTENDANCE
--1 PrYr_MostRecent_Date------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Cumulative ADA Tracker - ATTENDANCE')








/*
--2 First_MPEarliest_Date-------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Cumulative ADA Tracker - ATTENDANCE')

--3 IntStartEnroll_Earliest_Proxy_Date-----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative ADA Tracker - ATTENDANCE'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Cumulative ADA Tracker - ATTENDANCE')


*/




--Reporting Period ADA Tracker - ATTENDANCE


/*

NEVER USED FOR Reporting Period ADA Tracker - ATTENDANCE

--1 PrYr_MostRecent_Date------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')

*/


--2 First_MPEarliest_Date-------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')

--3 IntStartEnroll_Earliest_Proxy_Date-----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period ADA Tracker - ATTENDANCE'
AND TAG = ''
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period ADA Tracker - ATTENDANCE')



-----------------------------------------------------------------------------------------------------------------
-- UPDATE "USED_AS_MID_YEAR_POINT"
-----------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 	
USED_AS_MID_YEAR_DATA_POINT  = CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_PROD.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.GradeType           = 'Reporting Period ADA Tracker - ATTENDANCE'


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET 	
USED_AS_MID_YEAR_DATA_POINT  = CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_PROD.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.GradeType           = 'Cumulative ADA Tracker - ATTENDANCE'

-----------------------------------------------------------------------------------------------------------------
--SCALE LOCAL
-----------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
SCALE_LOCAL = b.[SCALE_LOCAL],
SCALE_NUM_LOCAL =   b.[SCALE_NUM_LOCAL]
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= convert(varchar(250),b.grade) --b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description
					AND a.data_type         = b.Data_Type

--WHERE a.Performance_Value Between convert(varchar(250),b.[PERFORMANCE_VALUE_DISPLAY_MIN]) and convert(varchar(250),b.[PERFORMANCE_VALUE_DISPLAY_MAX])

WHERE convert(float,a.Performance_Value) Between b.[PERFORMANCE_VALUE_DISPLAY_MIN] and b.[PERFORMANCE_VALUE_DISPLAY_MAX]
AND   convert(datetime,a.ASSESSMENT_DATE) BETWEEN DATE_RANGE_MIN and DATE_RANGE_MAX
and isnumeric(a.performance_value) = '1'  





-----------------------------------------------------------------------------------------------------------------
--SCALE_NORM
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
SCALE_NORM		=  b.[SCALE_NORM],
SCALE_NUM_NORM =   b.[SCALE_NUM_NORM]
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= convert(varchar(250),b.grade) --b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description
					AND a.data_type         = b.Data_Type

--WHERE a.Performance_Value Between convert(varchar(250),b.[PERFORMANCE_VALUE_DISPLAY_MIN]) and convert(varchar(250),b.[PERFORMANCE_VALUE_DISPLAY_MAX])

WHERE convert(float,a.Performance_Value) Between b.[PERFORMANCE_VALUE_DISPLAY_MIN] and b.[PERFORMANCE_VALUE_DISPLAY_MAX]
AND   convert(datetime,a.ASSESSMENT_DATE) BETWEEN DATE_RANGE_MIN and DATE_RANGE_MAX
and isnumeric(a.performance_value) = '1'  

-----------------------------------------------------------------------------------------------------------------
-- USED_FOR_SUMMATIVE_REPORTING
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
USED_FOR_SUMMATIVE_REPORTING		=   b.USED_FOR_SUMMATIVE_REPORTING

FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= convert(varchar(250),b.grade) --b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description
					AND a.DATA_TYPE         = b.DATA_TYPE

WHERE a.Performance_Value Between b.[PERFORMANCE_VALUE_DISPLAY_MIN] and b.[PERFORMANCE_VALUE_DISPLAY_MAX]



-----------------------------------------------------------------------------------------------------------------
--TRUNCATE AND INSERT TO TABLE 9_RPT_PERFORMANCE_LEVEL_AT
-----------------------------------------------------------------------------------------------------------------
	
	TRUNCATE TABLE [9_RPT_PERFORMANCE_LEVEL_AT] 

	INSERT INTO [9_RPT_PERFORMANCE_LEVEL_AT]
	SELECT * FROM STAGE_9_RPT_PERFORMANCE_LEVEL_AT 


END



















GO
