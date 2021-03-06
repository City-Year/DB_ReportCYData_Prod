USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_CG]    Script Date: 12/1/2016 9:27:20 AM ******/
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
CREATE    PROCEDURE [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_CG]
AS
BEGIN

truncate  TABLE [STAGE_9_RPT_PERFORMANCE_LEVEL_CG]

--INSERT INTO [dbo].[STAGE_9_RPT_PERFORMANCE_LEVEL_CG]
SELECT DISTINCT
     		b.CY_StudentID										AS CYSCHOOLHOUSE_STUDENT_ID, 
			b.StudentName										AS STUDENT_NAME, 
			e.Business_Unit										AS SITE_NAME, 
			e.SchoolName										AS SCHOOL_NAME, 
			CASE WHEN b.Grade = 'K' THEN '0' ELSE b.Grade END	AS GRADE,						 
            CASE WHEN e.Diplomas_Now = 'NO' THEN 0 ELSE 1 END	AS DIPLOMAS_NOW_SCHOOL, 
			''													AS INTERVAL,      --d.MarkingPeriod	
			''													AS SKILL_ID,
			h.AssignmentType									AS SKILL_DESCRIPTION, 
			''													AS DATA_TYPE,     --j.DataType
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
			i.Created_By										AS CREATED_BY, 
			i.Entry_Date										AS ENTRY_DATE, 
			GETDATE()											AS LAST_REFRESH,
			a.AssessmentID
	
INTO  #PRE_STAGE_TABLE

FROM         SDW_PROD.dbo.FactAll AS a INNER JOIN
                      SDW_PROD.dbo.DimStudent		AS b ON a.StudentID			= b.StudentID		INNER JOIN
                      SDW_PROD.dbo.DimIndicatorArea	AS c ON a.IndicatorAreaID	= c.IndicatorAreaID INNER JOIN
                      SDW_PROD.dbo.DimGrade			AS d ON a.GradeID			= d.GradeID			INNER JOIN
                      SDW_PROD.dbo.DimSchool		AS e ON a.SchoolID			= e.SchoolID		INNER JOIN
                      SDW_PROD.dbo.DimDate			AS f ON a.DateID			= f.DateID			INNER JOIN
                      SDW_PROD.dbo.DimAssessment	AS g ON a.AssessmentID		= g.AssessmentID	INNER JOIN
                      SDW_PROD.dbo.DimAssignment	AS h ON a.AssignmentID		= h.AssignmentID	LEFT OUTER JOIN  
					  ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]  AS i ON a.STUDENTID	= i.STUDENT_ID
																   AND  f.Date				= i.ASSESSMENT_DATE
																   AND  h.AssignmentType	= i.skill_desc
																								--	LEFT OUTER JOIN
				--	  SDW_PROD.dbo.Dimpreandposttag AS j ON a.studentID		 = j.StudentID
				--							       AND h.AssignmentType		 = j.GradeType
				--								   AND i.INDICATOR_AREA_DESC = j.IndicatorArea
														 	
WHERE  h.AssignmentType IN ('Cumulative Course Grade','Reporting Period Course Grade') 


-----------------------------------------------------------------------------------------------------------------
--DELETE ROWS WITH NULL PERFORMANCE VALUE
-----------------------------------------------------------------------------------------------------------------

			DELETE FROM #PRE_STAGE_TABLE  WHERE PERFORMANCE_VALUE IS NULL

			
