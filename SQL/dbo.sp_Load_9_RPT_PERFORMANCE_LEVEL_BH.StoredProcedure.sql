USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_BH]    Script Date: 12/1/2016 9:27:20 AM ******/
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
CREATE  PROCEDURE [dbo].[sp_Load_9_RPT_PERFORMANCE_LEVEL_BH]
AS
BEGIN

TRUNCATE TABLE [STAGE_9_RPT_PERFORMANCE_LEVEL_BH] 

INSERT INTO [dbo].[STAGE_9_RPT_PERFORMANCE_LEVEL_BH]

SELECT DISTINCT
     		b.CY_StudentID										AS CYSCHOOLHOUSE_STUDENT_ID, 
			b.StudentName										AS STUDENT_NAME, 
			e.Business_Unit										AS SITE_NAME, 
			e.SchoolName										AS SCHOOL_NAME, 
			CASE WHEN b.Grade = 'K' THEN '0' ELSE b.Grade END	AS GRADE,						 
            CASE WHEN e.Diplomas_Now = 'NO' THEN 0 ELSE 1 END	AS DIPLOMAS_NOW_SCHOOL, 
			d.MarkingPeriod										AS INTERVAL,
			''													AS SKILL_ID,
			g.AssessmentName								    AS SKILL_DESCRIPTION,			    --	h.AssignmentType
			CASE WHEN AssessmentName like '%Time Based Behavior Tracker - BEHAVIOR' then g.Data_Type_Display_5
			     WHEN AssessmentName = 'Dessa-mini' THEN g.Data_Type_Display ELSE '' END AS DATA_TYPE,
																				--	i.DATATYPE        /*'Number_of_Suspensions__c'*/ 	AS DATA_TYPE,  
																				--g.Data_Type_display, WE ARE ONLY LOOKING AT Number_of_Suspensions__c
		    i.INDICATORAREA										AS INDICATOR_DESC, 						
			f.Date												AS ASSESSMENT_DATE, 
			''													AS PERFORMANCE_VALUE,	
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
			g.assessmentID                                      AS ASSESSMENTID



FROM         SDW_PROD.dbo.FactAll AS a INNER JOIN
                      SDW_PROD.dbo.DimStudent		AS b ON a.StudentID			= b.StudentID		INNER JOIN
                      SDW_PROD.dbo.DimIndicatorArea	AS c ON a.IndicatorAreaID	= c.IndicatorAreaID INNER JOIN
                      SDW_PROD.dbo.DimGrade			AS d ON a.GradeID			= d.GradeID			INNER JOIN
                      SDW_PROD.dbo.DimSchool		AS e ON a.SchoolID			= e.SchoolID		INNER JOIN
                      SDW_PROD.dbo.DimDate			AS f ON a.DateID			= f.DateID			INNER JOIN
                      SDW_PROD.dbo.DimAssessment	AS g ON a.AssessmentID		= g.AssessmentID	INNER JOIN
                      SDW_PROD.dbo.DimAssignment	AS h ON a.AssignmentID		= h.AssignmentID	INNER JOIN  
					  SDW_PROD.dbo.Dimpreandposttag AS i on a.STUDENTID			= i.STUDENTID	
												AND ( g.Data_Type_display = i.DATATYPE OR g.Data_Type_display_5 = i.DATATYPE)
WHERE 
    a.AssessmentID <> 1 					
AND		i.INDICATORAREA = 'Behavior'
AND	g.AssessmentName in ('DESSA-mini','Cumulative Time Based Behavior Tracker - BEHAVIOR','Reporting Period Time Based Behavior Tracker - BEHAVIOR')
 
 

-------------------------------------------------------------------------------------------------------------------------------
--UPDATE PERFORMANCE_VALUE
-------------------------------------------------------------------------------------------------------------------------------

