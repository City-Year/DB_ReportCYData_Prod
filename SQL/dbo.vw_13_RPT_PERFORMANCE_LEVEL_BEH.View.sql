USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_13_RPT_PERFORMANCE_LEVEL_BEH]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_13_RPT_PERFORMANCE_LEVEL_BEH]
AS
SELECT     a.StudentID AS STUDENT_ID, c.Frequency AS FREQUENCY_PERIOD_ID, c.Time_Period AS INTERVAL, c.Number_of_Office_Referrals AS OFFICE_REFERRALS, 
                      c.Number_of_Detentions AS DETENTIONS, c.Number_of_Suspensions AS SUSPENSIONS, '' AS TOTAL_INCIDENTS, d.SchoolName AS SCHOOL_NAME, 
                      d.Business_Unit AS SITE_NAME, b.StudentName AS STUDENT_NAME, b.Grade AS STUDENT_GRADE, a.SchoolID AS SCHOOL_ID, '' AS SITE_ID, 
                      '' AS PERF_RUN_DATE, '' AS INTERVENTION_TIME, '' AS TAG, e.SchoolYear AS FISCAL_YEAR
FROM         SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                      SDW_Prod.dbo.DimStudent AS b WITH (nolock) ON a.StudentID = b.StudentID INNER JOIN
                      SDW_Prod.dbo.DimAssessment AS c WITH (nolock) ON a.AssessmentID = c.AssessmentID INNER JOIN
                      SDW_Prod.dbo.DimSchool AS d WITH (nolock) ON a.SchoolID = d.SchoolID INNER JOIN
                      SDW_Prod.dbo.DimGrade AS e WITH (nolock) ON a.GradeID = e.GradeID
WHERE     (c.AssessmentName = 'Time Based Behavior Tracker')




GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[38] 2[20] 3) )"
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
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 553
               Bottom = 114
               Right = 828
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 866
               Bottom = 114
               Right = 1038
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 1076
               Bottom = 99
               Right = 1227
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2040
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_13_RPT_PERFORMANCE_LEVEL_BEH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_13_RPT_PERFORMANCE_LEVEL_BEH'
GO
