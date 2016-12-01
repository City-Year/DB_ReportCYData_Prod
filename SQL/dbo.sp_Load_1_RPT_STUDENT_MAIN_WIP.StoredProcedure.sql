USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_1_RPT_STUDENT_MAIN_WIP]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[sp_Load_1_RPT_STUDENT_MAIN_WIP]
AS
BEGIN



Select 
 a.StudentID
,a.CY_StudentID
,a.StudentSF_ID
--,a.StudentName
,a.StudentFirst_Name
,'' middle_name
,a.StudentLast_Name
, '' as region_ID
,C.REGION  as region_name
,c.business_unit  as site_name
,c.SchoolID
,c.CYCh_Account_#   AS  CYCHANNEL_SCHOOL_ACCOUNT_NBR
,c.SchoolName
,c.Diplomas_Now
,a.Gender
,a.Grade
,a.Grade + 'th' AS GRADE_DESC
,'' AS PRIMARY_CM_ID
,'' AS PRIMARY_CM_NAME
,a.Attendance_IA
,a.ELA_IA
,a.Math_IA
,a.Behavior_IA
,b.school_year_name__c    --case when f.schoolyear is null then 'N/A' else f.schoolyear end as FISCAL_YEAR
,a.ELL
,a.Ethnicity
,a.StudentDistrictID AS STUDENT_DISTRICT_ID
,c.CYSch_SF_ID AS cyschoolhouse_SCHOOL_ID
,'     ' AS [ELA_PRIMARY_CM_ID]
,'                        ' AS [ELA_PRIMARY_CM_SF_ID]
,'                                                                                               ' AS [ELA_PRIMARY_CM_NAME]
,'                                                                                               ' AS [ELA_PRIMARY_CM_EMAIL]
,'	   ' AS [MATH_PRIMARY_CM_ID]
,'	                      ' AS [MATH_PRIMARY_CM_SF_ID]
,'                                                                                               ' AS [MATH_PRIMARY_CM_NAME]
,'                                                                                               ' AS [MATH_PRIMARY_CM_EMAIL]
,'     ' AS [ATT_PRIMARY_CM_ID]
,'                        ' AS [ATT_PRIMARY_CM_SF_ID]
,'                                                                                               ' AS [ATT_PRIMARY_CM_NAME]
,'                                                                                               ' AS [ATT_PRIMARY_CM_EMAIL]
,'     ' AS [BEH_PRIMARY_CM_ID]
,'                        ' AS [BEH_PRIMARY_CM_SF_ID]
,'                                                                                               ' AS [BEH_PRIMARY_CM_NAME]
,'                                                                                               ' AS [BEH_PRIMARY_CM_EMAIL]







--, DateOfBirth
--, StudentName_Display, Enrollment_Date, Enrollment_End_Date
--,c.Region
--,b.Gender__c
--,b.Ethnicity__c
--,b.ELL__c
--,b.Math__c

--,b.ELA_Literacy__c
--,b.Behavior__c
--,''
--,''
--,''
--,''
--,g.StaffID1

INTO #TABLE1


From SDW_Prod.dbo.DimStudent		as a										INNER JOIN
	 SDW_Stage_Prod.dbo.Student__c	as b  ON a.StudentSF_ID  = b.Id				INNER JOIN
	 SDW_Prod.dbo.DimSchool			as c  ON b.School__c     = c.CYSch_SF_ID	LEFT JOIN
	 SDW_Prod.dbo.FactAll			as d  ON a.StudentID     = d.StudentID		LEFT JOIN
	 SDW_Prod.dbo.DimCorpsMember	as e  ON d.CorpsMemberID = e.CorpsMemberID	LEFT JOIN
	 SDW_Prod.dbo.DimGrade			as f  ON d.GradeID       = f.GradeID  


GROUP BY
 a.StudentID