UPDATE ReportCYData_Prod.dbo.[STAGE_9_RPT_PERFORMANCE_LEVEL_BH] SET
PERFORMANCE_VALUE = i.performance_value
from ReportCYData_Prod.dbo.[STAGE_9_RPT_PERFORMANCE_LEVEL_BH] AS a INNER JOIN
ReportCYData_PROD.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]  AS i	ON   a.CYSCHOOLHOUSE_STUDENT_ID = i.CYSCHOOLHOUSE_STUDENT_ID
														AND  a.assessment_date	 = i.ASSESSMENT_DATE
														AND  a.skill_description = i.skill_desc
														AND  a.DATA_TYPE         = i.DATA_TYPE 


	DELETE FROM STAGE_9_RPT_PERFORMANCE_LEVEL_BH  WHERE PERFORMANCE_VALUE IS NULL or PERFORMANCE_VALUE  = 'N/A'
														
----------------------------------------------------------------------------------------------------------------------------------														  
--REMOVE DUPLICATES	


		SELECT 
			CYSCHOOLHOUSE_STUDENT_ID, 
			SKILL_DESCRIPTION, 
			DATA_TYPE, 
			ASSESSMENT_DATE
			INTO  #PRE_STAGE_TABLE_DUPES
			FROM STAGE_9_RPT_PERFORMANCE_LEVEL_BH 
			GROUP BY CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, DATA_TYPE,ASSESSMENT_DATE
			HAVING COUNT(*) > 1

			DELETE STAGE_9_RPT_PERFORMANCE_LEVEL_BH
			FROM STAGE_9_RPT_PERFORMANCE_LEVEL_BH (nolock) a
			INNER JOIN #PRE_STAGE_TABLE_DUPES (nolock) b ON
			a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
			AND a.SKILL_DESCRIPTION = b.SKILL_DESCRIPTION
			AND a.DATA_TYPE = b.DATA_TYPE
			AND CAST(a.ASSESSMENT_DATE as date) = CAST(b.ASSESSMENT_DATE as date)





