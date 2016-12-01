USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_SB]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_SB]
AS
BEGIN

INSERT INTO [dbo].[STAGE_9_RPT_PERFORMANCE_LEVEL_SB]
SELECT
     		b.CY_StudentID										AS CYSCHOOLHOUSE_STUDENT_ID, 
			b.StudentName										AS STUDENT_NAME, 
			e.Business_Unit										AS SITE_NAME, 
			e.SchoolName										AS SCHOOL_NAME, 
			b.Grade												AS GRADE,						 
            CASE WHEN e.Diplomas_Now = 'NO' THEN 0 ELSE 1 END	AS DIPLOMAS_NOW_SCHOOL, 
			d.MarkingPeriod										AS INTERVAL,
			''													AS SKILL_ID,
			h.AssignmentType									AS SKILL_DESCRIPTION, 
			j.DataType											AS DATA_TYPE, 
			i.INDICATOR_AREA_DESC								AS INDICATOR_DESC, 						
			f.Date												AS ASSESSMENT_DATE, 
			i.PERFORMANCE_VALUE									AS PERFORMANCE_VALUE,	
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
			GETDATE()											AS LAST_REFRESH,
			''
	
FROM         SDW_Prod.dbo.FactAll AS a INNER JOIN
                      SDW_Prod.dbo.DimStudent		AS b ON a.StudentID			= b.StudentID		INNER JOIN
                      SDW_Prod.dbo.DimIndicatorArea	AS c ON a.IndicatorAreaID	= c.IndicatorAreaID INNER JOIN
                      SDW_Prod.dbo.DimGrade			AS d ON a.GradeID			= d.GradeID			INNER JOIN
                      SDW_Prod.dbo.DimSchool		AS e ON a.SchoolID			= e.SchoolID		INNER JOIN
                      SDW_Prod.dbo.DimDate			AS f ON a.DateID			= f.DateID			INNER JOIN
                      SDW_Prod.dbo.DimAssessment	AS g ON a.AssessmentID		= g.AssessmentID	INNER JOIN
                      SDW_Prod.dbo.DimAssignment	AS h ON a.AssignmentID		= h.AssignmentID	LEFT OUTER JOIN  
					  ReportCYData_Prod.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]  AS i ON a.STUDENTID	= i.STUDENT_ID
																   AND  f.Date				= i.ASSESSMENT_DATE
																   AND  h.AssignmentType	= i.skill_desc
																								LEFT OUTER JOIN
 					  SDW_Prod.dbo.Dimpreandposttag AS j ON a.studentID			 = j.StudentID
											       AND h.AssignmentType		 = j.GradeType
												   AND i.INDICATOR_AREA_DESC = j.IndicatorArea
														 	
WHERE  h.AssignmentType IN ('Cumulative Course Grade','Reporting Period Course Grade')

--FILTER WHERE DATA TYPE = "STANDARDS"----------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Year to date ADA' SKILL_DESCRIPTION
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative Course Grade' AND a.PrYr_MostRecent_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														-- AND a.PrYr_MostRecent_Value <> ISNULL(a.MY_Proxy_Value,'')
														 THEN 'Pre' ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date
								AND a.Gradetype       =  'Cumulative Course Grade'

-------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'Year to date ADA' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative Course Grade' AND a.PrYr_MostRecent_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL 
														--  AND a.PrYr_MostRecent_Value <> ISNULL(a.MY_Proxy_Value,'')
														 THEN 'Post' ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID    = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								AND a.GradeType           = 'Cumulative Course Grade'

-------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Reporting Period Course Grade' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

---1-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
															-- 	AND a.First_MPEarliest_Value <> ISNULL(a.MY_Proxy_Value,'') 
																THEN 'Pre'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade')

--2------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
												 				AND a.Final_MPLatest_Value is not Null
																-- AND a.IntStartEnroll_Earliest_Proxy_Value <> ISNULL(a.MY_Proxy_Value,'')
																THEN 'Pre'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Value = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade')

---3-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.IntEndExit_Latest_Proxy_Value				  is not Null
															-- 	AND a.First_MPEarliest_Value <> ISNULL(a.MY_Proxy_Value,'') 
																THEN 'Pre'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade')

--4-----------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															-- 	AND a.IntStartEnroll_Earliest_Proxy_Value <> ISNULL(a.MY_Proxy_Value,'')
																THEN 'Pre'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade')




-------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'Reporting Period Course Grade' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

---1-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
																-- AND a.First_MPEarliest_Value <> ISNULL(a.MY_Proxy_Value,'') 
																THEN 'Post'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade')


--2------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
												 				AND a.Final_MPLatest_Value is not Null
																-- AND a.IntStartEnroll_Earliest_Proxy_Value <> ISNULL(a.MY_Proxy_Value,'')
																THEN 'Post'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade')

---3-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.IntEndExit_Latest_Proxy_Value	 is not Null
																-- AND a.First_MPEarliest_Value <> ISNULL(a.MY_Proxy_Value,'') 
																THEN 'Post'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade')

--4-----------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
																-- AND a.IntStartEnroll_Earliest_Proxy_Value <> ISNULL(a.MY_Proxy_Value,'')
																THEN 'Post'
																ELSE '' END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade')