,a.CY_StudentID
,a.StudentSF_ID
--,a.StudentName
,a.StudentFirst_Name
--,'' middle_name
,a.StudentLast_Name
,C.REGION
--,''  as region_name
,c.business_unit
,c.SchoolID
,c.CYCh_Account_#   
,c.SchoolName
,c.Diplomas_Now
,a.Gender
,a.Grade
--,'' AS PRIMARY_CM_ID
--,'' AS PRIMARY_CM_NAME
,a.Attendance_IA
,a.ELA_IA
,a.Math_IA
,a.Behavior_IA
,b.school_year_name__c        --f.schoolyear 
,a.ELL
,a.Ethnicity
,a.StudentDistrictID
,c.CYSch_SF_ID
--,'     ' AS [ELA_PRIMARY_CM_ID]
--,'                                                                                               ' AS [ELA_PRIMARY_CM_NAME]
--,'	   ' AS [MATH_PRIMARY_CM_ID]
--,'                                                                                               ' AS [MATH_PRIMARY_CM_NAME]
--,'     ' AS [ATT_PRIMARY_CM_ID]
--,'                                                                                               ' AS [ATT_PRIMARY_CM_NAME]
--,'     ' AS [BEH_PRIMARY_CM_ID]
--,'                                                                                               ' AS [BEH_PRIMARY_CM_NAME]
--, DateOfBirth
--, StudentName_Display, Enrollment_Date, Enrollment_End_Date
--,c.Region
--,b.Gender__c
--,b.Ethnicity__c
--,b.ELL__c
--,b.Math__c

--,b.ELA_Literacy__c
--,b.Behavior__c
--,''
--,''
--,''
--,''
--,g.StaffID1




--ELA------------------------------------------------------------------------------------------------------

--SUM DOSAGE,  COUNT NUMBER OF SESSIONS INTO #ELA

SELECT  d.CorpsMember_Name,
		d.CorpsMemberID,
		d.CorpsMember_ID,
		a.studentID,
		SUM(b.session_dosage)   SUM_SESSION_DOSAGE, 
		COUNT(CorpsMember_Name) COUNT_OF_SESSIONS
		INTO  #ELA
		FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b			ON  a.StudentID		  = b.StudentID
						INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
						INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
		WHERE c.IndicatorArea IN ('ELA','ELA/Literacy') and d.CorpsMember_Name <> 'N/A'
		GROUP BY a.studentID,d.CorpsMember_Name,d.CorpsMemberID,d.CorpsMember_ID 
		ORDER BY StudentID
	

	

--UPDATE WHERE MAX_SUM_SESSION_DOSAGE'S ARE THE SAME FOR DIFFERENT CORPS MEMBERS AND WE NEED MAX_COUNT_OF_SESSIONS TO BREAK THE TIE.
	 
 UPDATE #TABLE1 SET
	ELA_PRIMARY_CM_ID	= c.CorpsMemberID,
	ELA_PRIMARY_CM_SF_ID = c.CorpsMember_ID,	
	ELA_PRIMARY_CM_NAME	=  c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #ELA 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #ELA c	ON  b.studentID = c.studentID
							AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
							AND b.max_COUNT_OF_SESSIONS  = c.COUNT_OF_SESSIONS


--UPDATE WHERE THE MAX_SUM_SESSION_DOSAGE'S ARE NOT THE SAME AND ELA_PRIMARY_CM_ID,ELA_PRIMARY_CM_SF_ID,ELA_PRIMARY_CM_NAME ARE BLANK TO 
--BE SURE VALUES IN THESE FIELDS ARE NOT OVER WRITTEN 

UPDATE #TABLE1 SET
	ELA_PRIMARY_CM_ID	= c.CorpsMemberID,
	ELA_PRIMARY_CM_SF_ID = c.CorpsMember_ID,	
	ELA_PRIMARY_CM_NAME	=  c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #ELA 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #ELA c	ON  b.studentID = c.studentID
							AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE

		WHERE  	ELA_PRIMARY_CM_ID		= ''
		AND     ELA_PRIMARY_CM_SF_ID	= ''
		AND     ELA_PRIMARY_CM_NAME		= ''				

							
/*
UPDATE #table1 SET
ELA_PRIMARY_CM_ID	=	d.CorpsMemberID,
ELA_PRIMARY_CM_NAME	=   d.CorpsMember_Name
FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENTID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea IN ('ELA','ELA/Literacy')
*/



