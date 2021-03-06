USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_0_RPT_ASSESSMENT_NUM]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_0_RPT_ASSESSMENT_NUM]
AS
SELECT DISTINCT 
                      b.Business_Unit AS SITE_NAME, '' AS SITE_ID, d.IndicatorArea AS INDICATOR_AREA, c.Local_Benchmark AS SCALE, c.AssessmentName AS ASSESSMENT_NAME, 
                      '' AS SCALE_NUM, e.SchoolYear AS FISCAL_YEAR, b.SchoolName AS SCHOOL_NAME, a.SchoolID AS SCHOOL_ID, c.Local_Benchmark AS NATIONAL_NORM_SCALE, 
                      CASE a.FactTypeID WHEN 1 THEN f.AssignmentType WHEN 3 THEN c.Data_Type_Display END AS DATA_TYPE
FROM         SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                      SDW_Prod.dbo.DimSchool AS b WITH (nolock) ON a.SchoolID = b.SchoolID INNER JOIN
                      SDW_Prod.dbo.DimAssessment AS c WITH (nolock) ON a.AssessmentID = c.AssessmentID INNER JOIN
                      SDW_Prod.dbo.DimIndicatorArea AS d WITH (nolock) ON a.IndicatorAreaID = d.IndicatorAreaID INNER JOIN
                      SDW_Prod.dbo.DimGrade AS e WITH (nolock) ON a.GradeID = e.GradeID INNER JOIN
                      SDW_Prod.dbo.DimAssignment AS f WITH (nolock) ON a.AssignmentID = f.AssignmentID
WHERE     (a.FactTypeID IN (1, 3))



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[36] 2[19] 3) )"
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
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 330
               Bottom = 114
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 540
               Bottom = 114
               Right = 815
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 853
               Bottom = 99
               Right = 1010
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 1048
               Bottom = 99
               Right = 1199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 1237
               Bottom = 114
               Right = 1410
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_0_RPT_ASSESSMENT_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7050
         Alias = 1695
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_0_RPT_ASSESSMENT_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_0_RPT_ASSESSMENT_NUM'
GO