/*   OLD DE-DUP CODE
select CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE
into #Temp_1
from [STAGE_9_RPT_PERFORMANCE_LEVEL_BH] a
group by CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE
having count(*) > 1


select a.CYSCHOOLHOUSE_STUDENT_ID, a.SKILL_DESCRIPTION, a.DATA_TYPE, a.INDICATOR_DESC, 
a.ASSESSMENT_DATE, b.ASSESSMENTID, Min(c.Score) Min_Score
into #Temp_2
from #Temp_1 a
inner join [STAGE_9_RPT_PERFORMANCE_LEVEL_BH] b 

on 
a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
and a.SKILL_DESCRIPTION = b.SKILL_DESCRIPTION
and a.DATA_TYPE = b.DATA_TYPE
and a.INDICATOR_DESC = b.INDICATOR_DESC
and cast(a.ASSESSMENT_DATE as date) = cast(b.ASSESSMENT_DATE as date)
inner join SDW_Prod.dbo.DimAssessment c on b.ASSESSMENTID = c.AssessmentID
group by a.CYSCHOOLHOUSE_STUDENT_ID, a.SKILL_DESCRIPTION, a.DATA_TYPE, a.INDICATOR_DESC, 
a.ASSESSMENT_DATE, b.ASSESSMENTID

select CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, min(a.Min_Score) Min_Score
into #Temp_3
from #Temp_2 a
group by CYSCHOOLHOUSE_STUDENT_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE





alter table #Temp_2 add Keep_Record int

update #Temp_2 set Keep_Record = 0

update #Temp_2
set Keep_Record = 1
from #Temp_2 a
inner join #Temp_3 b on 
a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID and
a.SKILL_DESCRIPTION = b.SKILL_DESCRIPTION and
a.DATA_TYPE = b.DATA_TYPE and
a.INDICATOR_DESC = b.INDICATOR_DESC and
cast(a.ASSESSMENT_DATE as date) = cast(b.ASSESSMENT_DATE as date) and
a.Min_Score = b.Min_Score




DELETE [STAGE_9_RPT_PERFORMANCE_LEVEL_BH]
FROM [STAGE_9_RPT_PERFORMANCE_LEVEL_BH] a 
INNER JOIN #Temp_2 b
ON 
a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID and
a.SKILL_DESCRIPTION = b.SKILL_DESCRIPTION and
a.DATA_TYPE = b.DATA_TYPE and
a.INDICATOR_DESC = b.INDICATOR_DESC and
a.ASSESSMENT_DATE = b.ASSESSMENT_DATE and
a.ASSESSMENTID = b.ASSESSMENTID
where Keep_Record = 0






select * into #Temp_9_BH from ReportCYData_Prod.dbo.STAGE_9_RPT_PERFORMANCE_LEVEL_BH

truncate table ReportCYData_Prod.dbo.STAGE_9_RPT_PERFORMANCE_LEVEL_BH

insert into ReportCYData_Prod.dbo.STAGE_9_RPT_PERFORMANCE_LEVEL_BH(CYSCHOOLHOUSE_STUDENT_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, TARGET_SCORE, TESTING_GRADE_LEVEL, SCORE_RANK, SCORE_RANK_NORM, SCALE_LOCAL, SCALE_NORM, SCALE_NUM_LOCAL, SCALE_NUM_NORM, TAG, USED_AS_MID_YEAR_DATA_POINT, USED_FOR_SUMMATIVE_REPORTING, FISCAL_YEAR, CYSCHOOLHOUSE_SCHOOL_ID, SCHOOL_ID, SITE_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH,assessmentID)
select distinct CYSCHOOLHOUSE_STUDENT_ID, STUDENT_NAME, SITE_NAME, SCHOOL_NAME, GRADE, DIPLOMAS_NOW_SCHOOL, INTERVAL, SKILL_ID, SKILL_DESCRIPTION, DATA_TYPE, INDICATOR_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, TARGET_SCORE, TESTING_GRADE_LEVEL, SCORE_RANK, SCORE_RANK_NORM, SCALE_LOCAL, SCALE_NORM, SCALE_NUM_LOCAL, SCALE_NUM_NORM, TAG, USED_AS_MID_YEAR_DATA_POINT, USED_FOR_SUMMATIVE_REPORTING, FISCAL_YEAR, CYSCHOOLHOUSE_SCHOOL_ID, SCHOOL_ID, SITE_ID, CREATED_BY, ENTRY_DATE, LAST_REFRESH,assessmentID
from #Temp_9_BH (nolock)
*/
------------------------------------------------------------------------------------------------------------------

UPDATE [STAGE_9_RPT_PERFORMANCE_LEVEL_BH] SET
INTERVAL =  b.Quarter
FROM [STAGE_9_RPT_PERFORMANCE_LEVEL_BH] AS a INNER JOIN  SDW_PROD.dbo.DimSchoolSetup b
											ON a.SCHOOL_ID = b.SCHOOLID
WHERE convert(datetime,a.assessment_date) between b.Start_Date and b.End_Date





-------------------------------------------------------------------------------------------------------------------------------
--START OF TAGGING: Cumulative Time Based Behavior Tracker - BEHAVIOR
-------------------------------------------------------------------------------------------------------------------------------

--PRE-Cumulative Time Based Behavior Tracker - BEHAVIOR----------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.PrYr_MostRecent_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.PrYr_MostRecent_date <> a.Final_MPLatest_date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.PrYr_MostRecent_Date = b.assessment_Date
								AND a.Gradetype       = 'Cumulative Cumulative Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Cumulative Time Based Behavior Tracker - BEHAVIOR')


