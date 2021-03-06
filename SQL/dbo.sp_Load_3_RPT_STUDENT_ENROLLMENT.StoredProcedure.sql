USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_3_RPT_STUDENT_ENROLLMENT]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_3_RPT_STUDENT_ENROLLMENT]
AS
BEGIN

SELECT  [STUDENT_ID]
      ,[PROG_DESC]
      ,[INDICATOR_AREA_DESC]
      ,Max([ENROLLED_DAYS]) AS ENROLLED_DAYS
      ,MIN([FIRST_INTERVENTION]) AS FIRST_INTERVENTION
      ,MAX([LAST_INTERVENTION]) AS LAST_INTERVENTION
      ,[CURRENTLY_ENROLLED]
      ,[INVALID_ENROLLMENT]
      ,[FISCAL_YEAR]
      ,[SITE_NAME]
      ,[SCHOOL_NAME]
      ,[SCHOOL_ID]
      ,[CYSCHOOLHOUSE_STUDENT_ID]
      ,[DIPLOMAS_NOW]
      ,[StudentName]

	  INTO #TABLE1
FROM
(SELECT d.StudentID as STUDENT_ID
	  , c.Name as StudentName
	  , c.ID
	  , LEFT(b.Name,CharIndex('-',b.Name,1)-1) AS PROG_DESC
	  , a.Section_IA AS INDICATOR_AREA_DESC
      , CASE WHEN  StuSec_End = '1900-01-01' THEN  DATEDIFF(dd,a.StuSect_Start,getdate()) 
			WHEN DATEDIFF(dd,a.StuSect_Start, ISNULL(a.StuSec_End, GETDATE())) < 0 THEN NULL 
			ELSE DATEDIFF(dd, StuSect_Start, ISNULL(a.StuSec_End, GETDATE())) 
	    END AS ENROLLED_DAYS
	  , a.StuSect_Start AS FIRST_INTERVENTION
      , a.StuSec_End AS LAST_INTERVENTION

      , CASE WHEN MAX(ISNULL(a.StuSec_End, GETDATE())) = Convert(Date,getdate(),21) THEN 'YES' 
			 WHEN MAX(ISNULL(a.StuSec_End, GETDATE())) = '1900-01-01' THEN 'YES' 
			 ELSE 'NO' 
		 END AS CURRENTLY_ENROLLED
	  , CASE WHEN a.StuSec_End = '1900-01-01' THEN 'NO'  
			 WHEN DATEDIFF(dd, a.StuSect_Start,ISNULL(a.StuSec_End, GETDATE())) < 0 THEN 'YES' 
			 WHEN DATEDIFF(dd, a.StuSect_Start, ISNULL(a.StuSec_End, GETDATE())) = 0 THEN 'Begin and Exit dates are Same' 
			 ELSE 'NO' 
	    END AS INVALID_ENROLLMENT
      , c.School_Year_Name__c FISCAL_YEAR
      , c.Location__c SITE_NAME
      , c.School_Name__c SCHOOL_NAME
      , e.SchoolID AS SCHOOL_ID
      , c.Student_Id__c [CYSCHOOLHOUSE_STUDENT_ID]
      , e.DIPLOMAS_NOW
      --, c.Name as StudentName
  FROM [SDW_Stage_Prod].[dbo].[vw_StudentSection_Active_EnrollmentTracking_Start_and_End] AS a INNER JOIN
  [SDW_Stage_Prod].[dbo].Section__c  AS b WITH(nolock) ON 
	a.Section__c = b.Id INNER JOIN
  [SDW_Stage_Prod].[dbo].Student__c AS c WITH(nolock) ON 
	a.student__c = c.Id LEFT JOIN 
  SDW_Prod.dbo.DimStudent AS d WITH(nolock) ON
	a.Student__c = d.StudentSF_ID LEFT JOIN
  SDW_Prod.dbo.DimSchool AS e WITH(nolock) ON
  	c.School__c = e.CYSch_SF_ID

	
  
  GROUP BY d.StudentID
	, b.Name,[Section_IA]
	, a.StuSec_End
	, a.StuSect_Start
	, c.School_Year_Name__c
	, c.Location__c
	, c.School_Name__c
	, e.SchoolID
	, e.Diplomas_Now
	, c.Student_Id__c
	, c.Name
	, c.ID)T2
	Group by T2.[STUDENT_ID]
      ,T2.[StudentName]
      ,T2.[ID]
      ,T2.[PROG_DESC]
      ,T2.[INDICATOR_AREA_DESC]
      ,T2.[CURRENTLY_ENROLLED]
      ,T2.[INVALID_ENROLLMENT]
      ,T2.[FISCAL_YEAR]
      ,T2.[SITE_NAME]
      ,T2.[SCHOOL_NAME]
      ,T2.[SCHOOL_ID]
      ,T2.[CYSCHOOLHOUSE_STUDENT_ID]
      ,T2.[DIPLOMAS_NOW]