--MATH------------------------------------------------------------------------------------------------------

SELECT  d.CorpsMember_Name,
		d.CorpsMemberID,
		d.CorpsMember_ID,
		a.studentID,
		SUM(b.session_dosage)   SUM_SESSION_DOSAGE, 
		COUNT(CorpsMember_Name) COUNT_OF_SESSIONS
		INTO #MATH
		FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b			ON  a.StudentID		  = b.StudentID
						INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
						INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
		WHERE c.IndicatorArea IN ('MATH') and d.CorpsMember_Name <> 'N/A'
		GROUP BY a.studentID,d.CorpsMember_Name,d.CorpsMemberID,d.CorpsMember_ID 
		ORDER BY StudentID


UPDATE #TABLE1 SET
	MATH_PRIMARY_CM_ID	= c.CorpsMemberID,
	MATH_PRIMARY_CM_SF_ID = c.CorpsMember_ID,
	MATH_PRIMARY_CM_NAME	= c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #MATH 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #MATH c	ON  b.studentID = c.studentID
							AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
							AND b.max_COUNT_OF_SESSIONS  = c.COUNT_OF_SESSIONS


UPDATE #TABLE1 SET
	MATH_PRIMARY_CM_ID	= c.CorpsMemberID,
	MATH_PRIMARY_CM_SF_ID = c.CorpsMember_ID,
	MATH_PRIMARY_CM_NAME	= c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #MATH 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #MATH c	ON  b.studentID = c.studentID
							AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
							
WHERE MATH_PRIMARY_CM_ID		= ''
AND   MATH_PRIMARY_CM_SF_ID		= ''
AND   MATH_PRIMARY_CM_NAME		= ''

/* OLD CODE
UPDATE #table1 SET
MATH_PRIMARY_CM_ID		= d.CorpsMemberID,
MATH_PRIMARY_CM_NAME	= d.CorpsMember_Name

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENTID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea =  'MATH'   
*/

--ATTENDANCE-------------------------------------------------------------------------------------------------------

SELECT  d.CorpsMember_Name,
		d.CorpsMemberID,
		d.CorpsMember_ID,
		a.studentID,
		SUM(b.session_dosage)   SUM_SESSION_DOSAGE, 
		COUNT(CorpsMember_Name) COUNT_OF_SESSIONS
		INTO #ATTENDANCE
		FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b			ON  a.StudentID		  = b.StudentID
						INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
						INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
		WHERE c.IndicatorArea IN ('ATTENDANCE') and d.CorpsMember_Name <> 'N/A'
		GROUP BY a.studentID,d.CorpsMember_Name,d.CorpsMemberID,d.CorpsMember_ID
		ORDER BY StudentID


UPDATE #TABLE1 SET
	ATT_PRIMARY_CM_ID	= c.CorpsMemberID,
	ATT_PRIMARY_CM_SF_ID = c.CorpsMember_ID,	
	ATT_PRIMARY_CM_NAME	= c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #ATTENDANCE 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #ATTENDANCE c	ON  b.studentID = c.studentID
									AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
									AND b.max_COUNT_OF_SESSIONS  = c.COUNT_OF_SESSIONS



UPDATE #TABLE1 SET
	ATT_PRIMARY_CM_ID	= c.CorpsMemberID,
	ATT_PRIMARY_CM_SF_ID = c.CorpsMember_ID,	
	ATT_PRIMARY_CM_NAME	= c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #ATTENDANCE 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #ATTENDANCE c	ON  b.studentID = c.studentID
									AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
WHERE 	ATT_PRIMARY_CM_ID		= ''						
AND     ATT_PRIMARY_CM_SF_ID	= ''
AND     ATT_PRIMARY_CM_NAME		= ''




/* OLD CODE
UPDATE #table1 SET
ATT_PRIMARY_CM_ID		= d.CorpsMemberID,
ATT_PRIMARY_CM_NAME		= d.CorpsMember_Name

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENTID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea =  'ATTENDANCE'   
*/
--BEHAVIOR---------------------------------------------------------------------------------------------------------

