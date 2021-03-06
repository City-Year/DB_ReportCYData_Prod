USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_9_RPT_PERFORMANCE_LEVEL_SB]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_9_RPT_PERFORMANCE_LEVEL_SB]
AS
SELECT     b.CY_StudentID AS CYSCHOOLHOUSE_ID, b.StudentName AS STUDENT_NAME, e.Business_Unit AS SITE_NAME, e.SchoolName AS SCHOOL_NAME, b.Grade, 
                      e.Diplomas_Now AS DIPLOMAS_NOW_SCHOOL, d.MarkingPeriod AS INTERVAL, '' AS SKILL_ID, g.AssessmentName AS SKILL_DESCRIPTION, 
                      g.Data_Type_Display AS DATA_TYPE, c.IndicatorArea AS INDICATOR_DESC, f.Date AS ASSESSMENT_DATE, 'TRUE' AS IS_NUMERIC, CASE WHEN isnumeric(g.ADA) 
                      = 1 THEN g.ADA ELSE NULL END AS PERFORMANCE_VALUE_NUMERIC, g.ADA AS PERFORMANCE_VALUE_DISPLAY, '' AS LETTER_GRADE_RANK, 
                      '' AS LETTER_GRADE_RANK_NORM, g.Performance_Value_ID, g.Local_Benchmark AS SCALE_LOCAL, '' AS SCALE_EVAL, '' AS TAG_OG, '' AS TAG_AC, 
                      d.SchoolYear AS FISCAL_YEAR, '' AS SITE_ID, e.SchoolID AS SCHOOL_ID, c.IndicatorAreaID AS INDICATOR_ID, g.Created_By, g.Create_Date AS ENTRY_DATE, 
                      GETDATE() AS LAST_REFRESH
FROM         SDW_Prod.dbo.FactAll AS a INNER JOIN
                      SDW_Prod.dbo.DimStudent AS b ON a.StudentID = b.StudentID INNER JOIN
                      SDW_Prod.dbo.DimIndicatorArea AS c ON a.IndicatorAreaID = c.IndicatorAreaID INNER JOIN
                      SDW_Prod.dbo.DimGrade AS d ON a.GradeID = d.GradeID INNER JOIN
                      SDW_Prod.dbo.DimSchool AS e ON a.SchoolID = e.SchoolID INNER JOIN
                      SDW_Prod.dbo.DimDate AS f ON a.DateID = f.DateID INNER JOIN
                      SDW_Prod.dbo.DimAssessment AS g ON a.AssessmentID = g.AssessmentID INNER JOIN
                      SDW_Prod.dbo.DimAssignment AS h ON a.AssignmentID = h.AssignmentID
WHERE     (g.AssessmentType = 'Behavior')



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[37] 2[13] 3) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 354
               Bottom = 135
               Right = 559
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 597
               Bottom = 118
               Right = 768
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 120
               Left = 597
               Bottom = 232
               Right = 767
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 138
               Left = 267
               Bottom = 267
               Right = 464
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 205
               Left = 529
               Bottom = 334
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 44
         End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_9_RPT_PERFORMANCE_LEVEL_SB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         Begin Table = "h"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 378
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2190
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2505
         Alias = 2685
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_9_RPT_PERFORMANCE_LEVEL_SB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_9_RPT_PERFORMANCE_LEVEL_SB'
GO
