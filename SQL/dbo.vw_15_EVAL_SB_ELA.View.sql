USE [ReportCYData_Prod]
GO
/****** Object:  View [dbo].[vw_15_EVAL_SB_ELA]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_15_EVAL_SB_ELA]
AS
SELECT        a.StudentID AS STUDENT_ID, '' AS CONFIGID, CAST((CASE WHEN b.ADA = 'N/A' THEN '0' ELSE b.ADA END) AS decimal(18, 2)) AS PERFORMANCE_VALUE_NUMERIC, 
                         b.Frequency AS PRE_INTERVAL, 
                         CASE WHEN b.AssessmentName = 'Craft and Structure:  Interpret words/phrases' THEN 'PRE_CS_INT_WRDS_PRS' WHEN b.AssessmentName = 'Craft and Structure: Analyze structure of texts'
                          THEN 'PRE_CS_ANL_STR_TXTS' WHEN b.AssessmentName = 'Craft and Structure: Assess point of view/purpose' THEN 'PRE_CS_ASS_PNT_VW_PUR' WHEN b.AssessmentName
                          = 'ELA Simulation' THEN 'PRE_ELA_SIM' WHEN b.AssessmentName = 'Integration of Knowledge and Ideas:  Integrate/evaluate content' THEN 'PRE_INT_KNW_IDA_INT_EVA_CON'
                          WHEN b.AssessmentName = 'Integration of Knowledge and Ideas: Analyze similar themes/topics' THEN 'PRE_INT_KNW_IDA_ANA_SIM_THEME_TOP' WHEN b.AssessmentName
                          = 'Integration of Knowledge and Ideas: Evaluate the argument' THEN 'PRE_INT_KNW_IDA_EVAL_ARG' WHEN b.AssessmentName = 'Key Ideas and Details: Analyze development of text'
                          THEN 'PRE_KEY_IDEA_DET_ANA_DEV_TXT' WHEN b.AssessmentName = 'Key Ideas and Details: Determine central ideas/themes ' THEN 'PRE_KEY_IDEA_DET_DTR_CEN_IDA_THEME'
                          WHEN b.AssessmentName = 'Key Ideas and Details: Read closely ' THEN 'PRE_KEY_IDEA_DET_READ_CLOSE' WHEN b.AssessmentName = 'Language: Vocabulary'
                          THEN 'PRE_LANG_VOCABUL' WHEN b.AssessmentName = 'Range of Reading and Level of Text Complexity' THEN 'PRE_RNGE_READ_LVL_TXT_CMPX' WHEN b.AssessmentName
                          = 'Know/apply grade-level phonics/word analysis skills in decoding words' THEN 'PRE_KNW_APP_GRD_LVL_PHON_WRD_ANA_SKL_DE_WRD' WHEN b.AssessmentName
                          = 'Read with sufficient accuracy/fluency to support comprehension' THEN 'PRE_RD_SUFF_ACCR_FLUEN_SUP_COM' ELSE NULL 
                         END AS SKILL_DESCRIPTION
FROM            SDW_Prod.dbo.FactAll AS a INNER JOIN
                         SDW_Prod.dbo.DimAssessment AS b ON a.AssessmentID = b.AssessmentID INNER JOIN
                         SDW_Prod.dbo.DimGrade AS d ON a.GradeID = d.GradeID
WHERE        (d.SchoolYear = '2014-2015') AND (a.IndicatorAreaID IN
                             (SELECT        IndicatorAreaID
                               FROM            SDW_Prod.dbo.DimIndicatorArea
                               WHERE        (IndicatorArea LIKE 'ELA/Literacy')))



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
               Right = 655
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 693
               Bottom = 118
               Right = 863
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
         Alias = 900
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_15_EVAL_SB_ELA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_15_EVAL_SB_ELA'
GO