---------------------------------------------------------------------------------------------------------------------
--IF ABOVE SCENARIOS ALL HAD PRE VALUE = MY_PROXY_VALUE OR POST VALUE OF NULL THEN UPDATE PRE USING FIRST AVAILABLE 
--PRE VALUE STARTING WITH SCENARIO 1 UNTIL A VALUE IS FOUND. ALSO SET MY_PROXY_VALUE AND POST TO NULL.
---------------------------------------------------------------------------------------------------------------------


--CUMULATIVE COURSE GRADE
--1 PrYr_MostRecent_Date------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT DISTINCT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre')



--2 First_MPEarliest_Date-------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT DISTINCT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre')

--3 IntStartEnroll_Earliest_Proxy_Date-----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT DISTINCT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_SB b where TAG = 'Pre')



--REPORTING PERIOD COURSE GRADE

--1 PrYr_MostRecent_Date------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre')


--2 First_MPEarliest_Date-------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre')

--3 IntStartEnroll_Earliest_Proxy_Date-----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_AT SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_Prod.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_AT b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre')


-------------------------------------------------------------------------------------------------------------------------------
--UPDATE INTERVAL
-------------------------------------------------------------------------------------------------------------------------------

UPDATE [STAGE_9_RPT_PERFORMANCE_LEVEL_SB] SET
INTERVAL =  b.Quarter
FROM [STAGE_9_RPT_PERFORMANCE_LEVEL_SB] AS a INNER JOIN  SDW_Prod.dbo.DimSchoolSetup b
											ON a.SCHOOL_ID = b.SCHOOLID
WHERE a.ASSESSMENT_DATE between b.Start_Date and b.End_Date

-----------------------------------------------------------------------------------------------------------------
--SCALE LOCAL AND SCALE_NUM_LOCAL
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
SCALE_LOCAL =  b.[SCALE_LOCAL],
SCALE_NUM_LOCAL =  b.[SCALE_NUM_LOCAL]
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_SB a inner join ReportCYData_Prod.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE a.Performance_Value = b.[PERFORMANCE_VALUE_DISPLAY]

-----------------------------------------------------------------------------------------------------------------
--SCALE_NORM AND SCALE_NUM_NORM
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
SCALE_NORM		=  b.[SCALE_NORM],
SCALE_NUM_NORM =   b.[SCALE_NUM_NORM] 
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_SB a inner join ReportCYData_Prod.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE a.Performance_Value = b.[PERFORMANCE_VALUE_DISPLAY]
AND   a.assessment_date between b.Date_Range_min and b.Date_range_max

-----------------------------------------------------------------------------------------------------------------
--UPDATE SCORE_RANK AND SCORE_RANK_NORM
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
SCORE_RANK		=   b.SCORE_RANK,
SCORE_RANK_NORM =   b.SCORE_RANK_NORM 
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_SB a inner join ReportCYData_Prod.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE a.Performance_Value = b.[PERFORMANCE_VALUE_DISPLAY]


-----------------------------------------------------------------------------------------------------------------
-- USED_FOR_SUMMATIVE_REPORTING
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET  
USED_FOR_SUMMATIVE_REPORTING		=   b.USED_FOR_SUMMATIVE_REPORTING

FROM STAGE_9_RPT_PERFORMANCE_LEVEL_SB a inner join ReportCYData_Prod.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

-----------------------------------------------------------------------------------------------------------------
-- UPDATE "USED_AS_MID_YEAR_POINT"
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_SB SET 	
USED_AS_MID_YEAR_DATA_POINT  =  CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_Prod.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_SB b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								--AND a.DataType			  = b.DATA_TYPE


----------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------
--TRUNCATE AND INSERT TO TABLE 9_RPT_PERFORMANCE_LEVEL_SB
-----------------------------------------------------------------------------------------------------------------
	
	TRUNCATE TABLE [9_RPT_PERFORMANCE_LEVEL_SB]

	INSERT INTO [9_RPT_PERFORMANCE_LEVEL_SB]
	SELECT 
		CYSCHOOLHOUSE_STUDENT_ID
		,STUDENT_NAME
		,SITE_NAME
		,SCHOOL_NAME
		,GRADE
		,DIPLOMAS_NOW_SCHOOL
		,INTERVAL
		,SKILL_ID
		,SKILL_DESCRIPTION
		,DATA_TYPE
		,INDICATOR_DESC
		,ASSESSMENT_DATE
		,PERFORMANCE_VALUE
		,TARGET_SCORE
		,TESTING_GRADE_LEVEL
		,SCORE_RANK
		,SCORE_RANK_NORM
		,SCALE_LOCAL
		,SCALE_NORM
		,SCALE_NUM_LOCAL
		,SCALE_NUM_NORM
		,TAG
		,USED_AS_MID_YEAR_DATA_POINT
		,USED_FOR_SUMMATIVE_REPORTING
		,FISCAL_YEAR
		,CYSCHOOLHOUSE_SCHOOL_ID
		,SCHOOL_ID
		,SITE_ID
		,CREATED_BY
		,ENTRY_DATE
		,LAST_REFRESH 

	FROM STAGE_9_RPT_PERFORMANCE_LEVEL_SB
	
	
END






GO