SELECT  d.CorpsMember_Name,
		d.CorpsMemberID,
		d.CorpsMember_ID,
		a.studentID,
		SUM(b.session_dosage)   SUM_SESSION_DOSAGE, 
		COUNT(CorpsMember_Name) COUNT_OF_SESSIONS
		INTO #BEHAVIOR
		FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b			ON  a.StudentID		  = b.StudentID
						INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
						INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
		WHERE c.IndicatorArea IN ('BEHAVIOR') and d.CorpsMember_Name <> 'N/A'
		GROUP BY a.studentID,d.CorpsMember_Name,d.CorpsMemberID,d.CorpsMember_ID
		ORDER BY StudentID


UPDATE #TABLE1 SET
	BEH_PRIMARY_CM_ID	= c.CorpsMemberID,
	BEH_PRIMARY_CM_SF_ID = c.CorpsMember_ID,	
	BEH_PRIMARY_CM_NAME	= c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #BEHAVIOR 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #BEHAVIOR c	ON  b.studentID = c.studentID
									AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
									AND b.max_COUNT_OF_SESSIONS  = c.COUNT_OF_SESSIONS

UPDATE #TABLE1 SET
	BEH_PRIMARY_CM_ID	= c.CorpsMemberID,
	BEH_PRIMARY_CM_SF_ID = c.CorpsMember_ID,	
	BEH_PRIMARY_CM_NAME	= c.CorpsMember_Name
 FROM #TABLE1 a INNER JOIN 
		(
		select studentID, MAX(sum_session_dosage) max_sum_session_dosage,MAX(COUNT_OF_SESSIONS) max_count_of_sessions 
		from #BEHAVIOR 
		group by studentID 
		) b
		ON a.studentID = b.StudentID 
		INNER JOIN #BEHAVIOR c	ON  b.studentID = c.studentID
									AND b.max_sum_session_dosage = c.SUM_SESSION_DOSAGE
WHERE 	BEH_PRIMARY_CM_ID		= ''							
AND     BEH_PRIMARY_CM_SF_ID	= ''
AND     BEH_PRIMARY_CM_NAME		= ''




/*
UPDATE #table1 SET
BEH_PRIMARY_CM_ID		= d.CorpsMemberID,
BEH_PRIMARY_CM_NAME  	= d.CorpsMember_Name

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENTID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea = 'BEHAVIOR'  
*/

