USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_5_RPT_CY_L_SCHOOL_PERFORMANCE]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  VIEW [dbo].[vw_5_RPT_CY_L_SCHOOL_PERFORMANCE]
AS
SELECT DISTINCT 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
c.Business_Unit AS SITE_NAME, 
c.SchoolName AS SCHOOL_NAME, 
d.StudentName AS STUDENT_NAME, 
e.AssessmentName AS SKILL_DESC, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display END AS DATA_TYPE, 
--CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date AS ASSESSMENT_DATE, 
min(CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score END) AS PERFORMANCE_VALUE, 
e.Create_Date AS ENTRY_DATE, 
e.Created_By AS CREATE_BY, 
g.SchoolYear AS FISCAL_YEAR, 
CASE Diplomas_Now 
WHEN 'Yes' THEN 1 
WHEN 'No' THEN 0 END Diplomas_Now, 
a.StudentID, d.CY_StudentID, d.GRADE

FROM            SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                         SDW_Prod.dbo.DimIndicatorArea AS b WITH (nolock) ON a.IndicatorAreaID = b.IndicatorAreaID INNER JOIN
                         SDW_Prod.dbo.DimSchool AS c WITH (nolock) ON a.SchoolID = c.SchoolID INNER JOIN
                         SDW_Prod.dbo.DimStudent AS d WITH (nolock) ON a.StudentID = d .StudentID INNER JOIN
                         SDW_Prod.dbo.DimAssessment AS e WITH (nolock) ON a.AssessmentID = e.AssessmentID INNER JOIN
                         SDW_Prod.dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS g WITH (nolock) ON a.GradeID = g.GradeID INNER JOIN
                         SDW_Prod.dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID
WHERE        a.FactTypeID = 1 OR
                         (a.FactTypeID = 3 AND e.Classification = 1)
Group by 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END, 
c.Business_Unit, 
c.SchoolName, 
d.StudentName, 
e.AssessmentName, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display END, 
--CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date, e.Create_Date, e.Created_By, g.SchoolYear, 
CASE Diplomas_Now 
WHEN 'Yes' THEN 1 
WHEN 'No' THEN 0 END, 
a.StudentID, d.CY_StudentID, d.GRADE

UNION ALL

SELECT DISTINCT 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
c.Business_Unit AS SITE_NAME, c.SchoolName AS SCHOOL_NAME, 
d.StudentName AS STUDENT_NAME, e.AssessmentName AS SKILL_DESC, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_2 END AS DATA_TYPE, 
--CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date AS ASSESSMENT_DATE, 
min(CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score_2 END) AS PERFORMANCE_VALUE, 
e.Create_Date AS ENTRY_DATE, e.Created_By AS CREATE_BY, g.SchoolYear AS FISCAL_YEAR, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END Diplomas_Now, 
a.StudentID, d.CY_StudentID, d.GRADE
FROM            SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                         SDW_Prod.dbo.DimIndicatorArea AS b WITH (nolock) ON a.IndicatorAreaID = b.IndicatorAreaID INNER JOIN
                         SDW_Prod.dbo.DimSchool AS c WITH (nolock) ON a.SchoolID = c.SchoolID INNER JOIN
                         SDW_Prod.dbo.DimStudent AS d WITH (nolock) ON a.StudentID = d .StudentID INNER JOIN
                         SDW_Prod.dbo.DimAssessment AS e WITH (nolock) ON a.AssessmentID = e.AssessmentID INNER JOIN
                         SDW_Prod.dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS g WITH (nolock) ON a.GradeID = g.GradeID INNER JOIN
                         SDW_Prod.dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID
WHERE        a.FactTypeID = 3 AND e.Classification IN ('2', '3', '4', '5')
GROUP BY 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END, 
c.Business_Unit, c.SchoolName, d.StudentName, e.AssessmentName, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_2 END, 
--CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date, 
e.Create_Date, e.Created_By, g.SchoolYear, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END, a.StudentID, d.CY_StudentID, d.GRADE

UNION ALL

SELECT DISTINCT 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
c.Business_Unit AS SITE_NAME, c.SchoolName AS SCHOOL_NAME, d.StudentName AS STUDENT_NAME, 
e.AssessmentName AS SKILL_DESC, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_3 END AS DATA_TYPE, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date AS ASSESSMENT_DATE, 
min(CASE a.FactTypeID WHEN 1 THEN CAST(a.Assignment_Grade_Number AS varchar(100)) WHEN 3 THEN e.Score_3 END) AS PERFORMANCE_VALUE, 
e.Create_Date AS ENTRY_DATE, e.Created_By AS CREATE_BY, g.SchoolYear AS FISCAL_YEAR, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END Diplomas_Now, 
a.StudentID, d.CY_StudentID, d.GRADE
FROM            SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                         SDW_Prod.dbo.DimIndicatorArea AS b WITH (nolock) ON a.IndicatorAreaID = b.IndicatorAreaID INNER JOIN
                         SDW_Prod.dbo.DimSchool AS c WITH (nolock) ON a.SchoolID = c.SchoolID INNER JOIN
                         SDW_Prod.dbo.DimStudent AS d WITH (nolock) ON a.StudentID = d .StudentID INNER JOIN
                         SDW_Prod.dbo.DimAssessment AS e WITH (nolock) ON a.AssessmentID = e.AssessmentID INNER JOIN
                         SDW_Prod.dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS g WITH (nolock) ON a.GradeID = g.GradeID INNER JOIN
                         SDW_Prod.dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID
WHERE        a.FactTypeID = 3 AND e.Classification IN ('3', '4', '5')
GROUP BY 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END, 
c.Business_Unit, c.SchoolName, d.StudentName, e.AssessmentName, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_3 END, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date, 
e.Create_Date, e.Created_By, g.SchoolYear, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END, 
a.StudentID, d.CY_StudentID, d.GRADE

UNION ALL

SELECT DISTINCT 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
c.Business_Unit AS SITE_NAME, 
c.SchoolName AS SCHOOL_NAME, 
d.StudentName AS STUDENT_NAME, 
e.AssessmentName AS SKILL_DESC, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_4 END AS DATA_TYPE, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date AS ASSESSMENT_DATE, 
min(CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score_4 END) AS PERFORMANCE_VALUE, 
e.Create_Date AS ENTRY_DATE, 
e.Created_By AS CREATE_BY, 
g.SchoolYear AS FISCAL_YEAR, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END Diplomas_Now, 
a.StudentID, 
                         d.CY_StudentID, 
d.GRADE
FROM            SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                         SDW_Prod.dbo.DimIndicatorArea AS b WITH (nolock) ON a.IndicatorAreaID = b.IndicatorAreaID INNER JOIN
                         SDW_Prod.dbo.DimSchool AS c WITH (nolock) ON a.SchoolID = c.SchoolID INNER JOIN
                         SDW_Prod.dbo.DimStudent AS d WITH (nolock) ON a.StudentID = d .StudentID INNER JOIN
                         SDW_Prod.dbo.DimAssessment AS e WITH (nolock) ON a.AssessmentID = e.AssessmentID INNER JOIN
                         SDW_Prod.dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS g WITH (nolock) ON a.GradeID = g.GradeID INNER JOIN
                         SDW_Prod.dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID
WHERE        a.FactTypeID = 3 AND e.Classification IN ('4', '5')
GROUP BY 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END, 
c.Business_Unit, 
c.SchoolName, 
d.StudentName, 
e.AssessmentName, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_4 END, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date, 
e.Create_Date, 
e.Created_By, 
g.SchoolYear, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END , a.StudentID, 
                         d.CY_StudentID, 
d.GRADE

UNION ALL

SELECT DISTINCT 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
c.Business_Unit AS SITE_NAME, 
                         c.SchoolName AS SCHOOL_NAME, 
d.StudentName AS STUDENT_NAME, 
e.AssessmentName AS SKILL_DESC, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_5 END AS DATA_TYPE, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date AS ASSESSMENT_DATE, 
min(CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score_5 END) AS PERFORMANCE_VALUE, 
e.Create_Date AS ENTRY_DATE, 
                         e.Created_By AS CREATE_BY, 
g.SchoolYear AS FISCAL_YEAR, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END Diplomas_Now, 
a.StudentID, 
                         d.CY_StudentID, 
d.GRADE
FROM            SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                         SDW_Prod.dbo.DimIndicatorArea AS b WITH (nolock) ON a.IndicatorAreaID = b.IndicatorAreaID INNER JOIN
                         SDW_Prod.dbo.DimSchool AS c WITH (nolock) ON a.SchoolID = c.SchoolID INNER JOIN
                         SDW_Prod.dbo.DimStudent AS d WITH (nolock) ON a.StudentID = d .StudentID INNER JOIN
                         SDW_Prod.dbo.DimAssessment AS e WITH (nolock) ON a.AssessmentID = e.AssessmentID INNER JOIN
                         SDW_Prod.dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS g WITH (nolock) ON a.GradeID = g.GradeID INNER JOIN
                         SDW_Prod.dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID
WHERE        a.FactTypeID = 3 AND e.Classification = '5'
GROUP BY 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END, 
c.Business_Unit, c.SchoolName, d.StudentName, e.AssessmentName, 
CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_5 END, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
f.Date, 
e.Create_Date, e.Created_By, g.SchoolYear, 
CASE Diplomas_Now WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END , 
a.StudentID, 
d.CY_StudentID, 
d.GRADE




GO
