USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_3_RPT_STUDENT_ENROLLMENT]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vw_3_RPT_STUDENT_ENROLLMENT]
AS
SELECT        
a.StudentID AS STUDENT_ID, 
e.ProgramDescription AS PROGRAM_DESCRIPTION, 
c.IndicatorArea AS INDICATOR_AREA_DESC, 

CASE WHEN  d.Enrollment_END_DATE = '1900-01-01' THEN  DATEDIFF(dd,d.Enrollment_DATE,getdate()) 
	 WHEN DATEDIFF(dd,d.Enrollment_DATE, ISNULL(d.Enrollment_END_DATE, GETDATE())) < 0 THEN NULL 
	 ELSE DATEDIFF(dd, d.Enrollment_DATE, ISNULL(d.Enrollment_END_DATE, 
                         GETDATE())) END AS ENROLLED_DAYS,

MIN(d.Enrollment_Date) AS BEGIN_DATE_USED,

CASE WHEN MAX(d.Enrollment_End_Date) = '1900-01-01' THEN Convert(Date,getdate(),21)
     ELSE MAX(ISNULL(d.Enrollment_End_Date, GETDATE())) 
	 END AS END_DATE_USED, 

--CASE WHEN d.Enrollment_END_DATE = '1900-01-01' THEN 'YES' ELSE 'NO' END AS CURRENTLY_ENROLLED, 

CASE WHEN MAX(ISNULL(d.Enrollment_End_Date, GETDATE())) = Convert(Date,getdate(),21) THEN 'YES' 
	 WHEN MAX(ISNULL(d.Enrollment_End_Date, GETDATE())) = '1900-01-01' THEN 'YES' 
ELSE 'NO' END AS CURRENTLY_ENROLLED, 

CASE WHEN d.Enrollment_END_DATE = '1900-01-01' THEN 'NO'  
	 WHEN DATEDIFF(dd, d.Enrollment_DATE,ISNULL(d.Enrollment_END_DATE, GETDATE())) < 0 THEN 'YES' 
	 WHEN DATEDIFF(dd, d.Enrollment_DATE, ISNULL(d.Enrollment_END_DATE, GETDATE())) = 0 THEN 'Begin and Exit dates are Same' 
     ELSE 'NO' 
END AS INVALID_ENROLLMENT, 

						 f.SchoolYear AS FISCAL_YEAR, g.Business_Unit AS SITE_NAME, 
                         g.SchoolName AS SCHOOL_NAME, a.SchoolID AS SCHOOL_ID, d.CY_StudentID AS CYSCHOOLHOUSE_STUDENT_ID, g.Diplomas_Now,d.StudentName

FROM            SDW_Prod.dbo.FactAll AS a INNER JOIN
                         SDW_Prod.dbo.DimProgram AS b ON a.ProgramID = b.ProgramID INNER JOIN
                         SDW_Prod.dbo.DimIndicatorArea AS c ON a.IndicatorAreaID = c.IndicatorAreaID INNER JOIN
                         SDW_Prod.dbo.DimStudent AS d ON a.StudentID = d.StudentID INNER JOIN
                         SDW_Prod.dbo.DimAssignment AS e ON a.AssignmentID = e.AssignmentID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS f ON a.GradeID = f.GradeID INNER JOIN
                         SDW_Prod.dbo.DimSchool AS g WITH (nolock) ON a.SchoolID = g.SchoolID
GROUP BY a.StudentID, e.ProgramDescription, c.IndicatorArea, d.Enrollment_Date, d.Enrollment_End_Date, f.SchoolYear, g.Business_Unit, g.SchoolName, a.SchoolID, 
                         d.CY_StudentID, a.FactTypeID, g.Diplomas_Now,d.StudentName
HAVING        (a.FactTypeID = 2)
AND d.Enrollment_date IS NOT NULL




GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[27] 2[5] 3) )"
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
               Bottom = 135
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 370
               Bottom = 101
               Right = 556
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 594
               Bottom = 118
               Right = 781
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 102
               Left = 370
               Bottom = 231
               Right = 591
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 120
               Left = 629
               Bottom = 249
               Right = 840
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 250
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 6
               Left = 819
               Bottom = 114
               Right = 1007
            End
            DisplayFlags = 280
            TopColumn = 0
         End
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_3_RPT_STUDENT_ENROLLMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   End
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 2175
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_3_RPT_STUDENT_ENROLLMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_3_RPT_STUDENT_ENROLLMENT'
GO