--REMOVE DUPLICATES CAUSED BY SPLIT SCHOOLS------------------------------------------------------------------------
   
	SELECT CY_StudentID, count(*) cnt INTO  #dups FROM #table1
	WHERE SchoolName <> 'PS-MS 206M (6-8)'
	GROUP BY CY_StudentID
	HAVING count(*) > 1
		
	SELECT DISTINCT A.STUDENTID,A.CY_STUDENTID,A.STUDENTSF_ID,A.STUDENTFIRST_NAME,A.MIDDLE_NAME,A.STUDENTLAST_NAME,A.REGION_ID,A.REGION_NAME,A.SITE_NAME,A.CYCHANNEL_SCHOOL_ACCOUNT_NBR,
					A.SCHOOLNAME,A.DIPLOMAS_NOW,A.GENDER,A.GRADE,A.GRADE_DESC,A.PRIMARY_CM_ID,A.PRIMARY_CM_NAME,A.ATTENDANCE_IA,A.ELA_IA,A.MATH_IA,A.BEHAVIOR_IA,A.SCHOOL_YEAR_NAME__C,
					A.ELL,A.ETHNICITY,A.STUDENT_DISTRICT_ID,A.CYSCHOOLHOUSE_SCHOOL_ID,A.ELA_PRIMARY_CM_ID,A.ELA_PRIMARY_CM_NAME,A.MATH_PRIMARY_CM_ID,A.MATH_PRIMARY_CM_NAME,
					A.ATT_PRIMARY_CM_ID,A.ATT_PRIMARY_CM_NAME,A.BEH_PRIMARY_CM_ID,A.BEH_PRIMARY_CM_NAME 
	INTO #FIX_DUPS 
	FROM #table1 a inner join #dups  b ON a.CY_StudentID = b.CY_StudentID  WHERE schoolname NOT LIKE '%(%-%)%' 
	
	DELETE #table1 FROM #table1 a inner join #dups b ON a.CY_StudentID = b.CY_StudentID

	INSERT INTO #table1 (STUDENTID,CY_STUDENTID,STUDENTSF_ID,STUDENTFIRST_NAME,MIDDLE_NAME,STUDENTLAST_NAME,REGION_ID,REGION_NAME,SITE_NAME,SCHOOLID,CYCHANNEL_SCHOOL_ACCOUNT_NBR,
					SCHOOLNAME,DIPLOMAS_NOW,GENDER,GRADE,GRADE_DESC,PRIMARY_CM_ID,PRIMARY_CM_NAME,ATTENDANCE_IA,ELA_IA,MATH_IA,BEHAVIOR_IA,SCHOOL_YEAR_NAME__C,
					ELL,ETHNICITY,STUDENT_DISTRICT_ID,CYSCHOOLHOUSE_SCHOOL_ID,ELA_PRIMARY_CM_ID,ELA_PRIMARY_CM_NAME,MATH_PRIMARY_CM_ID,MATH_PRIMARY_CM_NAME,
					ATT_PRIMARY_CM_ID,ATT_PRIMARY_CM_NAME,BEH_PRIMARY_CM_ID,BEH_PRIMARY_CM_NAME)

	SELECT			STUDENTID,CY_STUDENTID,STUDENTSF_ID,STUDENTFIRST_NAME,MIDDLE_NAME,STUDENTLAST_NAME,REGION_ID,REGION_NAME,SITE_NAME,'',CYCHANNEL_SCHOOL_ACCOUNT_NBR,
					SCHOOLNAME,DIPLOMAS_NOW,GENDER,GRADE,GRADE_DESC,PRIMARY_CM_ID,PRIMARY_CM_NAME,ATTENDANCE_IA,ELA_IA,MATH_IA,BEHAVIOR_IA,SCHOOL_YEAR_NAME__C,
					ELL,ETHNICITY,STUDENT_DISTRICT_ID,CYSCHOOLHOUSE_SCHOOL_ID,ELA_PRIMARY_CM_ID,ELA_PRIMARY_CM_NAME,MATH_PRIMARY_CM_ID,MATH_PRIMARY_CM_NAME,
					ATT_PRIMARY_CM_ID,ATT_PRIMARY_CM_NAME,BEH_PRIMARY_CM_ID,BEH_PRIMARY_CM_NAME 
	FROM #FIX_DUPS



	--CLEAN UP 'PS-MS 206M (6-8)' DUPS, DIFFERENT FROM PREVIOUS DUP CLEAN UP

	SELECT CY_StudentID, count(*) cnt INTO  #dups2 
	FROM #table1
	WHERE SchoolName = 'PS-MS 206M (6-8)'
	GROUP BY CY_StudentID
	HAVING count(*) > 1

	SELECT DISTINCT A.STUDENTID,A.CY_STUDENTID,A.STUDENTSF_ID,A.STUDENTFIRST_NAME,A.MIDDLE_NAME,A.STUDENTLAST_NAME,A.REGION_ID,A.REGION_NAME,A.SITE_NAME,A.CYCHANNEL_SCHOOL_ACCOUNT_NBR,
					A.SCHOOLNAME,A.DIPLOMAS_NOW,A.GENDER,A.GRADE,A.GRADE_DESC,A.PRIMARY_CM_ID,A.PRIMARY_CM_NAME,A.ATTENDANCE_IA,A.ELA_IA,A.MATH_IA,A.BEHAVIOR_IA,A.SCHOOL_YEAR_NAME__C,
					A.ELL,A.ETHNICITY,A.STUDENT_DISTRICT_ID,A.CYSCHOOLHOUSE_SCHOOL_ID,A.ELA_PRIMARY_CM_ID,A.ELA_PRIMARY_CM_NAME,A.MATH_PRIMARY_CM_ID,A.MATH_PRIMARY_CM_NAME,
					A.ATT_PRIMARY_CM_ID,A.ATT_PRIMARY_CM_NAME,A.BEH_PRIMARY_CM_ID,A.BEH_PRIMARY_CM_NAME
	INTO #FIX_DUPS2 
	FROM #table1 a inner join #dups2  b ON a.CY_StudentID = b.CY_StudentID  WHERE SchoolName = 'PS-MS 206M (6-8)' 

	DELETE #table1 FROM #table1 a inner join #dups2 b ON a.CY_StudentID = b.CY_StudentID

	INSERT INTO #table1 (STUDENTID,CY_STUDENTID,STUDENTSF_ID,STUDENTFIRST_NAME,MIDDLE_NAME,STUDENTLAST_NAME,REGION_ID,REGION_NAME,SITE_NAME,SCHOOLID,CYCHANNEL_SCHOOL_ACCOUNT_NBR,
					SCHOOLNAME,DIPLOMAS_NOW,GENDER,GRADE,GRADE_DESC,PRIMARY_CM_ID,PRIMARY_CM_NAME,ATTENDANCE_IA,ELA_IA,MATH_IA,BEHAVIOR_IA,SCHOOL_YEAR_NAME__C,
					ELL,ETHNICITY,STUDENT_DISTRICT_ID,CYSCHOOLHOUSE_SCHOOL_ID,ELA_PRIMARY_CM_ID,ELA_PRIMARY_CM_NAME,MATH_PRIMARY_CM_ID,MATH_PRIMARY_CM_NAME,
					ATT_PRIMARY_CM_ID,ATT_PRIMARY_CM_NAME,BEH_PRIMARY_CM_ID,BEH_PRIMARY_CM_NAME)

	SELECT			STUDENTID,CY_STUDENTID,STUDENTSF_ID,STUDENTFIRST_NAME,MIDDLE_NAME,STUDENTLAST_NAME,REGION_ID,REGION_NAME,SITE_NAME,'',CYCHANNEL_SCHOOL_ACCOUNT_NBR,
					SCHOOLNAME,DIPLOMAS_NOW,GENDER,GRADE,GRADE_DESC,PRIMARY_CM_ID,PRIMARY_CM_NAME,ATTENDANCE_IA,ELA_IA,MATH_IA,BEHAVIOR_IA,SCHOOL_YEAR_NAME__C,
					ELL,ETHNICITY,STUDENT_DISTRICT_ID,CYSCHOOLHOUSE_SCHOOL_ID,ELA_PRIMARY_CM_ID,ELA_PRIMARY_CM_NAME,MATH_PRIMARY_CM_ID,MATH_PRIMARY_CM_NAME,
					ATT_PRIMARY_CM_ID,ATT_PRIMARY_CM_NAME,BEH_PRIMARY_CM_ID,BEH_PRIMARY_CM_NAME 
	FROM #FIX_DUPS2
    

	