---POST-Cumulative Time Based Behavior Tracker - BEHAVIOR---------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Cumulative Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.PrYr_MostRecent_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.PrYr_MostRecent_date <> a.Final_MPLatest_date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.Final_MPLatest_Date = b.assessment_Date
								AND a.Gradetype       = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description like 'Cumulative Time Based Behavior Tracker - BEHAVIOR')

------------------------------------------------------------------------------------------------------------------------------
--IF THE ABOVE SCENARIO DOESN"T HAVE A Final_MPLatest_Date but DOES HAVE A PrYr_MostRecent_Value THEN SET TAG TO PRE
------------------------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.DataType         = b.Data_Type
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Cumulative Time Based Behavior Tracker - BEHAVIOR')

---------------------------------------------------------------------------------------------------------------------------------
--END Cumulative Time Based Behavior Tracker - BEHAVIOR TAGGING 
---------------------------------------------------------------------------------------------------------------------------------





-------------------------------------------------------------------------------------------------------------------------------
--START OF TAGGING: Reporting Period Time Based Behavior Tracker - BEHAVIOR
-------------------------------------------------------------------------------------------------------------------------------


--1--PRE Reporting Period Time Based Behavior Tracker - BEHAVIOR-------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
														 AND a.First_MPEarliest_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID				= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType						= b.SKILL_DESCRIPTION
								AND a.IndicatorArea					= b.Indicator_Desc 
								AND a.DataType						= b.Data_Type
								AND a.First_MPEarliest_Date			= b.assessment_Date
								AND a.Gradetype						= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')

--2--PRE Reporting Period Time Based Behavior Tracker - BEHAVIOR-------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.IntStartEnroll_Earliest_Proxy_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.IntStartEnroll_Earliest_Proxy_Date <> a.Final_MPLatest_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID						= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType								= b.SKILL_DESCRIPTION
								AND a.IndicatorArea							= b.Indicator_Desc 
								AND a.DataType								= b.Data_Type
								AND a.IntStartEnroll_Earliest_Proxy_Date	= b.assessment_Date
								AND a.Gradetype								= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description  = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')


--3--PRE Reporting Period Time Based Behavior Tracker - BEHAVIOR------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.First_MPEarliest_Value is not NULL 
														 AND a.IntEndExit_Latest_Proxy_Value  is not NULL
														 AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID			= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType					= b.SKILL_DESCRIPTION
								AND a.IndicatorArea				= b.Indicator_Desc 
								AND a.DataType					= b.Data_Type
								AND a.First_MPEarliest_Date	= b.assessment_Date
								AND a.Gradetype					= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')


--4--PRE Reporting Period Time Based Behavior Tracker - BEHAVIOR--------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.IntStartEnroll_Earliest_Proxy_Interval is not NULL 
														 AND a.IntEndExit_Latest_Proxy_Value is not NULL
														 AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID							= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType									= b.SKILL_DESCRIPTION
								AND a.IndicatorArea								= b.Indicator_Desc 
								AND a.DataType									= b.Data_Type
								AND a.IntStartEnroll_Earliest_Proxy_Date		= b.assessment_Date
								AND a.Gradetype       = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')



-----------------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR Reporting Period Time Based Behavior Tracker - BEHAVIOR SKILL_DESCRIPTION
-----------------------------------------------------------------------------------------------------------------


--1--POST Reporting Period Time Based Behavior Tracker - BEHAVIOR-------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.First_MPEarliest_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID		= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType				= b.SKILL_DESCRIPTION
								AND a.IndicatorArea			= b.Indicator_Desc 
								AND a.DataType				= b.Data_Type
								AND a.Final_MPLatest_Date	= b.assessment_Date
								AND a.Gradetype				= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')

--2--POST Reporting Period Time Based Behavior Tracker - BEHAVIOR---------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
														 AND a.IntStartEnroll_Earliest_Proxy_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.IntStartEnroll_Earliest_Proxy_Date <> a.Final_MPLatest_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID		= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType				= b.SKILL_DESCRIPTION
								AND a.IndicatorArea			= b.Indicator_Desc 
								AND a.DataType				= b.Data_Type
								AND a.Final_MPLatest_Date	= b.assessment_Date
								AND a.Gradetype				= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')


