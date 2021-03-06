USE [ReportCYData_Prod]
GO
/****** Object:  Table [dbo].[15_EVAL_SB_ELA]    Script Date: 12/1/2016 9:27:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[15_EVAL_SB_ELA](
	[STUDENT_ID] [int] NOT NULL,
	[PRE_INTERVAL] [varchar](80) NULL,
	[PRE_CS_INT_WRDS_PRS] [float] NULL,
	[PRE_CS_ANL_STR_TXTS] [float] NULL,
	[PRE_CS_ASS_PNT_VW_PUR] [float] NULL,
	[PRE_ELA_SIM] [float] NULL,
	[PRE_INT_KNW_IDA_INT_EVA_CON] [float] NULL,
	[PRE_INT_KNW_IDA_ANA_SIM_THEME_TOP] [float] NULL,
	[PRE_INT_KNW_IDA_EVAL_ARG] [float] NULL,
	[PRE_KEY_IDEA_DET_ANA_DEV_TXT] [float] NULL,
	[PRE_KEY_IDEA_DET_DTR_CEN_IDA_THEME] [float] NULL,
	[PRE_KEY_IDEA_DET_READ_CLOSE] [float] NULL,
	[PRE_LANG_VOCABUL] [float] NULL,
	[PRE_RNGE_READ_LVL_TXT_CMPX] [float] NULL,
	[PRE_KNW_APP_GRD_LVL_PHON_WRD_ANA_SKL_DE_WRD] [float] NULL,
	[PRE_RD_SUFF_ACCR_FLUEN_SUP_COM] [float] NULL,
	[POST_INTERVAL] [varchar](80) NULL,
	[POST_CS_INT_WRDS_PRS] [float] NULL,
	[POST_CS_ANL_STR_TXTS] [float] NULL,
	[POST_CS_ASS_PNT_VW_PUR] [float] NULL,
	[POST_ELA_SIM] [float] NULL,
	[POST_INT_KNW_IDA_INT_EVA_CON] [float] NULL,
	[POST_INT_KNW_IDA_ANA_SIM_THEME_TOP] [float] NULL,
	[POST_INT_KNW_IDA_EVAL_ARG] [float] NULL,
	[POST_KEY_IDEA_DET_ANA_DEV_TXT] [float] NULL,
	[POST_KEY_IDEA_DET_DTR_CEN_IDA_THEME] [float] NULL,
	[POST_KEY_IDEA_DET_READ_CLOSE] [float] NULL,
	[POST_LANG_VOCABUL] [float] NULL,
	[POST_RNGE_READ_LVL_TXT_CMPX] [float] NULL,
	[POST_KNW_APP_GRD_LVL_PHON_WRD_ANA_SKL_DE_WRD] [float] NULL,
	[POST_RD_SUFF_ACCR_FLUEN_SUP_COM] [float] NULL,
	[SB_CS_INT_WRDS_PRS_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_CS_ANL_STR_TXTS_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_CS_ASS_PNT_VW_PUR_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_ELA_SIM_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_INT_KNW_IDA_INT_EVA_CON_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_INT_KNW_IDA_ANA_SIM_THEME_TOP_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_INT_KNW_IDA_EVAL_ARG_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_KEY_IDEA_DET_ANA_DEV_TXT_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_KEY_IDEA_DET_DTR_CEN_IDA_THEME_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_KEY_IDEA_DET_READ_CLOSE_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_LANG_VOCABUL_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_RNGE_READ_LVL_TXT_CMPX_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_KNW_APP_GRD_LVL_PHON_WRD_ANA_SKL_DE_WRD_PERF_LEVEL_CHANGE] [float] NULL,
	[SB_RD_SUFF_ACCR_FLUEN_SUP_COM_PERFORMANCE_LEVEL_CHANGE] [float] NULL,
	[SB_CS_INT_WRDS_PRS_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_CS_ANL_STR_TXTS_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_CS_ASS_PNT_VW_PUR_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_ELA_SIM_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_INT_KNW_IDA_INT_EVA_CON_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_INT_KNW_IDA_ANA_SIM_THEME_TOP_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_INT_KNW_IDA_EVAL_ARG_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_KEY_IDEA_DET_ANA_DEV_TXT_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_KEY_IDEA_DET_DTR_CEN_IDA_THEME_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_KEY_IDEA_DET_READ_CLOSE_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_LANG_VOCABUL_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_RNGE_READ_LVL_TXT_CMPX_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_KNW_APP_GRD_LVL_PHON_WRD_ANA_SKL_DE_WRD_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_RD_SUFF_ACCR_FLUEN_SUP_COM_GRADE_CHANGE_ACTUAL] [varchar](50) NULL,
	[SB_CS_INT_WRDS_PRS_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_CS_ANL_STR_TXTS_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_CS_ASS_PNT_VW_PUR_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_ELA_SIM_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_INT_KNW_IDA_INT_EVA_CON_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_INT_KNW_IDA_ANA_SIM_THEME_TOP_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_INT_KNW_IDA_EVAL_ARG_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_KEY_IDEA_DET_ANA_DEV_TXT_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_KEY_IDEA_DET_DTR_CEN_IDA_THEME_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_KEY_IDEA_DET_READ_CLOSE_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_LANG_VOCABUL_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_RNGE_READ_LVL_TXT_CMPX_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_KNW_APP_GRD_LVL_PHON_WRD_ANA_SKL_DE_WRD_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[SB_RD_SUFF_ACCR_FLUEN_SUP_COM_GRADE_CHANGE_DEGREE] [varchar](50) NULL,
	[CURRENTLY_ENROLLED] [varchar](50) NULL,
	[ENROLLED_DAYS] [int] NULL,
	[ENROLLED_DAYS_CATEGORIES] [varchar](50) NULL,
	[TTL_TIME] [int] NULL,
	[DOSAGE_CATEGORIES] [varchar](50) NULL,
	[STATUS_SITE_DOSAGE_GOAL] [int] NULL,
	[SITE_DOSAGE_GOAL] [int] NULL,
	[Attendance_IA] [varchar](1) NULL,
	[ELA_IA] [varchar](1) NULL,
	[Math_IA] [varchar](1) NULL,
	[Behavior_IA] [varchar](1) NULL,
	[FISCAL_YEAR] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
