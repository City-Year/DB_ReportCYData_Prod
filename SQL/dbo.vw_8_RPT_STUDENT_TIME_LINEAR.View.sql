USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_8_RPT_STUDENT_TIME_LINEAR]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_8_RPT_STUDENT_TIME_LINEAR]
AS
SELECT     a.StudentID, b.ProgramDescription, c.IndicatorArea, '' AS Dosage_Category, SUM(ISNULL(a.Session_Dosage, 0)) AS TTL_TIME, d.SchoolYear, e.CY_StudentID, 
                      f.Business_Unit AS SITE_NAME, '' AS SITE_ID, f.SchoolName AS SCHOOL_NAME, f.SchoolID AS SCHOOL_ID
FROM         SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                      SDW_Prod.dbo.DimAssignment AS b WITH (nolock) ON a.AssignmentID = b.AssignmentID INNER JOIN
                      SDW_Prod.dbo.DimIndicatorArea AS c WITH (nolock) ON a.IndicatorAreaID = c.IndicatorAreaID INNER JOIN
                      SDW_Prod.dbo.DimGrade AS d WITH (nolock) ON a.GradeID = d.GradeID INNER JOIN
                      SDW_Prod.dbo.DimStudent AS e WITH (nolock) ON a.StudentID = e.StudentID INNER JOIN
                      SDW_Prod.dbo.DimSchool AS f WITH (nolock) ON a.SchoolID = f.SchoolID
GROUP BY a.StudentID, b.ProgramDescription, c.IndicatorArea, d.SchoolYear, e.CY_StudentID, f.Business_Unit, f.SchoolName, f.SchoolID, a.FactTypeID
HAVING      (a.FactTypeID = 2)



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[28] 2[20] 3) )"
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
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 346
               Bottom = 114
               Right = 535
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 573
               Bottom = 99
               Right = 746
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 784
               Bottom = 99
               Right = 951
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 989
               Bottom = 114
               Right = 1190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 1228
               Bottom = 246
               Right = 1416
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
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 1350
         Table = 1170
         O' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_8_RPT_STUDENT_TIME_LINEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'utput = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_8_RPT_STUDENT_TIME_LINEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_8_RPT_STUDENT_TIME_LINEAR'
GO