--3--POST Reporting Period Time Based Behavior Tracker - BEHAVIOR------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR' 
														 AND a.First_MPEarliest_Value is not NULL 
														 AND a.IntEndExit_Latest_Proxy_Value is not NULL
														 AND a.First_MPEarliest_Date <> a.IntEndExit_Latest_Proxy_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID				= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType						= b.SKILL_DESCRIPTION
								AND a.IndicatorArea					= b.Indicator_Desc 
								AND a.DataType						= b.Data_Type
								AND a.IntEndExit_Latest_Proxy_Date	= b.assessment_Date
								AND a.Gradetype						= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')


--4--POST Reporting Period Time Based Behavior Tracker - BEHAVIOR------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
														 AND a.IntStartEnroll_Earliest_Proxy_Interval is not NULL 
														 AND a.IntEndExit_Latest_Proxy_Value is not NULL
														 AND a.IntStartEnroll_Earliest_Proxy_Date <> a.IntEndExit_Latest_Proxy_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID				= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType						= b.SKILL_DESCRIPTION
								AND a.IndicatorArea					= b.Indicator_Desc 
								AND a.DataType						= b.Data_Type
								AND a.IntEndExit_Latest_Proxy_Date	= b.assessment_Date
								AND a.Gradetype						= 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
WHERE a.Gradetype = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')


---------------------------------------------------------------------------------------------------------------------
--IF ABOVE SCENARIOS ALL HAD PRE VALUE = MY_PROXY_VALUE OR POST VALUE OF NULL THEN UPDATE PRE USING FIRST AVAILABLE 
--PRE VALUE STARTING WITH SCENARIO 1 UNTIL A VALUE IS FOUND. ALSO SET MY_PROXY_VALUE AND POST TO NULL.
---------------------------------------------------------------------------------------------------------------------


--Time Based Behavior Tracker - BEHAVIOR


--1 First_MPEarliest_Value-----------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
TAG =   CASE WHEN a.First_MPEarliest_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON  a.CYSCHOOLHOUSE_ID		= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType				= b.SKILL_DESCRIPTION
								AND a.IndicatorArea			= b.Indicator_Desc 
								AND a.DataType				= b.Data_Type
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')


--2 IntStartEnroll_Earliest_Proxy_Date----------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
TAG =   CASE WHEN a.IntStartEnroll_Earliest_Proxy_Date is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON  a.CYSCHOOLHOUSE_ID						= b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType								= b.SKILL_DESCRIPTION
								AND a.IndicatorArea							= b.Indicator_Desc 
								AND a.DataType								= b.Data_Type
								AND a.IntStartEnroll_Earliest_Proxy_Date	= b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR')



-----------------------------------------------------------------------------------------------------------------
--UPDATE "Pre" TAG FOR 'DESSA-mini' SKILL_DESCRIPTION
-----------------------------------------------------------------------------------------------------------------


--1--------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'DESSA-mini' AND a.First_MPEarliest_Value is not NULL 
												   AND a.Final_MPLatest_Value is not NULL
												   AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.First_MPEarliest_Date = b.assessment_Date
								AND a.Gradetype       =  'DESSA-mini'
WHERE a.Gradetype = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'DESSA-mini')

--2--------------------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'DESSA-mini'  AND a.PrYr_MostRecent_Value is not NULL 
													AND a.Final_MPLatest_Value is not NULL
													AND a.PrYr_MostRecent_Date <> a.Final_MPLatest_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.PrYr_MostRecent_Date = b.assessment_Date
								AND a.Gradetype       =  'DESSA-mini'
WHERE a.Gradetype = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'DESSA-mini')

