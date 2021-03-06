USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_5_RPT_CY_L_SCHOOL_PERFORMANCE_OLD]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_5_RPT_CY_L_SCHOOL_PERFORMANCE_OLD]
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
                         CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score END AS PERFORMANCE_VALUE, 
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
WHERE        a.FactTypeID = 1 OR
                         (a.FactTypeID = 3 AND e.Classification = 1)
UNION ALL
SELECT DISTINCT 
                         CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
						 c.Business_Unit AS SITE_NAME, 
                         c.SchoolName AS SCHOOL_NAME, 
						 d.StudentName AS STUDENT_NAME, 
						 e.AssessmentName AS SKILL_DESC, 
                         CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_2 END AS DATA_TYPE, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
						 f.Date AS ASSESSMENT_DATE, 
                         CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score_2 END AS PERFORMANCE_VALUE, 
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
WHERE        a.FactTypeID = 3 AND e.Classification IN ('2', '3', '4', '5')
UNION ALL
SELECT DISTINCT 
                         CASE a.FactTypeID WHEN 1 THEN h.AssignmentSubject WHEN 3 THEN e.Indicator_Area END AS INDICATOR_DESC, 
						 c.Business_Unit AS SITE_NAME, 
                         c.SchoolName AS SCHOOL_NAME, 
						 d.StudentName AS STUDENT_NAME, 
						 e.AssessmentName AS SKILL_DESC, 
                         CASE a.FactTypeID WHEN 1 THEN h.AssignmentType WHEN 3 THEN e.Data_Type_Display_3 END AS DATA_TYPE, 
                         --CASE a.FactTypeID WHEN 1 THEN 'N/A' WHEN 3 THEN e.Frequency END AS FREQUENCY_DESC, 
						 f.Date AS ASSESSMENT_DATE, 
                         CASE a.FactTypeID WHEN 1 THEN CAST(a.Assignment_Grade_Number AS varchar(100)) WHEN 3 THEN e.Score_3 END AS PERFORMANCE_VALUE, 
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
WHERE        a.FactTypeID = 3 AND e.Classification IN ('3', '4', '5')
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
                         CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score_4 END AS PERFORMANCE_VALUE, 
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
                         CASE a.FactTypeID WHEN 1 THEN a.Assignment_Entered_Grade WHEN 3 THEN e.Score_5 END AS PERFORMANCE_VALUE, 
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




GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[9] 4[6] 2[73] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -165
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1455
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2355
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2160
         Alias = 1950
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_5_RPT_CY_L_SCHOOL_PERFORMANCE_OLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_5_RPT_CY_L_SCHOOL_PERFORMANCE_OLD'
GO
