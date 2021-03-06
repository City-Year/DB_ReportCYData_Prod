USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_1_RPT_STUDENT_MAIN]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_1_RPT_STUDENT_MAIN]
AS
BEGIN

SELECT   DISTINCT  
		a.StudentID AS STUDENT_ID, 
		b.CY_StudentID AS CYSCHOOLHOUSE_STUDENT_ID, 
		b.StudentSF_ID,
		b.StudentFirst_Name AS FIRST_NAME, 
		'' AS MIDDLE_NAME, 
		b.StudentLast_Name AS LAST_NAME, 
		'' AS REGION_ID, 
		c.Region AS REGION_NAME, 
--		'' AS SITE_ID, 
		c.Business_Unit AS SITE_NAME, 
		a.SchoolID AS SCHOOL_ID, 
		c.CYCh_Account_# AS CYCHANNEL_SCHOOL_ACCOUNT_NBR, 
		c.SchoolName AS SCHOOL_NAME, 
		CASE c.Diplomas_Now WHEN 'No' THEN 0 WHEN 'Yes' THEN 1 END AS DIPLOMAS_NOW_SCHOOL, 
		b.Gender, 
		b.Grade AS GRADE_ID, 
		b.Grade + 'th' AS GRADE_DESC, 
		'                                          ' AS PRIMARY_CM_ID,	--	e.CorpsMemberID AS PRIMARY_CM_ID, 
		'                                          ' AS PRIMARY_CM_NAME,  --  e.CorpsMember_Name AS PRIMARY_CM_NAME, 
--		c.CYCh_Account_# AS CYCHANNEL_ACCOUNT_NBR, 
		b.Attendance_IA, 
		b.ELA_IA, 
		b.Math_IA, 
		b.Behavior_IA, 
		d.SchoolYear AS FISCAL_YEAR, 
		b.ELL, 
		b.Ethnicity, 
		b.StudentDistrictID AS Student_District_ID, 
		c.CYSch_SF_ID AS CYSchoolhouse_School_ID,
		'                                           ' AS ELA_PRIMARY_CM_ID,		--CASE WHEN f.IndicatorArea IN ('ELA','ELA/Literacy') THEN e.CorpsMemberID    END	AS ELA_PRIMARY_CM_ID,
		'                                           ' AS ELA_PRIMARY_CM_NAME,	--CASE WHEN f.IndicatorArea IN ('ELA','ELA/Literacy') THEN e.CorpsMember_Name END	AS ELA_PRIMARY_CM_NAME,
		'                                           ' AS MATH_PRIMARY_CM_ID,	--CASE WHEN f.IndicatorArea = 'MATH'  THEN e.CorpsMemberID					END AS MATH_PRIMARY_CM_ID,
		'                                           ' AS MATH_PRIMARY_CM_NAME,	--CASE WHEN f.IndicatorArea = 'MATH'  THEN e.CorpsMember_Name			        END	AS MATH_PRIMARY_CM_NAME,
		'                                           ' AS ATT_PRIMARY_CM_ID,		--CASE WHEN f.IndicatorArea = 'Attendance' THEN e.CorpsMemberID				END AS ATT_PRIMARY_CM_ID,
		'                                           ' AS ATT_PRIMARY_CM_NAME,	--CASE WHEN f.IndicatorArea = 'Attendance' THEN e.CorpsMember_Name		    END AS ATT_PRIMARY_CM_NAME,
		'                                           ' AS BEH_PRIMARY_CM_ID,		--CASE WHEN f.IndicatorArea = 'Behavior' THEN e.CorpsMemberID					END AS BEH_PRIMARY_CM_ID,
		'                                           ' AS BEH_PRIMARY_CM_NAME	--CASE WHEN f.IndicatorArea = 'Behavior' THEN e.CorpsMember_Name				END	AS BEH_PRIMARY_CM_NAME
INTO  #table1
FROM         SDW_Prod.dbo.FactAll AS a WITH (nolock) INNER JOIN
                      SDW_Prod.dbo.DimStudent AS b WITH (nolock)		ON a.StudentID = b.StudentID INNER JOIN
                      SDW_Prod.dbo.DimSchool AS c WITH (nolock)			ON a.SchoolID = c.SchoolID INNER JOIN
                      SDW_Prod.dbo.DimGrade AS d WITH (nolock)			ON a.GradeID = d.GradeID INNER JOIN
					  SDW_Prod.dbo.DimCorpsMember AS e WITH (nolock)	ON a.CorpsMemberID = e.CorpsMemberID INNER JOIN 
					  SDW_Prod.dbo.DimIndicatorArea AS f WITH (nolock)  ON a.IndicatorAreaID = f.IndicatorAreaID

order by a.StudentID


--ELA------------------------------------------------------------------------------------------------------
UPDATE #table1 SET
ELA_PRIMARY_CM_ID	=	d.CorpsMemberID,
ELA_PRIMARY_CM_NAME	=   d.CorpsMember_Name
FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea IN ('ELA','ELA/Literacy')


--MATH------------------------------------------------------------------------------------------------------
UPDATE #table1 SET
MATH_PRIMARY_CM_ID		= d.CorpsMemberID,
MATH_PRIMARY_CM_NAME	= d.CorpsMember_Name

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea =  'MATH'   


--ATTENDANCE------------------------------------------------------------------------------------------------------
UPDATE #table1 SET
ATT_PRIMARY_CM_ID		= d.CorpsMemberID,
ATT_PRIMARY_CM_NAME		= d.CorpsMember_Name

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea =  'ATTENDANCE'   