--GET RID OF LAST INTERVENTION = 1900-01-01----------------------------------------------------------------------------------------------------------------------
update #TABLE1 set last_intervention = Convert(Date,getdate(),21) where last_intervention = '1900-01-01'


--SELECT MIN and MAX INTERVENTION DATES GROUPED BY Student_ID, PROG_DESC,INDICATOR_AREA_DESC-------------------------------------------------

SELECT Student_ID, PROG_DESC,INDICATOR_AREA_DESC,MIN(FIRST_INTERVENTION) AS MIN_INTERVENTION,MAX(LAST_INTERVENTION) AS MAX_INTERVENTION
INTO  #MIN_MAX_INTERVENTIONS
FROM #TABLE1 
GROUP BY Student_ID, PROG_DESC,INDICATOR_AREA_DESC


--CALCULATE DAYS ENROLLED---------------------------------------------------------------------------------------------------------------------

SELECT Student_ID, PROG_DESC,INDICATOR_AREA_DESC,MIN_INTERVENTION,MAX_INTERVENTION,DATEDIFF(dd,MIN_INTERVENTION,MAX_INTERVENTION) DAYS_ENROLLED
INTO   #CALC_DAYS_ENROLLED
FROM #MIN_MAX_INTERVENTIONS

--PICK UP DATA FROM #TABLE1 AND INSERT TO TABLE 3--------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]

INSERT INTO ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]
SELECT DISTINCT
	a.Student_ID, 
	a.PROG_DESC,
	a.INDICATOR_AREA_DESC,
	a.DAYS_ENROLLED,
	a.MIN_INTERVENTION,
	a.MAX_INTERVENTION,
	CASE WHEN MAX_INTERVENTION = Convert(Date,getdate(),21) THEN 'YES' ELSE 'NO' END AS CURRENTLY_ENROLLED,
	CASE WHEN DATEDIFF(dd,MIN_INTERVENTION,MAX_INTERVENTION) < 0 THEN 'YES'
		 WHEN DATEDIFF(dd,MIN_INTERVENTION,MAX_INTERVENTION) = 0 THEN 'Begin and Exit dates are Same'
		 ELSE 'NO' 
		 END AS INVALID_ENROLLMENT,
	b.FISCAL_YEAR,
	b.SITE_NAME,
	b.SCHOOL_NAME,
	b.SCHOOL_ID,
	b.CYSCHOOLHOUSE_STUDENT_ID,
	DIPLOMAS_NOW,
	STUDENTNAME
    
FROM #CALC_DAYS_ENROLLED a inner join #TABLE1 b 
							ON  a.Student_ID = b.Student_ID
							AND a.PROG_DESC = b.PROG_DESC
							AND a.INDICATOR_AREA_DESC = b.INDICATOR_AREA_DESC


--REMOVE DUPS CAUSED BY SPLIT SCHOOLS--------------------------------------------------------------------

--GET DUPS
select CYSCHOOLHOUSE_STUDENT_ID, program_desc, indicator_area_desc,count(*) cnt into  #DUPS from ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]
group by CYSCHOOLHOUSE_STUDENT_ID, program_desc, indicator_area_desc
having count(*) > 1


--SELECT DISTINCT ROWS INTO #DUPS
SELECT Distinct  a.STUDENT_ID, a.PROGRAM_DESC, a.INDICATOR_AREA_DESC, a.ENROLLED_DAYS, a.FIRST_INTERVENTION, a.LAST_INTERVENTION, a.CURRENTLY_ENROLLED, a.INVALID_ENROLLMENT, 
				a.FISCAL_YEAR, a.SITE_NAME, a.SCHOOL_NAME, a.CYSCHOOLHOUSE_STUDENT_ID, a.DIPLOMAS_NOW, StudentName 
