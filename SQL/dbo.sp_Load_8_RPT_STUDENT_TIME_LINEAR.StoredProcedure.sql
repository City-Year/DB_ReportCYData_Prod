USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_8_RPT_STUDENT_TIME_LINEAR]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_8_RPT_STUDENT_TIME_LINEAR]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	


--TABLE 8 ------------------------------------------------------------------------------------

	truncate table ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] 

	insert into ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR](STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC, TTL_TIME, FISCAL_YEAR, CYSCHOOLHOUSE_STUDENT_ID, SITE_NAME, SCHOOL_NAME, SCHOOL_ID)
	select StudentID, ProgramDescription, IndicatorArea, TTL_Time, SchoolYear, CY_StudentID, SITE_NAME, SCHOOL_NAME, '' as SCHOOL_ID from ReportCYData_Prod.dbo.vw_8_RPT_STUDENT_TIME_LINEAR
	

	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '0-4.99 hours' where TTL_TIME between 0 and 299
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '5-9.99 hours' where TTL_TIME >= 300 and TTL_TIME < 600
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '10-14.99 hours' where TTL_TIME >= 600 and TTL_TIME < 900
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '15-19.99 hours' where TTL_TIME >= 900 and TTL_TIME < 1200
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '20-24.99 hours' where TTL_TIME >= 1200 and TTL_TIME < 1500
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '25-34.99 hours' where TTL_TIME >= 1500 and TTL_TIME < 2100
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '35 to 49.99 hours' where TTL_TIME >= 2100 and TTL_TIME < 3000
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set Dosage_Category = '50+ hours' where TTL_TIME >= 3000

	--SPLIT SCHOOL UPDATE 
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Hennigan Elementary School' where school_name = 'Hennigan Elementary School (6-7)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Father Keith B. Kenny' where school_name = 'Father Keith B. Kenny (7-8)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'McKay K-8 School' where school_name = 'McKay K-8 School (6-8)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Higginson Lewis K-8 School' where school_name = 'Higginson Lewis K-8 School (6-8)'
	update ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] set SCHOOL_NAME = 'Mildred Ave K-8 School' where school_name = 'Mildred Ave K-8 School (6-8)'



	--FIND DUPS

	SELECT STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC,count(*) count  INTO #DUPS from ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR]
	group by STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC
	having count(*) > 1

	
	--SELECT DISTINCT DUPLICATE RECORDS TO #DISTINCT_DUPS

	SELECT DISTINCT a.STUDENT_ID,a.PROGRAM_DESC, a.INDICATOR_AREA_DESC,a.DOSAGE_CATEGORY,a.TTL_TIME,a.FISCAL_YEAR,a.CYSCHOOLHOUSE_STUDENT_ID, a.SITE_NAME,a.SCHOOL_NAME
	INTO #DISTINCT_DUPS
	FROM  ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] a INNER JOIN #DUPS b  ON a.student_ID = b.STUDENT_ID
																				 AND a.PROGRAM_DESC = b.PROGRAM_DESC
																				 AND a.INDICATOR_AREA_DESC = b.INDICATOR_AREA_DESC
	--DELETE ALL DUPLICATE RECORDS FROM [8_RPT_STUDENT_TIME_LINEAR]

	DELETE ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR]
    FROM ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] a inner join #DUPS b 
	                                                         on a.STUDENT_ID = b.STUDENT_ID
															 and a.PROGRAM_DESC = b.PROGRAM_DESC
															 and a.INDICATOR_AREA_DESC = b.INDICATOR_AREA_DESC 	 

	--INSERT DISTINCT RECORDS BACK TO [8_RPT_STUDENT_TIME_LINEAR]

	INSERT INTO ReportCYData_Prod.dbo.[8_RPT_STUDENT_TIME_LINEAR] (STUDENT_ID,PROGRAM_DESC,INDICATOR_AREA_DESC,DOSAGE_CATEGORY,TTL_TIME,FISCAL_YEAR,CYSCHOOLHOUSE_STUDENT_ID,SITE_NAME,SCHOOL_NAME,SCHOOL_ID)
	SELECT STUDENT_ID,PROGRAM_DESC,INDICATOR_AREA_DESC,DOSAGE_CATEGORY,TTL_TIME,FISCAL_YEAR,CYSCHOOLHOUSE_STUDENT_ID,SITE_NAME,SCHOOL_NAME,'' 
	FROM #DISTINCT_DUPS

	


END





GO