--BEHAVIOR--------------------------------------------------------------------------------------------------
UPDATE #table1 SET
BEH_PRIMARY_CM_ID		= d.CorpsMemberID,
BEH_PRIMARY_CM_NAME  	= d.CorpsMember_Name

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where c.IndicatorArea = 'BEHAVIOR'  




--INSERT TO RPT_STUDENT_MAIN

TRUNCATE TABLE [1_RPT_STUDENT_MAIN]

INSERT INTO [dbo].[1_RPT_STUDENT_MAIN]
SELECT * FROM #table1


END

/*

--PRIMARY CM----------CAN NOT DETERMIINE YET-------------------------------------------------------------------------------------

UPDATE #table1 SET
PRIMARY_CM_ID	=	d.CorpsMemberID,
PRIMARY_CM_NAME	=   d.CorpsMember_Name
FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID

where c.IndicatorArea = 'Non-specific IA' studentID = '16938'  and 

select * from SDW_Prod.dbo.FactAll order by studentID = '14377' 

select PRIMARY_CM_NAME,PRIMARY_CM_ID from #table1 where student_ID = '14377'




select distinct a.studentID,CorpsMember_Name from SDW_Prod.dbo.factall a inner join SDW_Prod.dbo.DimIndicatorArea b
												             ON a.IndicatorAreaID = b.IndicatorAreaID
															 inner join SDW_Prod.dbo.DimCorpsMember c
															 on a.CorpsMemberID   = c.CorpsMemberID
where CorpsMember_Name like '%Adam%'   

b.IndicatorArea = 'Non-specific IA' studentID = '14377' 

 



and studentID = '14377'

select * from [1_RPT_STUDENT_MAIN] where 


select * from #table1 where ELA_PRIMARY_CM_NAME = 'Adam Volunteer' or MATH_PRIMARY_CM_NAME = 'Adam Volunteer' or ATT_PRIMARY_CM_NAME = 'Adam Volunteer' or BEH_PRIMARY_CM_ID = 'Adam Volunteer'



select * from #table1 where ELA_PRIMARY_CM_NAME <> '' and MATH_PRIMARY_CM_NAME <> '' and ATT_PRIMARY_CM_NAME <> '' and BEH_PRIMARY_CM_ID <> ''
select * from #table1 where BEH_PRIMARY_CM_ID <> ''


student_ID = '16938'






UPDATE #table1 SET

ELA_PRIMARY_CM_ID		= CASE WHEN c.IndicatorArea IN ('ELA','ELA/Literacy')	THEN  ISNULL(d.CorpsMemberID,'')	ELSE '' END,	
ELA_PRIMARY_CM_NAME		= CASE WHEN c.IndicatorArea IN ('ELA','ELA/Literacy')	THEN  ISNULL(d.CorpsMember_Name,'') ELSE '' END--,

--ATT_PRIMARY_CM_ID		= CASE WHEN c.IndicatorArea IN ('Attendance')			THEN  ISNULL(d.CorpsMemberID,'')	ELSE '' END,
--ATT_PRIMARY_CM_NAME		= CASE WHEN c.IndicatorArea IN ('Attendance')			THEN  ISNULL(d.CorpsMember_Name,'') ELSE '' END,
--BEH_PRIMARY_CM_ID		= CASE WHEN c.IndicatorArea IN ('Behavior')				THEN  ISNULL(d.CorpsMemberID,'')	ELSE '' END,
--BEH_PRIMARY_CM_NAME		= CASE WHEN c.IndicatorArea IN ('Behavior')				THEN  ISNULL(d.CorpsMember_Name,'') ELSE '' END

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where studentID = '16938' and (ELA_PRIMARY_CM_ID = '' or ELA_PRIMARY_CM_ID = '0')

UPDATE #table1 SET
MATH_PRIMARY_CM_ID		= CASE WHEN c.IndicatorArea IN ('MATH')					THEN  ISNULL(d.CorpsMemberID,'')	ELSE '' END,
MATH_PRIMARY_CM_NAME	= CASE WHEN c.IndicatorArea IN ('MATH')					THEN  ISNULL(d.CorpsMember_Name,'') ELSE '' END

FROM #table1 a  INNER JOIN  SDW_Prod.dbo.FactAll b on a.STUDENT_ID = b.StudentID
				INNER JOIN  SDW_Prod.dbo.DimIndicatorArea c ON  b.IndicatorAreaID = c.IndicatorAreaID
				INNER JOIN  SDW_Prod.dbo.DimCorpsMember d   ON  b.CorpsMemberID   = d.CorpsMemberID
where studentID = '16938' and (MATH_PRIMARY_CM_ID = '' or MATH_PRIMARY_CM_ID = '0')
select a.studentID,b.IndicatorArea,CorpsMember_Name from SDW_Prod.dbo.factall a inner join SDW_Prod.dbo.DimIndicatorArea b
												             ON a.IndicatorAreaID = b.IndicatorAreaID
															 inner join SDW_Prod.dbo.DimCorpsMember c
															 on a.CorpsMemberID   = c.CorpsMemberID
where studentID = '16938' and (MATH_PRIMARY_CM_ID = '' or MATH_PRIMARY_CM_ID = '0')


select * from SDW_Prod.dbo.DimIndicatorArea where IndicatorAreaID = '1736'


select * from #table1 where student_ID = '16938' ELA_PRIMARY_CM_NAME <> '' and MATH_PRIMARY_CM_NAME <> ''

END


*/
GO