--3--------------------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'DESSA-mini' AND a.CYr_Earliest_Value is not NULL 
												   AND a.CYr_MostRecent_Value is not NULL
												   AND a.CYr_Earliest_Date <> a.CYr_MostRecent_Date
														 THEN 'Pre' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.CYr_Earliest_Date = b.assessment_Date
								AND a.Gradetype       =  'DESSA-mini'
WHERE a.Gradetype = 'DESSA-mini' 
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'DESSA-mini')



-----------------------------------------------------------------------------------------------------------------
--UPDATE "Post" TAG FOR 'DESSA-mini' SKILL_DESCRIPTION
-----------------------------------------------------------------------------------------------------------------

--1--------------------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'DESSA-mini' AND a.First_MPEarliest_Value is not NULL 
												   AND a.Final_MPLatest_Value is not NULL
												   AND a.First_MPEarliest_Date <> a.Final_MPLatest_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.Final_MPLatest_Date = b.assessment_Date
								AND a.Gradetype       =  'DESSA-mini'
WHERE a.Gradetype = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'DESSA-mini')

--2--------------------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'DESSA-mini' AND a.PrYr_MostRecent_Value is not NULL 
														 AND a.Final_MPLatest_Value is not NULL
														 AND a.PrYr_MostRecent_Date <> a.Final_MPLatest_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.Final_MPLatest_Date = b.assessment_Date
								AND a.Gradetype       =  'DESSA-mini'
WHERE a.Gradetype = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'DESSA-mini')

--3--------------------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 
TAG = CASE WHEN b.SKILL_DESCRIPTION = 'DESSA-mini' AND a.CYr_Earliest_Value is not NULL 
														 AND a.CYr_MostRecent_Value is not NULL
													     AND a.CYr_Earliest_Date <> a.CYr_MostRecent_Date
														 THEN 'Post' ELSE '' END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType       = b.SKILL_DESCRIPTION
								AND a.IndicatorArea   = b.Indicator_Desc 
								AND a.DataType        = b.Data_Type
								AND a.CYr_MostRecent_Date = b.assessment_Date
								AND a.Gradetype       =  'DESSA-mini'
WHERE a.Gradetype = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Post'
										AND b.skill_description = 'DESSA-mini')


---------------------------------------------------------------------------------------------------------------------
--IF ABOVE SCENARIOS ALL HAD PRE VALUE = MY_PROXY_VALUE OR POST VALUE OF NULL THEN UPDATE PRE USING FIRST AVAILABLE 
--PRE VALUE STARTING WITH SCENARIO 1 UNTIL A VALUE IS FOUND. ALSO SET MY_PROXY_VALUE AND POST TO NULL.
---------------------------------------------------------------------------------------------------------------------


--1------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
TAG =   CASE WHEN a.First_MPEarliest_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.DataType         = b.Data_Type
								AND a.First_MPEarliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'DESSA-mini')


--2------------------------------------------------------------------------------------------------------------------
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
TAG =   CASE WHEN a.PrYr_MostRecent_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.DataType         = b.Data_Type
								AND a.PrYr_MostRecent_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'DESSA-mini'
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'DESSA-mini')

--3------------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
TAG =   CASE WHEN a.CYr_Earliest_Value is not NULL THEN 'Pre' 
			 ELSE '' 
		END
FROM SDW_PROD.dbo.Dimpreandposttag a inner join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON  a.CYSCHOOLHOUSE_ID = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType        = b.SKILL_DESCRIPTION
								AND a.IndicatorArea    = b.Indicator_Desc 
								AND a.DataType         = b.Data_Type
								AND a.CYr_Earliest_Date = b.assessment_Date 
WHERE
b.SKILL_DESCRIPTION = 'DESSA-mini'  
AND b.CYSCHOOLHOUSE_STUDENT_ID NOT IN (SELECT CYSCHOOLHOUSE_STUDENT_ID from STAGE_9_RPT_PERFORMANCE_LEVEL_BH b where TAG = 'Pre'
										AND b.skill_description = 'DESSA-mini')