--UPDATE SPLIT SCHOOL NAMES WHERE THERE WERE NO DUPLICATES-------------------------------------------------------------------------------------------------

	SELECT CY_StudentID,SCHOOLNAME 
	INTO #SPLIT_SCHOOLS 
	FROM #table1 WHERE SCHOOLNAME  LIKE '%(%-%)%'
		 
	UPDATE #table1 SET
	SCHOOLNAME = SUBSTRING(b.SCHOOLNAME,0,CHARINDEX('(',b.SCHOOLNAME,0))
	FROM #table1 a inner join #SPLIT_SCHOOLS b ON a.CY_StudentID = b.CY_StudentID
	WHERE a.SCHOOLNAME LIKE '%(%-%)%'

	
	/*

	DELETE  #table1 FROM #table1 a inner join #dups b  ON a.CY_StudentID = b.CY_StudentID
	where a.schoolname = 'McKay K-8 School (6-8)'

	DELETE  #table1 FROM #table1 a inner join #dups b  ON a.CY_StudentID = b.CY_StudentID
	where a.schoolname = 'Father Keith B. Kenny (7-8)'

	DELETE  #table1 FROM #table1 a inner join #dups b  ON a.CY_StudentID = b.CY_StudentID
	where a.schoolname = 'Hennigan Elementary School (6-7)'

	DELETE  #table1 FROM #table1 a inner join #dups b  ON a.CY_StudentID = b.CY_StudentID
	where a.schoolname = 'Trotter Elementary School (6-7)'


	update #table1 set SCHOOLNAME = 'Hennigan Elementary School' where schoolname = 'Hennigan Elementary School (6-7)'
	update #table1 set SCHOOLNAME = 'Father Keith B. Kenny' where schoolname = 'Father Keith B. Kenny (7-8)'
	update #table1 set SCHOOLNAME = 'McKay K-8 School' where schoolname = 'McKay K-8 School (6-8)'
	update #table1 set SCHOOLNAME = 'Trotter Elementary School' where schoolname = 'Trotter Elementary School (6-7)'

	*/

