USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_9_RPT_PERFORMANCE_LEVEL_AT]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  VIEW [dbo].[vw_9_RPT_PERFORMANCE_LEVEL_AT]
AS
SELECT		b.CY_StudentID										AS CYSCHOOLHOUSE_STUDENT_ID, 
			b.StudentName										AS STUDENT_NAME, 
			e.Business_Unit										AS SITE_NAME, 
			e.SchoolName										AS SCHOOL_NAME, 
			b.Grade												AS GRADE,						 
            CASE WHEN e.Diplomas_Now = 'NO' THEN 0 ELSE 1 END	AS DIPLOMAS_NOW_SCHOOL, 
			d.MarkingPeriod										AS INTERVAL,
			'								'					AS SKILL_ID,
			h.AssignmentType									AS SKILL_DESCRIPTION, 
			j.DataType											AS DATA_TYPE, 
			i.INDICATOR_AREA_DESC								AS INDICATOR_DESC, 						
			f.Date												AS ASSESSMENT_DATE, 
			i.PERFORMANCE_VALUE									AS PERFORMANCE_VALUE,	
			NULL												AS TARGET_SCORE,
            NULL												AS TESTING_GRADE_LEVEL,
			NULL												AS SCORE_RANK, 
			NULL												AS SCORE_RANK_NORM, 
        	'                                '					AS SCALE_LOCAL,
			'                                '                  AS SCALE_NORM, 
			'                                '					AS SCALE_NUM_LOCAL,
			'                                '					AS SCALE_NUM_NORM, 
			'					'								AS TAG, 
			NULL												AS USED_AS_MID_YEAR_POINT,
			'					'								AS USED_FOR_SUMMATIVE_REPORTING,
			d.SchoolYear										AS FISCAL_YEAR, 
			e.CYSch_SF_ID										AS CYSCHOOLHOUSE_SCHOOL_ID,
			e.SchoolID											AS SCHOOL_ID,
            ''													AS SITE_ID,
			g.Created_By                                        AS CREATED_BY, 
			g.Create_Date										AS ENTRY_DATE, 
			GETDATE()											AS LAST_REFRESH
	
FROM         SDW_Prod.dbo.FactAll AS a INNER JOIN
                      SDW_Prod.dbo.DimStudent		AS b ON a.StudentID			= b.StudentID		INNER JOIN
                      SDW_Prod.dbo.DimIndicatorArea	AS c ON a.IndicatorAreaID	= c.IndicatorAreaID INNER JOIN
                      SDW_Prod.dbo.DimGrade			AS d ON a.GradeID			= d.GradeID			INNER JOIN
                      SDW_Prod.dbo.DimSchool			AS e ON a.SchoolID			= e.SchoolID		INNER JOIN
                      SDW_Prod.dbo.DimDate			AS f ON a.DateID			= f.DateID			INNER JOIN
                      SDW_Prod.dbo.DimAssessment		AS g ON a.AssessmentID		= g.AssessmentID	INNER JOIN
                      SDW_Prod.dbo.DimAssignment		AS h ON a.AssignmentID		= h.AssignmentID	LEFT OUTER JOIN  
					  ReportCYData.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]  AS i ON a.STUDENTID	= i.STUDENT_ID
																   AND  f.Date				= i.ASSESSMENT_DATE
																   AND  h.AssignmentType	= i.skill_desc
																								LEFT OUTER JOIN
					  SDW_Prod.dbo.DIMPREANDPOSTTAG AS j ON a.studentID			 = j.StudentID
											       AND h.AssignmentType		 = j.GradeType
												   AND i.INDICATOR_AREA_DESC = j.IndicatorArea
														 	
WHERE    (h.AssignmentType LIKE '%ADA%')  



GO