-----------------------------------------------------------------------------------------------------------------
-- UPDATE "USED_AS_MID_YEAR_POINT"
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 	
USED_AS_MID_YEAR_DATA_POINT  = CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_PROD.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.GradeType           = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'
								AND a.DataType            = 'Number_of_Suspensions__c'


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 	
USED_AS_MID_YEAR_DATA_POINT  = CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_PROD.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.GradeType           = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'
								AND a.DataType            = 'Number_of_Suspensions__c'


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET 	
USED_AS_MID_YEAR_DATA_POINT  = CASE WHEN a.MY_PROXY_Date = b.assessment_Date  THEN '1' ELSE '0' END

from SDW_PROD.dbo.Dimpreandposttag a left outer join STAGE_9_RPT_PERFORMANCE_LEVEL_BH b
								ON a.CYSCHOOLHOUSE_ID     = b.CYSCHOOLHOUSE_STUDENT_ID
								AND a.GradeType           = b.SKILL_DESCRIPTION
								AND a.IndicatorArea       = b.Indicator_Desc 
								AND a.GradeType           = 'DESSA-mini'
								AND a.DataType            = 'SEL_Composite_T_Score__c' 

-----------------------------------------------------------------------------------------------------------------
-- USED_FOR_SUMMATIVE_REPORTING
-----------------------------------------------------------------------------------------------------------------


UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
USED_FOR_SUMMATIVE_REPORTING	= '1'



/* OLD CODE: EVAL INDICATES THAT ALL ROWS SHOULD BE UPDATED 
UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
USED_FOR_SUMMATIVE_REPORTING		=   b.USED_FOR_SUMMATIVE_REPORTING

FROM STAGE_9_RPT_PERFORMANCE_LEVEL_BH a inner join ReportCYData_PROD.dbo.Goals_Sample_Numeric b
					ON  a.site_name			= b.site
					AND a.school_name		= b.School
					AND a.grade				= b.grade
					AND a.Indicator_Desc	= b.IA
					AND a.skill_description = b.Skill_Description
					AND a.Data_Type          = b.Data_Type

WHERE a.Performance_Value Between b.[PERFORMANCE_VALUE_DISPLAY_MIN] and b.[PERFORMANCE_VALUE_DISPLAY_MAX]

*/


-----------------------------------------------------------------------------------------------------------------
--UPDATE SCALE_NORM AND SCALE_NUM_NORM FOR DESSA-mini ONLY
-----------------------------------------------------------------------------------------------------------------

UPDATE STAGE_9_RPT_PERFORMANCE_LEVEL_BH SET  
	SCALE_NORM		=  b.SEL_Composite_Description,
	SCALE_NUM_NORM	= CASE	WHEN b.SEL_Composite_Description = 'N' THEN '1'
							WHEN b.SEL_Composite_Description = 'T' THEN '2'
							WHEN b.SEL_Composite_Description = 'S' THEN '3'
							ELSE ''
					  END

FROM STAGE_9_RPT_PERFORMANCE_LEVEL_BH a INNER JOIN SDW_PROD.dbo.DimAssessment b
										ON  a.AssessmentID = b.AssessmentID
WHERE a.SKILL_DESCRIPTION = 'DESSA-mini'					
				
	
-----------------------------------------------------------------------------------------------------------------
--TRUNCATE AND INSERT TO TABLE 9_RPT_PERFORMANCE_LEVEL_BH
-----------------------------------------------------------------------------------------------------------------
	
	TRUNCATE TABLE [9_RPT_PERFORMANCE_LEVEL_BH]

	INSERT INTO [9_RPT_PERFORMANCE_LEVEL_BH]
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
	
	FROM STAGE_9_RPT_PERFORMANCE_LEVEL_BH

END
















GO