INTO #DUP_FIX				 
FROM ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] a INNER JOIN #DUPS b
										ON  a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID 
										AND a.program_desc				= b.program_desc
										AND a.indicator_area_desc		= b.indicator_area_desc order by student_ID
 
 
--DELETE ROWS FROM TABLE3 FROM #DUPS 

DELETE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] 
FROM ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] a INNER JOIN #DUPS b 
										ON  a.CYSCHOOLHOUSE_STUDENT_ID	= b.CYSCHOOLHOUSE_STUDENT_ID 
										AND a.program_desc				= b.program_desc
										AND a.indicator_area_desc		= b.indicator_area_desc	

--INSERT ROWS BACK TO TABLE3 FROM #DUP_FIX
INSERT INTO ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] 
				(STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC, ENROLLED_DAYS,FIRST_INTERVENTION, LAST_INTERVENTION, CURRENTLY_ENROLLED, INVALID_ENROLLMENT, 
				FISCAL_YEAR, SITE_NAME, SCHOOL_NAME, CYSCHOOLHOUSE_STUDENT_ID,DIPLOMAS_NOW, StudentName) 
SELECT STUDENT_ID, PROGRAM_DESC, INDICATOR_AREA_DESC, ENROLLED_DAYS,FIRST_INTERVENTION, LAST_INTERVENTION, CURRENTLY_ENROLLED, INVALID_ENROLLMENT, 
				FISCAL_YEAR, SITE_NAME, SCHOOL_NAME, CYSCHOOLHOUSE_STUDENT_ID,DIPLOMAS_NOW, StudentName
FROM #DUP_FIX



--RENAME SPLIT SCHOOLS----------------------------------------------------


	SELECT CYSCHOOLHOUSE_STUDENT_ID,SCHOOL_NAME INTO #SPLIT_SCHOOLS FROM ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]
	WHERE SCHOOL_NAME  LIKE '%(%-%)%'
		 
	UPDATE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] SET
	SCHOOL_NAME = SUBSTRING(b.SCHOOL_NAME,0,CHARINDEX('(',b.SCHOOL_NAME,0))
	FROM ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] a inner join #SPLIT_SCHOOLS b ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
	WHERE a.SCHOOL_NAME LIKE '%(%-%)%'



--DELETE FROM TABLE WHERE  invalid_enrollment = 'YES'

DELETE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] WHERE INVALID_ENROLLMENT = 'YES'


/*

	update ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]  set SCHOOL_NAME = 'Hennigan Elementary School' where SCHOOL_NAME = 'Hennigan Elementary School (6-7)'
	update ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]  set SCHOOL_NAME = 'Father Keith B. Kenny' where SCHOOL_NAME = 'Father Keith B. Kenny (7-8)'
	update ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]  set SCHOOL_NAME = 'McKay K-8 School' where SCHOOL_NAME = 'McKay K-8 School (6-8)'
	update ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP]  set SCHOOL_NAME = 'Trotter Elementary School' where SCHOOL_NAME = 'Trotter Elementary School (6-7)'
	


--McKay K-8 School (6-8) 
DELETE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] 
from ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] a inner join #DUPS b ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
																		               and a.program_desc = b.program_desc
																					   and a.indicator_area_desc = b.indicator_area_desc
where a.School_ID = '303'  


--Hennigan Elementary School (6-7)
DELETE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] 
from ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] a inner join #DUPS b ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
																		               and a.program_desc = b.program_desc
																					   and a.indicator_area_desc = b.indicator_area_desc
where a.School_ID = '111'  


--Father Keith B. Kenny(7-8)
DELETE ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] 
from ReportCYData_Prod.[dbo].[3_RPT_STUDENT_ENROLLMENT_WIP] a inner join #DUPS b ON a.CYSCHOOLHOUSE_STUDENT_ID = b.CYSCHOOLHOUSE_STUDENT_ID
																		               and a.program_desc = b.program_desc
																					   and a.indicator_area_desc = b.indicator_area_desc
where a.School_ID = '88'  



	*/							 	


	

							
END 








GO