---------------------------------------------------------------------------------------------------------------------------------------
--REMOVING ALL RECORDS THAT OCCURR MORE THAN ONCE WITH THE SAME CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION,DATA_TYPE,ASSESSMENT_DATE
--THESE DUPS ARE GENERALLY BAD DATA ENTRY INTO SCHOOLHOUSE OR POSSIBLE BAD DISTRICT DATA AND WILL NEED TO BE FIXED BY THE SITE OR BY
--THE DISTRICT.   
---------------------------------------------------------------------------------------------------------------------------------------

			SELECT 
			CYSCHOOLHOUSE_STUDENT_ID, 
			SKILL_DESCRIPTION, 
			INDICATOR_DESC, 
			ASSESSMENT_DATE
			INTO #PRE_STAGE_TABLE_DUPS
			FROM #PRE_STAGE_TABLE 
			GROUP BY CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, INDICATOR_DESC,ASSESSMENT_DATE
			HAVING COUNT(*) > 1



			DELETE #PRE_STAGE_TABLE 
			FROM #PRE_STAGE_TABLE (nolock) a
			INNER JOIN #PRE_STAGE_TABLE_DUPS (nolock) b ON
			a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
			AND a.SKILL_DESCRIPTION = b.SKILL_DESCRIPTION
			AND a.INDICATOR_DESC = b.INDICATOR_DESC
			AND CAST(a.ASSESSMENT_DATE as date) = CAST(b.ASSESSMENT_DATE as date)


			INSERT INTO [STAGE_9_RPT_PERFORMANCE_LEVEL_CG] SELECT * FROM #PRE_STAGE_TABLE
 
-----UPDATE SPLIT SCHOOL NAME TO REMOVE '%(%-%)%'  -------------------------------------------------------------------------------------------------------------------------------
--ADDED 7-1-2016

UPDATE [STAGE_9_RPT_PERFORMANCE_LEVEL_CG] SET
SCHOOL_NAME =  LEFT(school_name, CHARINDEX('(',school_name)-1)
where school_name like '%(%-%)%'



-----------------------------------------------------------------------------------------------------------------------------------------------


/*  TABLE 5 ISSUE
select a.CYSCHOOLHOUSE_STUDENT_ID,b.CYSCHOOLHOUSE_STUDENT_ID,a.skill_description,b.skill_description,a.indicator_desc,b.indicator_desc 
 from #table a inner join #table2 b on a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
											and a.skill_description = b.skill_description
											and a.indicator_desc <> b.indicator_desc 


select * from #table_from_table_5 where indicator_desc = 'Attendance' CYSCHOOLHOUSE_STUDENT_ID = 'CY-08219'
select * from #table_from_DimIndicatorArea where indicator_desc = 'Attendance' CYSCHOOLHOUSE_STUDENT_ID = 'CY-08219'

select * from SDW_PROD.dbo.DimIndicatorArea where IndicatorAreaID IN ('10013','10014') = 'ELA'



select * from ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE] where indicator_area_desc like '%att%' and skill_desc not like '%ATT%'  
select * from ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE] where  skill_desc  like '%ATT%' -- all attendance skill_desc have NULL indicator area 106207 rows
select * from ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE] where indicator_area_desc IS NULL -- 106207 rows
select * from ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE] where skill_desc = 'Cumulative Course Grade'

*/







-----------------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Cumulative Course Grade' SKILL_DESCRIPTION
-----------------------------------------------------------------------------------------------------------------



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative Course Grade'	AND a.PrYr_MostRecent_Value is not NULL 
																	AND a.Final_MPLatest_Value	is not NULL
																    AND a.PrYr_MostRecent_Date <> a.Final_MPLatest_Date
			THEN 'Pre' 
			ELSE '' 
	   END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date
								AND a.Gradetype       =  'Cumulative Course Grade'

AND b.TAG = ''

-------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'Cumulative Course Grade' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative Course Grade' AND a.PrYr_MostRecent_Value is not NULL 
														        AND a.Final_MPLatest_Value is not NULL 
														        AND a.PrYr_MostRecent_Date <> a.Final_MPLatest_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID    = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								AND a.GradeType           = 'Cumulative Course Grade'
AND b.TAG = ''


-------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Cumulative Course Grade' SKILL_DESCRIPTION IF COMBINATION FAILED
-------------------------------------------------------------------------------------------------------


-- PrYr_MostRecent_Date--------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Course Grade'
AND b.TAG = ''



-------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'Reporting Period Course Grade' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

---1-----------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
															 	AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date 
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy') 


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
															 	AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date 
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math') 

--2------------------------------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
												 				AND a.Final_MPLatest_Value is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.Final_MPLatest_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy') 



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
												 				AND a.Final_MPLatest_Value is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.Final_MPLatest_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math') 

