USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_5_RPT_CY_L_SCHOOL_PERFORMANCE]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_5_RPT_CY_L_SCHOOL_PERFORMANCE]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	

--TABLE 5 ------------------------------------------------------------------------------------

	truncate table ReportCYData_Prod.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE]

	select INDICATOR_DESC, SITE_NAME, SCHOOL_NAME, STUDENT_NAME, SKILL_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, ENTRY_DATE, CREATE_BY, FISCAL_YEAR, DIPLOMAS_NOW, STudentID, CY_StudentID, DATA_TYPE, GRADE, SKILL_DESC Placeholder
	into #TempTable5
	from ReportCYData_Prod.dbo.vw_5_RPT_CY_L_SCHOOL_PERFORMANCE (nolock)

	update 	#TempTable5
	set Placeholder = SKILL_DESC
	where DATA_TYPE like '%Course%Grade%' or Indicator_Desc = 'Attendance'


	update #TempTable5 set INDICATOR_DESC = NULL Where SKILL_DESC like '%Attendance%'   --ADDED so that skill_desc not updated to DataTyp 
																						--for Attendance	

	update #TempTable5
	set SKILL_DESC = DATA_TYPE
	where DATA_TYPE like '%Course%Grade%' or Indicator_Desc = 'Attendance'

	update #TempTable5
	set DATA_TYPE = Placeholder
	where DATA_TYPE like '%Course%Grade%' or Indicator_Desc = 'Attendance'

	insert into ReportCYData_Prod.dbo.[5_RPT_CY_L_SCHOOL_PERFORMANCE](INDICATOR_AREA_DESC, SITE_NAME, SCHOOL_NAME, STUDENT_NAME, SKILL_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, ENTRY_DATE, CREATED_BY, FISCAL_YEAR, DIPLOMAS_NOW_SCHOOL, STUDENT_ID, CYSCHOOLHOUSE_STUDENT_ID, DATA_TYPE, GRADE)
	select INDICATOR_DESC, SITE_NAME, SCHOOL_NAME, STUDENT_NAME, SKILL_DESC, ASSESSMENT_DATE, PERFORMANCE_VALUE, ENTRY_DATE, CREATE_BY, FISCAL_YEAR, DIPLOMAS_NOW, STudentID, CY_StudentID, DATA_TYPE, GRADE from #TempTable5 (nolock)



END



GO
