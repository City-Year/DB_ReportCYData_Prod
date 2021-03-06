USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_1_RPT_STUDENT_MAIN]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_1_RPT_STUDENT_MAIN]
AS
SELECT   DISTINCT  
		a.StudentID AS STUDENT_ID, 
		b.CY_StudentID AS CYSCHOOLHOUSE_STUDENT_ID, 
		b.StudentSF_ID,
		b.StudentFirst_Name AS FIRST_NAME, 
		'' AS MIDDLE_NAME, 
		b.StudentLast_Name AS LAST_NAME, 
		'' AS REGION_ID, 
		c.Region AS REGION_NAME, 
		'' AS SITE_ID, 
		c.Business_Unit AS SITE_NAME, 
		a.SchoolID AS SCHOOL_ID, 
		c.CYCh_Account_# AS CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
		c.SchoolName AS SCHOOL_NAME, 
		CASE c.Diplomas_Now WHEN 'No' THEN 0 WHEN 'Yes' THEN 1 END AS DIPLOMAS_NOW_SCHOOL, 
		b.Gender, 
		b.Grade AS GRADE_ID, 
		b.Grade + 'th' AS GRADE_DESC, 
		e.CorpsMemberID AS PRIMARY_CM_ID, 
		e.CorpsMember_Name AS PRIMARY_CM_NAME, 
		c.CYCh_Account_# AS CYCHANNEL_ACCOUNT_NBR, 
		b.Attendance_IA, 
		b.ELA_IA, 
		b.Math_IA, 
		b.Behavior_IA, 
		d.SchoolYear AS FISCAL_YEAR, 
		b.ELL, 
		b.Ethnicity, 
		b.StudentDistrictID AS Student_District_ID, 
		c.CYSch_SF_ID AS CYSchoolhouse_School_ID,
		CASE WHEN f.IndicatorArea IN ('ELA','ELA/Literacy') THEN e.CorpsMemberID    END	AS ELA_PRIMARY_CM_ID,
		CASE WHEN f.IndicatorArea IN ('ELA','ELA/Literacy') THEN e.CorpsMember_Name END	AS ELA_PRIMARY_CM_NAME,
		CASE WHEN f.IndicatorArea = 'MATH'  THEN e.CorpsMemberID					END AS MATH_PRIMARY_CM_ID,
		CASE WHEN f.IndicatorArea = 'MATH'  THEN e.CorpsMember_Name			        END	AS MATH_PRIMARY_CM_NAME,
		CASE WHEN f.IndicatorArea = 'Attendance' THEN e.CorpsMemberID				END AS ATT_PRIMARY_CM_ID,
		CASE WHEN f.IndicatorArea = 'Attendance' THEN e.CorpsMember_Name		    END AS ATT_PRIMARY_CM_NAME,
		CASE WHEN f.IndicatorArea = 'Behavior' THEN e.CorpsMemberID					END AS BEH_PRIMARY_CM_ID,
		CASE WHEN f.IndicatorArea = 'Behavior' THEN e.CorpsMember_Name				END	AS BEH_PRIMARY_CM_NAME

FROM         SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                      SDW_Prod.dbo.DimStudent AS b WITH (nolock)		ON a.StudentID = b.StudentID INNER JOIN
                      SDW_Prod.dbo.DimSchool AS c WITH (nolock)			ON a.SchoolID = c.SchoolID INNER JOIN
                      SDW_Prod.dbo.DimGrade AS d WITH (nolock)			ON a.GradeID = d.GradeID INNER JOIN
					  SDW_Prod.dbo.DimCorpsMember AS e WITH (nolock)	ON a.CorpsMemberID = e.CorpsMemberID INNER JOIN 
					  SDW_Prod.dbo.DimIndicatorArea AS f WITH (nolock)  ON a.IndicatorAreaID = f.IndicatorAreaID




GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
               Bottom = 193
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 553
               Bottom = 221
               Right = 725
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 763
               Bottom = 99
               Right = 914
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
         Column = 1500
         Alias = 2565
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_1_RPT_STUDENT_MAIN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_1_RPT_STUDENT_MAIN'
GO