---3-----------------------------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	 
																AND a.First_MPEarliest_Value is not NULL 
																AND a.IntEndExit_Latest_Proxy_Value				  is not Null
															 	AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy') 



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	
																AND a.First_MPEarliest_Value is not NULL 
																AND a.IntEndExit_Latest_Proxy_Value				  is not Null
															 	AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND   b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math') 

--4-----------------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	
																AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	
																AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Pre'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')

-------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'Reporting Period Course Grade' SKILL_DESCRIPTION
-------------------------------------------------------------------------------------------------------

---1-----------------------------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
															 	AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date 
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG = CASE	WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.Final_MPLatest_Value   is not Null
															 	AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date 
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')

--2------------------------------------------------------------------------------------------------------------------------------------




UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
												 				AND a.Final_MPLatest_Value is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <>  a.Final_MPLatest_Date
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
												 				AND a.Final_MPLatest_Value is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <>  a.Final_MPLatest_Date
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.Final_MPLatest_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')


---3-----------------------------------------------------------------------------------------------------------------------------------



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.IntEndExit_Latest_Proxy_Value				  is not Null
															 	AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date 
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 
TAG =  CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.First_MPEarliest_Value is not NULL 
																AND a.IntEndExit_Latest_Proxy_Value				  is not Null
															 	AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date 
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')


--4-----------------------------------------------------------------------------------------------------------------------------------------




UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'	AND a.IntStartEnroll_Earliest_Proxy_Value is not Null
																AND a.IntEndExit_Latest_Proxy_Value       is not Null
															 	AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date
																THEN 'Post'
																ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntEndExit_Latest_Proxy_Date = b.assessment_Date
								
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')


---------------------------------------------------------------------------------------------------------------------
--IF ABOVE SCENARIOS ALL HAD PRE VALUE = MY_PROXY_VALUE OR POST VALUE OF NULL THEN UPDATE PRE USING FIRST AVAILABLE 
--PRE VALUE STARTING WITH SCENARIO 1 UNTIL A VALUE IS FOUND. ALSO SET MY_PROXY_VALUE AND POST TO NULL.
---------------------------------------------------------------------------------------------------------------------

/*  NOT NEEDED FOR CUMULATIVE

--2 First_MPEarliest_Date-------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT DISTINCT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre' and SKILL_DESCRIPTION = 'Cumulative Course Grade'  )


select * from SDW_PROD.dbo.Dimpreandposttag where CYSCHOOLHOUSE_ID = 'CY-14077' and gradetype in ('Cumulative Course Grade','Reporting Period Course Grade')  order by IndicatorArea,gradetype,datatype
select * from STAGE_9_RPT_PERFORMANCE_LEVEL_CG where  CYSCHOOLHOUSE_STUDENT_ID = 'CY-14077' order by skill_description,indicator_desc,assessment_date


--3 IntStartEnroll_Earliest_Proxy_Date-----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT DISTINCT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre' and SKILL_DESCRIPTION = 'Cumulative Course Grade' )



*/


--REPORTING PERIOD COURSE GRADE


/* NEVER FOR REPORTING PERIOD

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
b.SKILL_DESCRIPTION = 'Reporting Period Course Grade'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_AT b where TAG = 'Pre' and SKILL_DESCRIPTION = 'Reporting Period Course Grade')

select * from STAGE_9_RPT_PERFORMANCE_LEVEL_CG where  CYSCHOOLHOUSE_STUDENT_ID = 'CY-14038' order by skill_description,assessment_date

*/



--2 First_MPEarliest_Date-------------------------------------------------------------------------------------------------------



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date

WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.First_MPEarliest_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.First_MPEarliest_Date = b.assessment_Date

WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')


--3 IntStartEnroll_Earliest_Proxy_Date-----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'ELA/Literacy')


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.IntStartEnroll_Earliest_Proxy_Date = b.assessment_Date 
WHERE a.Gradetype = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math'
AND  b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_CG b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Course Grade' and b.INDICATOR_DESC = 'Math')



-------------------------------------------------------------------------------------------------------------------------------
--UPDATE INTERVAL
-------------------------------------------------------------------------------------------------------------------------------