--ADD CORPS MEMBER EMAILS FROM SDW_STAGE_PROD.dbo.STAFF__C --------------------------------------------------------------


UPDATE #table1 SET 
[ELA_PRIMARY_CM_EMAIL] = ISNULL(b.Email__c,'N/A')
FROM   #table1 a LEFT OUTER JOIN  SDW_STAGE_PROD.dbo.Staff__c b
                 ON a.ELA_PRIMARY_CM_SF_ID = b.ID

UPDATE #table1 SET 
[MATH_PRIMARY_CM_EMAIL] = ISNULL(b.Email__c,'N/A')
FROM   #table1 a LEFT OUTER JOIN  SDW_STAGE_PROD.dbo.Staff__c b
                 ON a.[MATH_PRIMARY_CM_SF_ID] = b.ID

UPDATE #table1 SET 
[ATT_PRIMARY_CM_EMAIL] = ISNULL(b.Email__c,'N/A')
FROM   #table1 a LEFT OUTER JOIN  SDW_STAGE_PROD.dbo.Staff__c b
                 ON a.[ATT_PRIMARY_CM_SF_ID] = b.ID

UPDATE #table1 SET 
[BEH_PRIMARY_CM_EMAIL] = ISNULL(b.Email__c,'N/A')
FROM   #table1 a LEFT OUTER JOIN  SDW_STAGE_PROD.dbo.Staff__c b
                 ON a.[BEH_PRIMARY_CM_SF_ID] = b.ID



--LOAD TABLE-------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ReportCYData_Prod.[dbo].[1_RPT_STUDENT_MAIN_WIP]

INSERT INTO ReportCYData_Prod.[dbo].[1_RPT_STUDENT_MAIN_WIP]
SELECT 
 StudentID
,CY_StudentID
,StudentSF_ID
,StudentFirst_Name
,middle_name
,StudentLast_Name
,region_ID
,region_name
,site_name
,SchoolID
,CYCHANNEL_SCHOOL_ACCOUNT_NBR
,SchoolName
,Diplomas_Now
,Gender
,Grade
,GRADE_DESC
,PRIMARY_CM_ID
,PRIMARY_CM_NAME
,Attendance_IA
,ELA_IA
,Math_IA
,Behavior_IA
,school_year_name__c
,ELL
,Ethnicity
,STUDENT_DISTRICT_ID
,cyschoolhouse_SCHOOL_ID
,ELA_PRIMARY_CM_ID
,ELA_PRIMARY_CM_SF_ID
,ELA_PRIMARY_CM_NAME
,ELA_PRIMARY_CM_EMAIL
,MATH_PRIMARY_CM_ID
,MATH_PRIMARY_CM_SF_ID
,MATH_PRIMARY_CM_NAME
,MATH_PRIMARY_CM_EMAIL
,ATT_PRIMARY_CM_ID
,ATT_PRIMARY_CM_SF_ID
,ATT_PRIMARY_CM_NAME
,ATT_PRIMARY_CM_EMAIL
,BEH_PRIMARY_CM_ID
,BEH_PRIMARY_CM_SF_ID
,BEH_PRIMARY_CM_NAME
,BEH_PRIMARY_CM_EMAIL
,GETDATE()
FROM #table1


END 









GO