UPDATE [STAGE_9_RPT_PERFORMANCE_LEVEL_CG] SET
INTERVAL =  b.Quarter
FROM [STAGE_9_RPT_PERFORMANCE_LEVEL_CG] AS a INNER JOIN  SDW_PROD.dbo.DimSchoolSetup b
											ON a.SCHOOL_ID = b.SCHOOLID
WHERE a.ASSESSMENT_DATE between b.Start_Date and b.End_Date

-----------------------------------------------------------------------------------------------------------------
--SCALE LOCAL AND SCALE_NUM_LOCAL
-----------------------------------------------------------------------------------------------------------------
 
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
SCALE_LOCAL =  b.[SCALE_LOCAL],
SCALE_NUM_LOCAL =  b.[SCALE_NUM_LOCAL]
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE a.Performance_Value = b.[PERFORMANCE_VALUE_DISPLAY]

select * from  ReportCYData_PROD.dbo.Goals_Sample_Alpha where  site = 'Denver' and school = 'Cheltenham Elementary' and grade = '3' and IA = 'ELA/Literacy'
and  Skill_Description = 'Reporting Period Course Grade'


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
SCALE_LOCAL =  b.[SCALE_LOCAL],
SCALE_NUM_LOCAL =  b.[SCALE_NUM_LOCAL]
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE a.assessment_date between b.Date_Range_min and b.Date_range_max
AND    isnumeric(a.performance_value) = 1
AND    convert(float,a.Performance_Value) between b.Performance_Value_Display_Min and b.Performance_Value_Display_Max


-----------------------------------------------------------------------------------------------------------------
--SCALE_NORM AND SCALE_NUM_NORM
-----------------------------------------------------------------------------------------------------------------
 

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
SCALE_NORM		=  b.[SCALE_NORM],
SCALE_NUM_NORM =   b.[SCALE_NUM_NORM] 
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE  a.assessment_date between b.Date_Range_min and b.Date_range_max
AND    isnumeric(a.performance_value) = 1
AND    convert(float,a.Performance_Value) between b.Performance_Value_Display_Min and b.Performance_Value_Display_Max



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
SCALE_NORM		=  b.[SCALE_NORM],
SCALE_NUM_NORM =   b.[SCALE_NUM_NORM] 
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Alpha b
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



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
SCORE_RANK		=   b.SCORE_RANK,
SCORE_RANK_NORM =   b.SCORE_RANK_NORM 
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE a.Performance_Value = b.[PERFORMANCE_VALUE_DISPLAY]


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
SCORE_RANK		=   b.SCORE_RANK,
SCORE_RANK_NORM =   b.SCORE_RANK_NORM 
FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description

WHERE  a.assessment_date between b.Date_Range_min and b.Date_range_max
AND    isnumeric(a.performance_value) = 1
AND    a.Performance_Value >= b.Performance_Value_Display_Min and a.Performance_Value <= b.Performance_Value_Display_Max
  
-----------------------------------------------------------------------------------------------------------------
-- USED_FOR_SUMMATIVE_REPORTING
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET  
USED_FOR_SUMMATIVE_REPORTING		=   b.USED_FOR_SUMMATIVE_REPORTING

FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Alpha b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description



UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET
USED_FOR_SUMMATIVE_REPORTING		=   b.USED_FOR_SUMMATIVE_REPORTING

FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade  --convert(varchar(250),b.grade)
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description
					--AND a.DATA_TYPE         = b.DATA_TYPE





-----------------------------------------------------------------------------------------------------------------
-- UPDATE "USED_AS_MID_YEAR_POINT"
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_CG SET 	
USED_AS_MID_YEAR_DATA_POINT  =  CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_PROD.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_CG b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								--AND a.DataType			  = b.DATA_TYPE





----------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------
--TRUNCATE AND INSERT TO TABLE 9_RPT_PERFORMANCE_LEVEL_CG
-----------------------------------------------------------------------------------------------------------------
	
	TRUNCATE TABLE [9_RPT_PERFORMANCE_LEVEL_CG]

	INSERT INTO [9_RPT_PERFORMANCE_LEVEL_CG]
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

	FROM STAGE_9_RPT_PERFORMANCE_LEVEL_CG

	
END






















GO
