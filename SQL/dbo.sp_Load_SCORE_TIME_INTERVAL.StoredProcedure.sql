USE [ReportCYData_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_SCORE_TIME_INTERVAL]    Script Date: 12/1/2016 9:27:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_Load_SCORE_TIME_INTERVAL]
AS
BEGIN

	--############################################################################################################################
	-- UPDATE FIELDS IN DimStudent TABLE
	--############################################################################################################################

		SELECT 
			SchoolForce__Student__c, 
			MIN(StuSect_Start)			  AS Enrollment_Date, 
			CAST(MAX(StuSec_End) as date) AS Enrollment_End_Date, 
			COUNT(*)                      AS #_Of_Sections
		INTO  #Enrollment_tracking_Start_and_End_rollup 
		FROM sdw_stage.dbo.vw_StudentSection_Active_EnrollmentTracking_Start_and_End
		GROUP BY SchoolForce__Student__c
		ORDER BY SchoolForce__Student__c



		UPDATE DimStudent SET
			Enrollment_Date		= b.Enrollment_Date,
			Enrollment_End_date	= b.Enrollment_End_Date 
		FROM DimStudent a INNER JOIN #Enrollment_tracking_Start_and_End_rollup b
				          ON a.StudentSF_ID = b.SchoolForce__Student__c


	
		
	-- GRADE BOOK PRE TAG PROCESSING
	--#####################################################################################################################
	-- CREATE TEMP TABLE WITH DATEDIFF BETWEEN NEW FIELD ON DIMSTUDENT(ENROLLMENT_DATE) AND THE DATE FIELD ON DIMDATE TABLE 
	-- PER STUDENT,PROGRAM,ASSIGNMENTTYPE,FACTTYPE. THIS TABLE CAPTURES ALL RECORDS AND IS PRIMARY SOURCE FOR THIS PROCESS.
	--#####################################################################################################################

		SELECT 	DISTINCT
			a.StudentID,
			a.schoolID,
			c.Program, 
			d.AssignmentType,
			a.AssessmentID,
			h.AssessmentName,
			h.Data_Type_Display,
		    h.Data_Type_Display_2,
			h.Data_Type_Display_3,
			h.Data_Type_Display_4,
			h.Data_Type_Display_5,
			g.FactType, 
			b.Date,
			e.Enrollment_date,
			Datediff(dd,e.Enrollment_Date,b.date) Date_Difference_From_Enrollment,
			ABS(DateDiff(dd,getdate(),b.date)) Date_Difference_From_Today,
			CASE WHEN e.Enrollment_End_Date = '1900-01-01' THEN NULL
				 ELSE abs(Datediff(dd,b.date,e.Enrollment_End_Date))
				 END  AS Date_Difference_From_Exit,
			CASE WHEN e.Enrollment_End_Date = '1900-01-01' THEN NULL
			     ELSE e.Enrollment_End_Date 
				 END  AS Enrollment_End_Date,
			a.Assignment_Entered_Grade ,
			f.MarkingPeriod,
			h.score,
			h.score_2,
			h.score_3,
			h.score_4,
			h.score_5
		
			
    	INTO #PRE_TAG_DATE_DIFF
		FROM FactAll a
			INNER JOIN DimDate			b		on a.DateID			= b.DateID
			INNER JOIN DimProgram		c		on a.ProgramID		= c.ProgramID
			INNER JOIN DimAssignment	d		on a.AssignmentID	= d.AssignmentID
			INNER JOIN DimStudent		e		on a.StudentID		= e.StudentID
			INNER JOIN DimGrade         f       on a.GradeID        = f.GradeID
			INNER JOIN DimFactType		g       on a.FactTypeID     = g.FactTypeID
			INNER JOIN DimAssessment    h       on a.AssessmentID   = h.AssessmentID
			
		ORDER BY studentID, Program,AssignmentType,FactType
		

	----------------------------------------------------------------------------------------------------------------------------
	--UPDATE INDICATORAREA FOR ASSESSMENTS
	----------------------------------------------------------------------------------------------------------------------------
	
	
	UPDATE #PRE_TAG_DATE_DIFF SET 
    Program = Related_IA
	FROM  #PRE_TAG_DATE_DIFF a left outer join AssessmentIA b
	                        on a.AssessmentName = b.Assessment_Name
	WHERE a.Facttype = 'Assessment'
	AND Program = 'other'
	AND StudentID = '2306'

	
		
	--##########################################################################################################################
	-- CREATE MULTIPLE TEMP TABLES CONTAINING THE VARIOUS NEEDED DATA POINTS BY STUDENTID,PROGRAM,ASSIGNMENTTYPE
	-- AND ENROLLMENT DATE
	--##########################################################################################################################
	
			
	--1----------------------------------------------------------------------------------------------------------------------
	-- PRIOR YEAR MOST RECENT	
	-- SELECT RECORDS WITH A DATA POINT THAT IS THE CLOSEST DATE PRIOR TO 8/1(WHICH IS THE START OF EACH SCHOOLYEAR).
	--------------------------------------------------------------------------------------------------------------------------	

		--SELECT PRIOR_YEAR_MOST_RECENT_DATE DATE
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			FactType,
			MAX(DATE) AS PRIOR_YEAR_MOST_RECENT_DATE   
		INTO #PRIOR_YEAR_MOST_RECENT
		FROM #PRE_TAG_DATE_DIFF	a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.facttype = 'assignment'
		AND   a.DATE Between b.Start_Date and b.End_Date
		AND   b.Quarter = 'Prior Year'
		GROUP BY StudentID,Program,AssignmentType,FactType


		-- PICK UP ASSIGNMENT_ENTERED_GRADE AND QUARTER
		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.facttype,
			a.PRIOR_YEAR_MOST_RECENT_DATE,
			b.Assignment_Entered_Grade, 
			b.MarkingPeriod,
			c.Quarter
        INTO #PRIOR_YEAR_MOST_RECENT_VALUE
		FROM #PRIOR_YEAR_MOST_RECENT a 
			INNER JOIN #PRE_TAG_DATE_DIFF b
				ON  a.studentID			= b.studentID
				AND a.program			= b.program 
				AND a.AssignmentType	= b.assignmentType
				AND a.facttype          = b.facttype
				AND a.PRIOR_YEAR_MOST_RECENT_DATE = b.Date
			INNER JOIN DimSchoolSetup c
				ON  b.schoolID = c.SchoolID
        WHERE a.PRIOR_YEAR_MOST_RECENT_DATE Between c.Start_Date and c.End_Date

			
	--2-----------------------------------------------------------------------------------------------------------------
	-- First_MPEarliest_Date(FIRST MARKING PERIOD EARLIEST DATA POINT). THIS IS THE FIRST DATA POINT IN THE SCHOOL YEAR AS DETERMINED
	-- BY THE MIN DATE THAT IS GREATER THAN 8/1 AND WITHIN THE FIRST MARKING PERIOD. 
	--------------------------------------------------------------------------------------------------------------------

		--PICK UP CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT
		SELECT 
			a.StudentID,
			a.Program,
			a.assignmentType,
			a.FactType,
			MIN(a.Date) AS CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT
		INTO #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE  a.FactType = 'Assignment'
		AND    a.DATE Between b.Start_Date and b.End_Date
		AND    b.Quarter = 'Quarter 1' 
		GROUP BY StudentID,Program,AssignmentType,FactType

				
		--PICK UP THE ASSIGNMENT_ENTERED_GRADE AND QUARTER
		 
		SELECT DISTINCT
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.FactType,
			a.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT,
			b.Assignment_Entered_Grade,
			b.MarkingPeriod, 
			c.Quarter

        INTO #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_VALUE
		FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID							= b.studentID
			and a.program							= b.program 
			and a.AssignmentType					= b.assignmentType
			AND a.facttype							= b.facttype
			and a.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT		= b.Date
			INNER JOIN DimSchoolSetup c
				ON  b.schoolID = c.SchoolID
        WHERE a.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT Between c.Start_Date and c.End_Date
		AND   c.Quarter = 'Quarter 1'
		ORDER BY StudentID,Program,AssignmentType,facttype
		
	--3-----------------------------------------------------------------------------------------------------------------
	-- CYr_Earliest_Date THIS IS THE FIRST DATA POINT IN THE SCHOOL YEAR REGARLESS OF MARKING PERIOD, AS DETERMINED
	-- BY THE MIN DATE THAT IS GREATER THAN 8/1. 
	--------------------------------------------------------------------------------------------------------------------

		--PICK UP CURRENT_YEAR_EARLIEST_DATA_POINT
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			FactType,
			MIN(Date) AS CURRENT_YEAR_EARLIEST_DATA_POINT
		INTO #CURRENT_YEAR_EARLIEST_DATA_POINT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.DATE Between b.start_date and b.end_date    
		AND FactType = 'Assignment'
		AND b.Quarter <> 'Prior Year' 
		GROUP BY StudentID,Program,AssignmentType,FactType

	

		--PICK UP THE ASSIGNMENT_ENTERED_GRADE AND QUARTER
		 
		SELECT DISTINCT
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.FactType,
			a.CURRENT_YEAR_EARLIEST_DATA_POINT,
			b.Assignment_Entered_Grade,
			b.MarkingPeriod,
			c.Quarter 
						
       INTO #CURRENT_YEAR_EARLIEST_DATA_POINT_VALUE
		FROM #CURRENT_YEAR_EARLIEST_DATA_POINT a	INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID							= b.studentID
			and a.program							= b.program 
			and a.AssignmentType					= b.assignmentType
			AND a.facttype							= b.facttype
			and a.CURRENT_YEAR_EARLIEST_DATA_POINT	= b.Date
													INNER JOIN DimSchoolSetup c
			ON  b.schoolID = c.SchoolID
        WHERE a.CURRENT_YEAR_EARLIEST_DATA_POINT Between c.Start_Date and c.End_Date
		ORDER BY StudentID,Program,AssignmentType,facttype			
	
		
	--4----------------------------------------------------------------------------------------------------------------------
	-- MID YEAR DATA POINT. DETERMINED AS THE LATEST DATA POINT BEFORE FEB 15th. CANNOT BE THE SAME AS PRIOR YEAR MOST RECENT
	---------------------------------------------------------------------------------------------------------------------------
		
		SELECT 
			a.StudentID,
			a.Program,
			a.AssignmentType,
			a.FactType,
			MAX(a.DATE) AS MID_YEAR_PROXY   
		INTO #MID_YEAR_PROXY
		FROM #PRE_TAG_DATE_DIFF  a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.Date  <= '2015-02-15'
		AND   a.DATE   > b.year_start_date	
		AND   a.DATE Between b.Start_Date and b.End_Date
		AND   FactType = 'Assignment'
		AND   b.Quarter <> 'Prior Year'
		GROUP BY StudentID,Program,AssignmentType,FactType
		

		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.facttype,
			a.MID_YEAR_PROXY,
			b.Assignment_Entered_Grade, 
			c.Quarter
        INTO #MID_YEAR_PROXY_VALUE
		FROM #MID_YEAR_PROXY a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID			= b.studentID
			AND a.program			= b.program 
			AND a.AssignmentType	= b.assignmentType
			AND a.facttype          = b.facttype
			AND a.MID_YEAR_PROXY    = b.Date
							INNER JOIN DimSchoolSetup c
			ON  b.schoolID = c.SchoolID
        WHERE a.MID_YEAR_PROXY Between c.Start_Date and c.End_Date
		ORDER BY StudentID,Program,AssignmentType,facttype		
			
			
	--5-----------------------------------------------------------------------------------------------------------------
	-- CYr_MOST_RECENT DATA POINT 
	-- LAST DATA POINT FROM CURRENT SCHOOL YEAR. THIS IS THE LAST DATA POINT IN THE SCHOOL YEAR AS DETERMINED 
	-- BY THE MAX(DATE) THAT IS BETWEEN '2014-08-01' and '2015-06-30'
	--------------------------------------------------------------------------------------------------------------------
		
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			FactType,
			MAX(Date) AS CURRENT_YEAR_LAST_DATA_POINT 
		INTO #CURRENT_YEAR_MOST_RECENT_DATA_POINT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.DATE Between b.year_start_date and b.year_end_date    
		AND FactType = 'Assignment'
		AND Quarter <> 'Prior Year'
		GROUP BY StudentID,Program,AssignmentType,FactType
		
		-- PICK UP ASSIGNMENT_ENTERED_GRADE AND QUARTER

		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.FactType,
			a.CURRENT_YEAR_LAST_DATA_POINT,
			b.Assignment_Entered_Grade,
			c.Quarter
        INTO #CURRENT_YEAR_MOST_RECENT_DATA_POINT_VALUE
		FROM #CURRENT_YEAR_MOST_RECENT_DATA_POINT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID								= b.studentID
			and a.program								= b.program 
			and a.AssignmentType						= b.assignmentType
			and a.FactType                              = b.FactType
			and a.CURRENT_YEAR_LAST_DATA_POINT			= b.Date
			INNER JOIN DimSchoolSetup c
			ON  b.schoolID = c.SchoolID
        WHERE a.CURRENT_YEAR_LAST_DATA_POINT Between c.Start_Date and c.End_Date
		ORDER BY StudentID,Program,AssignmentType,facttype		
		
	--6--------------------------------------------------------------------------------------------------------------------------
	-- THE EARLIEST INTERVENTION START DATE IS FOUND PER STUDENTID,PROGRAM,ASSIGNMENTTYPE. THEN THE CLOSEST DATE TO THE EARLIEST 
	-- INTERVENTION DATE, THAT IS OF FACTTYPE ASSIGNMENT, IS FOUND.   
	-----------------------------------------------------------------------------------------------------------------------------

	--THE #Student_Section_Start_End_Dates TABLE IS USED HERE FOR THE EARLIEST INTERVENTION DATE AND ON #7 FOR THE LATEST
	--INTERVENTION DATE. IT IS ALSO USED IN THE ASSESSMENTS SECTION FOR EALIEST AND LATEST INTERVENTION DATES. 

	SELECT DISTINCT
				b.CY_Student_ID,
				d.studentID,
				a.Section_IA,
			--	c.section_name,
				a.StuSect_Start,
				a.StuSec_End
				
	INTO #Student_Section_Start_End_Dates	
 	FROM  SDW_Stage.[dbo].[vw_StudentSection_Active_EnrollmentTracking_Start_and_End] a inner join 
			SDW_Stage.[dbo].[vw_Student_Information] b on a.schoolforce__Student__c = b.Student_SF_ID
			INNER JOIN DimStudent d ON d.CY_StudentID = b.CY_Student_ID
			
			ORDER BY StudentID,StuSect_Start

		

	--FIND EARLIEST INTERVENTION START DATE

			select studentID,Section_IA,Min(StuSect_Start) AS Earliest_Int_Start_Date
			INTO #EARLIEST_INT_START_DATE
			from #Student_Section_Start_End_Dates
			Where StuSec_End <> '1900-01-01 00:00:00.000'
			group by CY_Student_ID,studentID,Section_IA

			
	--FIND THE MAX DATE LESS THAN EARLIEST INTERVENTION DATE
			
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MAX(a.Date) AS DATE
	    	INTO  #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE_ASSIGNMENT
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #EARLIEST_INT_START_DATE   b    -- #DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date < b.Earliest_Int_Start_Date
			AND   a.Facttype = 'Assignment'
			AND   a.Program = b.Section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName

		UNION ALL
			
			--FIND THE MIN DATE GREATER THAN EARLIEST INTERVENTION DATE

			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MIN(a.Date) AS DATE
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #EARLIEST_INT_START_DATE   b    --#DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date > b.Earliest_Int_Start_Date								--b.Date_Difference_From_Intervention_Enrollment
			AND   a.Facttype = 'Assignment'
			AND   a.Program = b.Section_IA
			GROUP BY 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName


-------------------------------------------------------------------------------------------------------------------------------------------------------			 
--THE #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE TABLE CONTAINS THE BEFORE AND AFTER,CLOSEST DATES TO THE EARLIEST INTERVENTION DATE.
--IF THERE IS A BEFORE AND AFTER DATE THEN SELECTING THE MIN DATE WILL BRING BACK THE BEFORE DATE WHICH IS THE FIRST PRIORITY DATE.  
--IF EITHER THE BEFORE OR AFTER DATE ARE MISSING THEN THE MIN DATE WILL BE WHAT EVER DATE IS AVAILABLE
--------------------------------------------------------------------------------------------------------------------------------------------------------

			SELECT 
			  a.SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName,
			  MIN(Date) AS DATE
			INTO #CLOSEST_ASSIGNMENT_DATE_TO_EARLIEST_INTERVENTION_DATE
			FROM #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE_ASSIGNMENT a inner join DimSchoolSetup b ON a.schoolID = b.schoolId
			WHERE a.DATE		> b.year_start_date 
			GROUP BY
			  a.SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName
			  
		-- PICK UP ASSIGNMENT_ENTERED_GRADE

			SELECT 
				a.StudentID,
				a.Program,
				a.AssignmentType,
				a.Date,
				b.Assignment_Entered_Grade,
				b.MarkingPeriod,
				c.Quarter,
				b.SchoolID
			INTO #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE
			FROM #CLOSEST_ASSIGNMENT_DATE_TO_EARLIEST_INTERVENTION_DATE a INNER JOIN #PRE_TAG_DATE_DIFF b
				ON  a.studentID								= b.studentID
				and a.program								= b.program 
				and a.AssignmentType						= b.assignmentType
				and a.Date									= b.Date
														INNER JOIN DimSchoolSetup c
														ON  b.schoolID = c.SchoolID
				WHERE a.Date Between c.Start_Date and c.End_Date

		ORDER BY StudentID,Program,AssignmentType,facttype		
			  
			
	--7--------------------------------------------------------------------------------------------------------------------------
	-- THE LATEST INTERVENTION DATE IS FOUND PER STUDENTID,PROGRAM,ASSIGNMENTTYPE. THEN THE CLOSEST DATE TO THE LATEST 
	-- INTERVENTION DATE, THAT IS OF FACTTYPE ASSIGNMENT, IS FOUND.  
	-----------------------------------------------------------------------------------------------------------------------------
	
		

		   --FIND LATEST INTERVENTION END DATE

			select studentID,Section_IA,MAX(StuSec_End) AS Latest_Int_End_Date
			INTO #LATEST_INT_END_DATE
			from #Student_Section_Start_End_Dates
			Where StuSec_End <> '1900-01-01 00:00:00.000'
			group by CY_Student_ID,studentID,Section_IA

			
			
			--FIND THE MAX DATE LESS THAN LATEST INTERVENTION DATE
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MAX(a.Date) AS DATE
			INTO #DATES_LESS_THAN_AND_GREATER_THAN_LATEST_INT_DATE_ASSIGNMENT
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #LATEST_INT_END_DATE   b    -- #DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date < b.Latest_Int_End_Date
			AND   a.Facttype = 'Assignment'
			AND   a.Program  = b.Section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName

		UNION ALL
			
			--FIND THE MIN DATE GREATER THAN EARLIEST INTERVENTION DATE
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MIN(a.Date) AS DATE
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #LATEST_INT_END_DATE   b    --#DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date > b.Latest_Int_End_Date								--b.Date_Difference_From_Intervention_Enrollment
			AND   a.Facttype = 'Assignment'
			AND   a.Program  = b.Section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName


-------------------------------------------------------------------------------------------------------------------------------------------------------			 
--THE #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE TABLE CONTAINS THE BEFORE AND AFTER,CLOSEST DATES TO THE EARLIEST INTERVENTION DATE.
--IF THERE IS A BEFORE AND AFTER DATE THEN SELECTING THE MIN DATE WILL BRING BACK THE BEFORE DATE WHICH IS THE FIRST PRIORITY DATE.  
--IF EITHER THE BEFORE OR AFTER DATE ARE MISSING THEN THE MIN DATE WILL BE WHAT EVER DATE IS AVAILABLE
--------------------------------------------------------------------------------------------------------------------------------------------------------


			SELECT 
			  a.SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName,
			  Max(Date) AS DATE
			INTO #CLOSEST_ASSIGNMENT_DATE_TO_LATEST_INTERVENTION_DATE
			FROM #DATES_LESS_THAN_AND_GREATER_THAN_LATEST_INT_DATE_ASSIGNMENT a inner join DimSchoolSetup b ON a.schoolID = b.schoolId
			WHERE a.DATE		> b.year_start_date 
			GROUP BY
			  a.SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName

			 
			  
		-- PICK UP ASSIGNMENT_ENTERED_GRADE

			SELECT 
				a.StudentID,
				a.Program,
				a.AssignmentType,
				a.Date,
				b.Assignment_Entered_Grade,
				b.MarkingPeriod,
				c.Quarter,
				b.SchoolID
			INTO #INTSTARTENROLL_LATEST_PROXY_DATE_VALUE  
			FROM #CLOSEST_ASSIGNMENT_DATE_TO_LATEST_INTERVENTION_DATE a INNER JOIN #PRE_TAG_DATE_DIFF b
				ON  a.studentID								= b.studentID
				and a.program								= b.program 
				and a.AssignmentType						= b.assignmentType
				and a.Date									= b.Date
														INNER JOIN DimSchoolSetup c
														ON  b.schoolID = c.SchoolID
				WHERE a.Date Between c.Start_Date and c.End_Date

		ORDER BY StudentID,Program,AssignmentType,facttype		
	


	--8 ---[Final_MPLatest_Date]----------------------------------------------------------------------------------------------------------------
	-- CURRENT YEAR LATEST DATA POINT(ASSESSMENT) THAT IS WITHIN THE LAST MARKING PERIOD. THIS IS THE LATEST DATA POINT IN THE SCHOOL YEAR AS 
	-- DETERMINED BY THE MAX DATE THAT IS GREATER THAN 8/1/2014 AND WITHIN LAST MARKING PERIOD. 
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--PICK UP CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT THAT IS IN MARKING PERIOD 4
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			FactType,
			MAX(Date) AS CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT
		INTO #CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.DATE Between b.Start_Date and b.End_Date
		AND FactType = 'Assignment'
		AND Quarter = 'Quarter 4'
		GROUP BY StudentID,Program,AssignmentType,FactType


		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.FactType,
			a.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT,
			b.Assignment_Entered_Grade,
			c.Quarter
        INTO #CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_VALUE
		FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID														= b.studentID
			and a.program														= b.program 
			and a.AssignmentType												= b.assignmentType
			and a.FactType														= b.FactType
			and a.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT			= b.Date
			INNER JOIN DimSchoolSetup c
			ON  b.schoolID = c.SchoolID
        WHERE a.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT Between c.Start_Date and c.End_Date

		
		
		
	--##################################################################################################################
	--INSERT PRE TAG RECORDS INTO DimPreAndPostTag AND UPDATE FIELDS
	--##################################################################################################################

	--------------------------------------------------------------------------------------------------------------------------
	--INSERT DISTINCT RECORDS INTO DimPreAndPostTag TABLE. THIS WILL INSERT ALL STUDENTS GROUPED BY STUDENT,
	--PROGRAM,ASSIGNMENTTYPE,FACTTYPE,ENROLLMENT_DATE COMBINATIONS TO BE UPDATED. 
	--------------------------------------------------------------------------------------------------------------------------

		INSERT INTO DimPreAndPostTag									--CHECK INSERT CODE3---------------------------------------------------------------
		SELECT DISTINCT
		     StudentID, 
			 Program, 
			 AssignmentType,
			 NULL,					
			 FactType,
			 Enrollment_date,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL,
			 NULL
		FROM #PRE_TAG_DATE_DIFF
		WHERE FactType = 'Assignment'
		ORDER BY studentID, program, AssignmentType,FactType
		
	---1--------------------------------------------------------------------------------------------------------------------
	-- UPDATE THE PrYr_MostRecent FIELDS FROM THE #PRIOR_YEAR_MOST_RECENT_VALUE TABLE
	-----------------------------------------------------------------------------------------------------------------------	
		
		UPDATE DimPreAndPostTag SET

			PrYr_MostRecent_Date		= c.PRIOR_YEAR_MOST_RECENT_DATE, --CASE WHEN c.PRIOR_YEAR_MOST_RECENT_DATE = '' THEN NULL ELSE CONVERT(DATE,c.PRIOR_YEAR_MOST_RECENT_DATE,120)  END,
			PrYr_MostRecent_Value		= c.Assignment_Entered_Grade,    --CASE WHEN c.Assignment_Entered_Grade IS NULL THEN '' ELSE  c.Assignment_Entered_Grade END,
			PrYr_MostRecent_Interval    = c.Quarter,
			Last_Update_Date			= GETDATE()

		FROM DimPreAndPostTag a INNER JOIN #PRIOR_YEAR_MOST_RECENT_VALUE c  
									ON  a.StudentID			= c.StudentID
									AND a.IndicatorArea		= c.program
									AND a.GradeType     	= c.AssignmentType
									AND a.Facttype           = c.Facttype

								
	--2--------------------------------------------------------------------------------------------------------------------------------
	-- First_MPEarliest Data point. This is the first data point that is contained in the first marking period only.
	-- This is not just the first data point in the current year as that could be in marking periods other than 
	-- the first marking period. 
	----------------------------------------------------------------------------------------------------------------------------------								

	UPDATE DimPreAndPostTag SET

			First_MPEarliest_Date     	= CASE WHEN b.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT = '' THEN NULL ELSE CONVERT(DATE,b.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT,120)  END,
			First_MPEarliest_Value		= CASE WHEN b.Assignment_Entered_Grade								= '' THEN NULL ELSE b.Assignment_Entered_Grade END,
		    First_MPEarliest_Interval	= CASE WHEN b.markingperiod IN ('N/A','')   THEN NULL ELSE b.Quarter END,   
			Last_Update_Date            = GETDATE()

		FROM DimPreAndPostTag a INNER JOIN  #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_VALUE b
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
									AND a.Facttype          = b.Facttype


								
	--3---------------------------------------------------------------------------------------------------------------------------------
	-- UPDATE THE CYr_Earliest data point FROM THE #CURRENT_YEAR_FIRST_DATA_POINT_VALUE TABLE
	-----------------------------------------------------------------------------------------------------------------------------------
	
		UPDATE DimPreAndPostTag SET

			CYr_Earliest_Date     		= CASE WHEN b.CURRENT_YEAR_EARLIEST_DATA_POINT = '' THEN NULL ELSE CONVERT(DATE,b.CURRENT_YEAR_EARLIEST_DATA_POINT,120)  END,
			CYr_Earliest_Value			= CASE WHEN b.Assignment_Entered_Grade = '' THEN NULL ELSE b.Assignment_Entered_Grade END,
		    CYr_Earliest_Interval		= CASE WHEN b.markingperiod IN ('N/A','')   THEN NULL ELSE b.Quarter END,   
			Last_Update_Date            = GETDATE()

		FROM DimPreAndPostTag a INNER JOIN  #CURRENT_YEAR_EARLIEST_DATA_POINT_VALUE b
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
									AND a.Facttype          = b.Facttype

	--4-------------------------------------------------------------------------------------------------------------------------
	--UPDATE MID_YEAR_PROXY FROM #MID_YEAR_PROXY_VALUE
	---------------------------------------------------------------------------------------------------------------------------

	UPDATE DimPreAndPostTag SET
			MY_Proxy_Date			= CONVERT(DATE,b.MID_YEAR_PROXY,102),
			MY_Proxy_Value			= b.Assignment_Entered_Grade,
			MY_Proxy_Interval		= b.Quarter,
		    Last_Update_Date		= GETDATE()
	FROM DimPreAndPostTag a INNER JOIN   #MID_YEAR_PROXY_VALUE b 
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
									AND a.Facttype          = b.Facttype

									

    --5-------------------------------------------------------------------------------------------------------------------
	-- UPDATE THE CurrentYearMostRecent and CYLValue FIELDS FROM THE #CURRENT_YEAR_LAST_DATA_POINT_VALUE
	---------------------------------------------------------------------------------------------------------------------

		UPDATE DimPreAndPostTag SET

			CYr_MostRecent_Date			= b.CURRENT_YEAR_LAST_DATA_POINT,
		    CYr_MostRecent_Value		= b.Assignment_Entered_Grade,
			CYr_MostRecent_Interval		= b.Quarter,
			Last_Update_Date			= GETDATE()

		FROM DimPreAndPostTag a INNER JOIN #CURRENT_YEAR_MOST_RECENT_DATA_POINT_VALUE b
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
									AND a.Facttype          = b.Facttype

							
    --6--------------------------------------------------------------------------------------------------------------------
	-- UPDATE CLOSEST DATE TO EARLIEST INTERVENTION DATE
	----------------------------------------------------------------------------------------------------------------------
	 
		UPDATE DimPreAndPostTag SET

			IntStartEnroll_Earliest_Proxy_date		= b.Date,
		    IntStartEnroll_Earliest_Proxy_Value		= b.Assignment_Entered_Grade,
			IntStartEnroll_Earliest_Proxy_Interval	= b.Quarter,
			Last_Update_Date						= GETDATE()

		FROM DimPreAndPostTag a INNER JOIN  #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE b 
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
									
									
	---------------------------------------------------------------------------------------------------------------------  
	--7 UPDATE CLOSEST DATE TO LATEST INTERVENTION DATE
	---------------------------------------------------------------------------------------------------------------------

		 UPDATE DimPreAndPostTag SET

			[IntEndExit_Latest_Proxy_Date]			= b.Date,
		    [IntEndExit_Latest_Proxy_Value]			= b.Assignment_Entered_Grade,
			[IntEndExit_Latest_Proxy_Interval]		= b.Quarter,
			Last_Update_Date						= GETDATE()
		
		 FROM DimPreAndPostTag a INNER JOIN  #INTSTARTENROLL_LATEST_PROXY_DATE_VALUE b
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
								--	AND a.Facttype          = b.Facttype

	---------------------------------------------------------------------------------------------------------------------  
	--8 UPDATE FINAL MP LATEST
	---------------------------------------------------------------------------------------------------------------------

		 UPDATE DimPreAndPostTag SET

			[Final_MPLatest_Date]			= b.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT,
		    [Final_MPLatest_Value]			= b.Assignment_Entered_Grade,
			[Final_MPLatest_Interval]		= b.Quarter,
			Last_Update_Date				= GETDATE()
		
		 FROM DimPreAndPostTag a INNER JOIN  #CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_VALUE b
									ON  a.StudentID			= b.StudentID
									AND a.IndicatorArea		= b.program
									AND a.GradeType     	= b.AssignmentType
								--	AND a.Facttype          = b.Facttype


			 
	--#################################################################################################################
	--END STUDENT TAGGING GRADE BOOK PROCESSING
	--#################################################################################################################

	

	
	

	--#################################################################################################################
	--START STUDENT TAGGING ASSESSMENT PROCESSING
	--#################################################################################################################

	--1--[PrYr_MostRecent_Date]-------------------------------------------------------------------------------------------------------------
	-- PRIOR YEAR MOST RECENT	
	-- SELECT RECORDS WITH A DATA POINT THAT IS THE CLOSEST DATE TO 8/1 BUT BEFORE IT.
	------------------------------------------------------------------------------------------------------------------	

		--SELECT PRIOR_YEAR_MOST_RECENT_DATE DATE
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			MAX(DATE) AS PRIOR_YEAR_MOST_RECENT_DATE   
		INTO #PRIOR_YEAR_MOST_RECENT_ASSESSMENT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE 
		a.facttype = 'Assessment'
		AND   a.DATE Between b.Start_Date and b.End_Date
		AND   b.Quarter = 'Prior Year'
		GROUP BY StudentID,Program,AssignmentType,AssessmentName

		
		-- PICK UP FACTTYPE,ENROLLMENT_DATE,DATA_TYPE_DISPLAY, SCORES AND QUARTER
		SELECT DISTINCT
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			b.Data_Type_Display,
		    b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			a.PRIOR_YEAR_MOST_RECENT_DATE,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date,
			b.SchoolID
        INTO #PRIOR_YEAR_MOST_RECENT_VALUE_ASSESSMENT
		FROM #PRIOR_YEAR_MOST_RECENT_ASSESSMENT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID						= b.studentID
			AND a.program						= b.program 
			AND a.AssignmentType				= b.assignmentType
			AND a.AssessmentName				= b.AssessmentName
			AND a.PRIOR_YEAR_MOST_RECENT_DATE	= b.Date
													INNER JOIN DimSchoolSetup c
													ON  b.schoolID = c.SchoolID
		WHERE a.PRIOR_YEAR_MOST_RECENT_DATE Between c.Start_Date and c.End_Date
		ORDER BY StudentID,Program,AssignmentType,facttype



		SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			PRIOR_YEAR_MOST_RECENT_DATE,
			score,
			Quarter,
			FactType,
			Enrollment_date
			INTO #DATA_TYPE_DISPLAY_PrYr_MostRecent_Date
			FROM #PRIOR_YEAR_MOST_RECENT_VALUE_ASSESSMENT

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			PRIOR_YEAR_MOST_RECENT_DATE,
			score_2             AS score,
			Quarter,
			FactType,
			Enrollment_date
			FROM #PRIOR_YEAR_MOST_RECENT_VALUE_ASSESSMENT
			where data_type_display_2 IS NOT NULL
			
			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			PRIOR_YEAR_MOST_RECENT_DATE,
			score_3             AS score,
			Quarter,
			FactType,
			Enrollment_date
			FROM #PRIOR_YEAR_MOST_RECENT_VALUE_ASSESSMENT
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			PRIOR_YEAR_MOST_RECENT_DATE,
			score_4             AS score,
			Quarter,
			FactType,
			Enrollment_date
			FROM #PRIOR_YEAR_MOST_RECENT_VALUE_ASSESSMENT
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			PRIOR_YEAR_MOST_RECENT_DATE,
			score_5             AS score,
			Quarter,
			FactType,
			Enrollment_date
			FROM #PRIOR_YEAR_MOST_RECENT_VALUE_ASSESSMENT
			where data_type_display_5 IS NOT NULL
			
	

	--2 ASSESSMENT---First_MPEarliest_Interval----------------------------------------------------------------------------------------------------------------
	-- CURRENT YEAR EARLIEST DATA POINT(ASSESSMENT) THAT IS WITHIN THE FIRST MARKING PERIOD. THIS IS THE EARLIEST DATA POINT IN THE SCHOOL YEAR AS 
	-- DETERMINED BY THE MIN DATE THAT IS GREATER THAN 8/1/2014 AND WITHIN FIRST MARKING PERIOD. 
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--PICK UP CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT THAT IS IN MARKING PERIOD 1
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			MIN(Date) AS CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT
		INTO #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE  b.Quarter = 'Quarter 1' 
		AND    a.DATE Between b.Start_Date and b.End_Date
		AND FactType = 'Assessment'
		GROUP BY StudentID,Program,AssignmentType,AssessmentName

		

	-- PICK UP FACTTYPE,ENROLLMENT_DATE,DATA_TYPE_DISPLAY AND SCORES
		SELECT DISTINCT
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			a.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT,
			b.MarkingPeriod,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date,
			b.SchoolID
        INTO #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
		FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID						= b.studentID
			AND a.program						= b.program 
			AND a.AssignmentType				= b.assignmentType
			AND a.AssessmentName				= b.AssessmentName
			AND a.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT	= b.Date
			INNER JOIN DimSchoolSetup c
				ON  b.schoolID = c.SchoolID
				WHERE a.CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT Between c.Start_Date and c.End_Date
				
	

		SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT,
			score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			INTO #DATA_TYPE_DISPLAY_First_MPEarliest_Interval
			FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT_VALUE

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_2 IS NOT NULL
			
			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_FIRST_MARKING_PERIOD_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_5 IS NOT NULL

			
			
		
	--3 ASSESSMENT-----[CYr_Earliest_Date]----------------------------------------------------------------------------------------------------------	
	-- CURRENT YEAR EARLIEST
	------------------------------------------------------------------------------------------------------------------------------
		
		SELECT 
			a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			MIN(a.Date) AS CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT
		INTO #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.DATE Between b.start_date and b.end_date    --b.Start_Date and b.End_Date
		AND FactType = 'Assessment'
		AND Quarter <> 'Prior Year'
		GROUP BY StudentID,Program,AssignmentType,AssessmentName

  
	
	-- PICK UP FACTTYPE,ENROLLMENT_DATE,DATA_TYPE_DISPLAY AND SCORES
		SELECT DISTINCT
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			a.CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT,
			b.MarkingPeriod,
		    c.Quarter,
			b.facttype,
		    b.Enrollment_date
        INTO #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
		FROM #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID						= b.studentID
			AND a.program						= b.program 
			AND a.AssignmentType				= b.assignmentType
			AND a.AssessmentName				= b.AssessmentName
			AND a.CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT	= b.Date
															INNER JOIN DimSchoolSetup c
			ON  b.schoolID = c.SchoolID
			WHERE a.CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT Between c.Start_Date and c.End_Date
			
		

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT,
			score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			INTO #DATA_TYPE_DISPLAY_CYr_Earliest_Date
			FROM #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT_VALUE

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_2 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_EARLIEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_5 IS NOT NULL

			
				
    --4--MY_PROXY_Date--------------------------------------------------------------------------------------------------------------------
	-- MID YEAR DATA POINT. DETERMINED AS THE LATEST DATA POINT BEFORE FEB 15th. CANNOT BE THE SAME AS PRIOR YEAR MOST RECENT
	-- ASSESSMENTS OCCURRED MULTIPLE TIMES PER STUDENTID. ADDED ASSESSMENTID TO GROUP BY. 
	---------------------------------------------------------------------------------------------------------------------------
		SELECT 
			StudentID,
			Program, 
			AssignmentType,
			AssessmentName,
			MAX(DATE) AS MID_YEAR_PROXY_ASSESSMENT   
		INTO #MID_YEAR_PROXY_ASSESSMENT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE 
	        FactType = 'Assessment'
		AND a.Date  <= '2015-02-15'
		AND a.DATE Between b.Start_Date and b.End_Date
		AND a.DATE  >= b.start_date							--CHECK THIS LINE CODE5----------------------------------------------------------------
		AND FactType IN ('Assessment')
		GROUP BY StudentID,Program,AssignmentType,AssessmentName

		

		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			a.MID_YEAR_PROXY_ASSESSMENT,
			b.MarkingPeriod,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date
        INTO  #MID_YEAR_PROXY_ASSESSMENT_VALUE
		FROM  #MID_YEAR_PROXY_ASSESSMENT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID					= b.studentID
			AND a.program					= b.program 
			AND a.AssignmentType			= b.assignmentType
			AND a.AssessmentName			= b.AssessmentName
			AND a.MID_YEAR_PROXY_ASSESSMENT = b.Date
											INNER JOIN DimSchoolSetup c
											ON  b.schoolID = c.SchoolID
			WHERE a.MID_YEAR_PROXY_ASSESSMENT Between c.Start_Date and c.End_Date
			order by studentID

			
			
			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			MID_YEAR_PROXY_ASSESSMENT,
			score,
			MarkingPeriod,
			Quarter,
			Facttype,
			Enrollment_date
			INTO #DATA_TYPE_DISPLAY_MY_PROXY
			FROM #MID_YEAR_PROXY_ASSESSMENT_VALUE

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			MID_YEAR_PROXY_ASSESSMENT,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			Facttype,
			Enrollment_date
			FROM #MID_YEAR_PROXY_ASSESSMENT_VALUE
			where data_type_display_2 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			MID_YEAR_PROXY_ASSESSMENT,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			Facttype,
			Enrollment_date
			FROM #MID_YEAR_PROXY_ASSESSMENT_VALUE
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			MID_YEAR_PROXY_ASSESSMENT,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			Facttype,
			Enrollment_date
			FROM #MID_YEAR_PROXY_ASSESSMENT_VALUE
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			MID_YEAR_PROXY_ASSESSMENT,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			Facttype,
			Enrollment_date
			FROM #MID_YEAR_PROXY_ASSESSMENT_VALUE
			where data_type_display_5 IS NOT NULL

		
		
	--5--[CYr_MostRecent_Date]-------------------------------------------------------------------------------------------------------------
	-- CURRENT YEAR MOST RECENT DATA POINT FOR ASSESSMENT
	-- LAST DATA POINT FROM CURRENT SCHOOL YEAR. THIS IS THE LAST DATA POINT IN THE SCHOOL YEAR AS DETERMINED 
	-- BY THE MAX(DATE) THAT IS BETWEEN '2014-08-01' and '2015-06-30'
	--------------------------------------------------------------------------------------------------------------------
		
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			MAX(Date) AS CURRENT_YEAR_LAST_DATA_POINT  
		INTO #CURRENT_YEAR_LAST_DATA_POINT_ASSESSMENT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.DATE Between b.year_start_date and b.year_end_date    
		AND FactType = 'Assessment'
		AND Quarter <> 'Prior Year'
		GROUP BY StudentID,Program,AssignmentType,AssessmentName

		
	-- PICK UP DATA_TYPE_DISPLAY AND SCORE
		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			a.CURRENT_YEAR_LAST_DATA_POINT,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			b.MarkingPeriod,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date

        INTO  #CURRENT_YEAR_LAST_DATA_POINT_VALUE_ASSESSMENT
		FROM #CURRENT_YEAR_LAST_DATA_POINT_ASSESSMENT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID								= b.studentID
			and a.program								= b.program 
			and a.AssignmentType						= b.assignmentType
			AND a.AssessmentName						= b.AssessmentName
			and a.CURRENT_YEAR_LAST_DATA_POINT			= b.Date			
														INNER JOIN DimSchoolSetup c
														ON  b.schoolID = c.SchoolID
		WHERE a.CURRENT_YEAR_LAST_DATA_POINT Between c.Start_date and c.End_Date
        ORDER BY StudentID,Program,AssignmentType,AssessmentName


		SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			CURRENT_YEAR_LAST_DATA_POINT,
			score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			INTO #DATA_TYPE_DISPLAY_CYr_MostRecent_Date
			FROM #CURRENT_YEAR_LAST_DATA_POINT_VALUE_ASSESSMENT

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			CURRENT_YEAR_LAST_DATA_POINT,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #CURRENT_YEAR_LAST_DATA_POINT_VALUE_ASSESSMENT
			where data_type_display_2 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			CURRENT_YEAR_LAST_DATA_POINT,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #CURRENT_YEAR_LAST_DATA_POINT_VALUE_ASSESSMENT
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			CURRENT_YEAR_LAST_DATA_POINT,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #CURRENT_YEAR_LAST_DATA_POINT_VALUE_ASSESSMENT
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			CURRENT_YEAR_LAST_DATA_POINT,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #CURRENT_YEAR_LAST_DATA_POINT_VALUE_ASSESSMENT
			where data_type_display_5 IS NOT NULL

	
	
	--6--[IntStartEnroll_Earliest_Proxy_Date]------------------------------------------------------------------------------------
	-- THE EARLIEST INTERVENTION START DATE IS FOUND PER STUDENTID,PROGRAM,ASSIGNMENTTYPE. THEN THE CLOSEST DATE TO THE EARLIEST 
	-- INTERVENTION DATE, THAT IS OF FACTTYPE ASSESSMENT, IS FOUND.   
	-----------------------------------------------------------------------------------------------------------------------------

			--FIND THE MAX DATE LESS THAN EARLIEST INTERVENTION DATE
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MAX(a.Date) AS DATE
			INTO  #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #EARLIEST_INT_START_DATE   b    -- #DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date < b.Earliest_Int_Start_Date
			AND   a.Facttype = 'Assessment'
			AND   a.Program  = b.Section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName

		UNION ALL
	
			--FIND THE MIN DATE GREATER THAN EARLIEST INTERVENTION DATE
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MIN(a.Date) AS DATE
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #EARLIEST_INT_START_DATE   b				--#DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
									   INNER JOIN DimSchoolSetup c
									   ON  a.schoolID = c.SchoolID
			WHERE a.Date > b.Earliest_Int_Start_Date
			AND   a.Date between c.Start_Date and c.End_Date								--b.Date_Difference_From_Intervention_Enrollment
			AND   c.Quarter <> 'Prior Year'
			AND   a.Facttype = 'Assessment'
			AND   a.Program  = b.Section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName

			

-------------------------------------------------------------------------------------------------------------------------------------------------------			 
--THE #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE TABLE CONTAINS THE BEFORE AND AFTER,CLOSEST DATES TO THE EARLIEST INTERVENTION DATE.
--IF THERE IS A BEFORE AND AFTER DATE THEN SELECTING THE MIN DATE WILL BRING BACK THE BEFORE DATE WHICH IS THE FIRST PRIORITY DATE.  
--IF EITHER THE BEFORE OR AFTER DATE ARE MISSING THEN THE MIN DATE WILL BE WHAT EVER DATE IS AVAILABLE
--------------------------------------------------------------------------------------------------------------------------------------------------------

			SELECT 
			  SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName,
			  MIN(Date) AS DATE
			INTO #CLOSEST_ASSESSMENT_DATE_TO_EARLIEST_INTERVENTION_DATE
			FROM #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE
			GROUP BY
			  SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName


-- PICK UP DATA_TYPE_DISPLAY AND SCORE
		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			a.DATE,                        --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			b.MarkingPeriod,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date

        INTO  #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE_ASSESSMENT
		FROM #CLOSEST_ASSESSMENT_DATE_TO_EARLIEST_INTERVENTION_DATE a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID								= b.studentID
			and a.program								= b.program 
			and a.AssignmentType						= b.assignmentType
			AND a.AssessmentName						= b.AssessmentName
			and a.DATE									= b.Date			
														INNER JOIN DimSchoolSetup c
														ON  b.schoolID = c.SchoolID
		WHERE a.DATE Between c.Start_date and c.End_Date
		AND QUARTER <> 'Prior Year'
        ORDER BY StudentID,Program,AssignmentType,AssessmentName


		SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			DATE,    --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			INTO #DATA_TYPE_DISPLAY_IntStartEnroll_Earliest_Proxy_Date
			FROM #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE_ASSESSMENT
			

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			DATE,                                           --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_2 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			DATE,                                      --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			DATE,                                      --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			DATE,                                      --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTSTARTENROLL_EARLIEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_5 IS NOT NULL

	
	--7--[IntEndExit_Latest_Proxy_Date]------------------------------------------------------------------------------------------------------------------------
	-- THE LATEST INTERVENTION DATE IS FOUND PER STUDENTID,PROGRAM,ASSIGNMENTTYPE. THEN THE CLOSEST DATE TO THE LATEST 
	-- INTERVENTION DATE, THAT IS OF FACTTYPE ASSESSEMENT, IS FOUND.  
	-----------------------------------------------------------------------------------------------------------------------------
	
	--FIND LATEST INTERVENTION END DATE

			select studentID,Section_IA,MAX(StuSec_End) AS Latest_Int_End_Date
			INTO #LATEST_INT_START_DATE
			from #Student_Section_Start_End_Dates
			Where StuSec_End <> '1900-01-01 00:00:00.000'
			group by CY_Student_ID,studentID,Section_IA

			

			--FIND THE MAX DATE LESS THAN LATEST INTERVENTION DATE
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MAX(a.Date) AS DATE
			INTO  #DATES_LESS_THAN_AND_GREATER_THAN_LATEST_INT_DATE
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #LATEST_INT_START_DATE   b    -- #DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date < b.Latest_Int_End_Date
			AND   a.Facttype = 'Assessment'
			AND   a.program  = b.section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName

		UNION ALL
			
			--FIND THE MIN DATE GREATER THAN EARLIEST INTERVENTION DATE
			SELECT 
			  a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName,
			  MIN(a.Date) AS DATE
			FROM  #PRE_TAG_DATE_DIFF a INNER JOIN #LATEST_INT_START_DATE   b    --#DIFFERENCE_BETWEEN_DATE_AND_EARLIEST_INT_DATE b
									   ON a.studentID = b.studentID
			WHERE a.Date > b.Latest_Int_End_Date								--b.Date_Difference_From_Intervention_Enrollment
			AND   a.Facttype = 'Assessment'
			AND   a.program  = b.section_IA
			GROUP BY a.SchoolID,
			  a.StudentID,
			  a.Program,
			  a.AssignmentType,
			  a.AssessmentName


-------------------------------------------------------------------------------------------------------------------------------------------------------			 
--THE #DATES_LESS_THAN_AND_GREATER_THAN_EARLIEST_INT_DATE TABLE CONTAINS THE BEFORE AND AFTER,CLOSEST DATES TO THE LATEST INTERVENTION DATE.
--IF THERE IS A BEFORE AND AFTER DATE THEN SELECTING THE MAX DATE WILL BRING BACK THE AFTER DATE WHICH IS THE FIRST PRIORITY DATE.  
--IF EITHER THE BEFORE OR AFTER DATE ARE MISSING THEN THE MAX DATE WILL BE WHAT EVER DATE IS AVAILABLE.
--------------------------------------------------------------------------------------------------------------------------------------------------------

			SELECT 
			  SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName,
			  MAX(Date) AS DATE
			INTO #CLOSEST_ASSESSMENT_DATE_TO_LATEST_INTERVENTION_DATE
			FROM #DATES_LESS_THAN_AND_GREATER_THAN_LATEST_INT_DATE
			GROUP BY
			  SchoolID,
			  StudentID,
			  Program,
			  AssignmentType,
			  AssessmentName



-- PICK UP DATA_TYPE_DISPLAY AND SCORE
		SELECT 
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			a.DATE,                        --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			b.MarkingPeriod,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date

        INTO #INTENDEXIT_LATEST_PROXY_DATE_VALUE_ASSESSMENT
		FROM #CLOSEST_ASSESSMENT_DATE_TO_LATEST_INTERVENTION_DATE a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID								= b.studentID
			and a.program								= b.program 
			and a.AssignmentType						= b.assignmentType
			AND a.AssessmentName						= b.AssessmentName
			and a.DATE									= b.Date			
														INNER JOIN DimSchoolSetup c
														ON  b.schoolID = c.SchoolID
		WHERE a.DATE Between c.Start_date and c.End_Date
        ORDER BY StudentID,Program,AssignmentType,AssessmentName


		SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			DATE,    --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			INTO #DATA_TYPE_DISPLAY_IntEndExit_Enroll_latest_Proxy_Date   
			FROM #INTENDEXIT_LATEST_PROXY_DATE_VALUE_ASSESSMENT

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			DATE,                                           --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTENDEXIT_LATEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_2 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			DATE,                                      --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTENDEXIT_LATEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			DATE,                                      --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTENDEXIT_LATEST_PROXY_DATE_VALUE_ASSESSMENT  
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			DATE,                                      --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			facttype,
		    Enrollment_date
			FROM #INTENDEXIT_LATEST_PROXY_DATE_VALUE_ASSESSMENT
			where data_type_display_5 IS NOT NULL





	--8 ASSESSMENT---[Final_MPLatest_Date]----------------------------------------------------------------------------------------------------------------
	-- CURRENT YEAR LATEST DATA POINT(ASSESSMENT) THAT IS WITHIN THE LAST MARKING PERIOD. THIS IS THE LATEST DATA POINT IN THE SCHOOL YEAR AS 
	-- DETERMINED BY THE MAX DATE THAT IS GREATER THAN 8/1/2014 AND WITHIN LAST MARKING PERIOD. 
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--PICK UP CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT THAT IS IN MARKING PERIOD 4
		SELECT 
			StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			MAX(Date) AS CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT
		INTO #CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT
		FROM #PRE_TAG_DATE_DIFF a INNER JOIN DimSchoolSetup b
		                          ON a.SchoolID = b.SchoolID
		WHERE a.DATE Between b.Start_Date and b.End_Date
		AND FactType = 'Assessment'
		AND Quarter = 'Quarter 4'
		GROUP BY StudentID,Program,AssignmentType,AssessmentName


	-- PICK UP FACTTYPE,ENROLLMENT_DATE,DATA_TYPE_DISPLAY AND SCORES
		SELECT DISTINCT
		    a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			b.Data_Type_Display,
			b.score,
			b.Data_Type_Display_2,
			b.Score_2,
			b.Data_Type_Display_3,
			b.Score_3,
			b.Data_Type_Display_4,
			b.Score_4,
			b.Data_Type_Display_5,
			b.Score_5,
			a.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT,
			b.MarkingPeriod,
			c.Quarter,
			b.facttype,
		    b.Enrollment_date,
			b.SchoolID
        INTO #CURRENT_YEAR_LAST_MARKING_PERIOD_LASTEST_DATA_POINT_ASSESSMENT_VALUE
		FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT a INNER JOIN #PRE_TAG_DATE_DIFF b
			ON  a.studentID						= b.studentID
			AND a.program						= b.program 
			AND a.AssignmentType				= b.assignmentType
			AND a.AssessmentName				= b.AssessmentName
			AND a.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT	= b.Date
			INNER JOIN DimSchoolSetup c
				ON  b.schoolID = c.SchoolID
				WHERE a.CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT Between c.Start_Date and c.End_Date
				AND Quarter = 'Quarter 4'



		SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT,
			score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			INTO #DATA_TYPE_DISPLAY_Last_MPLatest_Interval
			FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LASTEST_DATA_POINT_ASSESSMENT_VALUE

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_2 AS data_type_display,
			CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT,
			score_2             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LASTEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_2 IS NOT NULL
			
			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_3 AS data_type_display,
			CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT,
			score_3             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LASTEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_3 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_4 AS data_type_display,
			CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT,
			score_4             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LASTEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_4 IS NOT NULL

			UNION

			SELECT DISTINCT
		    StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display_5 AS data_type_display,
			CURRENT_YEAR_LAST_MARKING_PERIOD_LATEST_DATA_POINT_ASSESSMENT,
			score_5             AS score,
			MarkingPeriod,
			Quarter,
			FactType,
			Enrollment_date
			FROM #CURRENT_YEAR_LAST_MARKING_PERIOD_LASTEST_DATA_POINT_ASSESSMENT_VALUE
			where data_type_display_5 IS NOT NULL

	

	
	--ASSESSMENT------------------------------------------------------------------------------------------------------------------------
	--INSERT ASSESSMENT RECORDS INTO PREandPostSTAGE TABLE. THIS WILL INSERT ALL STUDENTS GROUPED BY STUDENT,
	--PROGRAM,ASSIGNMENTTYPE(AssessmentName),ENROLLMENT_DATE COMBINATIONS TO BE UPDATED wirh Assessment Data. 
	--------------------------------------------------------------------------------------------------------------------------
	
	

--1st DATA POINT: INSERT THE "PrYr_MostRecent_Date" DATA POINT TO STAGE.------------------------------------------------------------------------------------------------------------------------------------------------

			INSERT INTO PREandPostSTAGE 
			(StudentID,
			 Program,
			 AssignmentType,
			 AssessmentName,
			 data_type_display,
			 School_EnrollmentDate,
			 PrYr_MostRecent_Date,
			 PrYr_MostRecent_Value,
			 PrYr_MostRecent_Interval)
			select 
				StudentID,
				Program,
				AssignmentType,
				AssessmentName,
				data_type_display,
				Enrollment_date,
				prior_year_most_recent_date,
				score,
				Quarter
			from #DATA_TYPE_DISPLAY_PrYr_MostRecent_Date	


--2nd DATA POINT: INSERT AND UPDATE THE "First_MPEarliest_Date" DATA POINT TO STAGE.----------------------------------------------------------------------------------------------------------------------------


				INSERT INTO PREandPostSTAGE 
				(StudentID,
				 Program,
				 AssignmentType,
				 AssessmentName,
				 data_type_display,
				 School_EnrollmentDate,
				 First_MPEarliest_Date,
				 First_MPEarliest_Value,
				 First_MPEarliest_Interval)
				select 
					a.StudentID,
					a.Program,
					a.AssignmentType,
					a.AssessmentName,
					a.data_type_display,
					a.enrollment_date,
					a.current_year_first_marking_period_earliest_data_point_assessment,
					a.score,
					a.quarter
				FROM #DATA_TYPE_DISPLAY_First_MPEarliest_Interval a LEFT OUTER JOIN PREandPostSTAGE b ON a.studentID		= b.StudentID
																								AND a.program				= b.program
																								AND a.assignmentType		= b.AssignmentType
																								AND a.assessmentname		= b.assessmentname
																								AND a.Data_Type_display		= b.Data_type_display
				where b.studentID			IS NULL
				AND   b.program				IS NULL
				AND   b.AssignmentType		IS NULL
				AND   b.assessmentname		IS NULL
				AND   b.Data_type_display	IS NULL
	
			--UPDATE THE SECOND DATA POINT WHERE THE RECORD EXISTS AND THE SECOND DATA POINT VALUES ARE NULL

			UPDATE PREandPostSTAGE SET
			  StudentID					=	b.studentID,
			  Program					=	b.Program,
			  AssignmentType			=   b.AssignmentType,
			  AssessmentName			=	b.AssessmentName,
			  data_type_display			=	b.data_type_display,
			  First_MPEarliest_Date		=	b.current_year_first_marking_period_earliest_data_point_assessment,
			  First_MPEarliest_Value	=	b.score,
			  First_MPEarliest_Interval	=	b.Quarter

			FROM PREandPostSTAGE a inner join #DATA_TYPE_DISPLAY_First_MPEarliest_Interval b
								ON  a.studentID			= b.StudentID
								AND a.program			= b.program
								AND a.assignmentType	= b.AssignmentType
								AND a.assessmentname	= b.assessmentname
								AND a.Data_Type_display	= b.Data_type_display
			where First_MPEarliest_Date		IS NULL
			AND   First_MPEarliest_Value	IS NULL
			AND   First_MPEarliest_Interval	IS NULL


--3rd DATA POINT: INSERT AND UPDATE THE "CYr_Earliest_Date" DATA POINT TO STAGE. --------------------------------------------------------------------------------------------------

			INSERT INTO PREandPostSTAGE 
			(StudentID,
			 Program,
			 AssignmentType,
			 AssessmentName,
			 data_type_display,
			 School_EnrollmentDate,
			 CYr_Earliest_Date,
			 CYr_Earliest_Value,
			 CYr_Earliest_Interval)
			select 
				a.StudentID,
				a.Program,
				a.AssignmentType,
				a.AssessmentName,
				a.data_type_display,
				a.enrollment_date,
				a.current_year_earliest_data_point_assessment,
				a.score,
			--	a.markingperiod,
				a.quarter
			FROM #DATA_TYPE_DISPLAY_CYr_Earliest_Date a LEFT OUTER JOIN PREandPostSTAGE b ON a.studentID			= b.StudentID
																				  AND a.program				= b.program
																				  AND a.assignmentType		= b.AssignmentType
																				  AND a.assessmentname		= b.assessmentname
																				  AND a.Data_Type_display	= b.Data_type_display
	
			where b.studentID			IS NULL
			AND   b.program				IS NULL
			AND   b.AssignmentType		IS NULL
			AND   b.assessmentname		IS NULL
			AND   b.Data_type_display	IS NULL
	

			--UPDATE THE THIRD DATA POINT WHERE THE RECORD EXISTS AND THE THIRD DATA POINT VALUES ARE NULL

			 UPDATE PREandPostSTAGE SET
			 StudentID				=	b.studentID,
		     Program				=	b.Program,
			 AssignmentType			=   b.AssignmentType,
			 AssessmentName			=	b.AssessmentName,
			 data_type_display		=	b.data_type_display,
			 CYr_Earliest_Date		=	b.current_year_earliest_data_point_assessment,
			 CYr_Earliest_Value		=	b.score,
			 CYr_Earliest_Interval	=	b.Quarter

			  FROM PREandPostSTAGE a inner join #DATA_TYPE_DISPLAY_CYr_Earliest_Date b
									ON  a.studentID			= b.StudentID
									AND a.program			= b.program
									AND a.assignmentType	= b.AssignmentType
									AND a.assessmentname	= b.assessmentname
									AND a.Data_Type_display	= b.Data_type_display
			 where CYr_Earliest_Date		IS NULL
			 AND   CYr_Earliest_Value		IS NULL
			 AND   CYr_Earliest_Interval	IS NULL

			

--4th DATA POINT: INSERT AND UPDATE THE "MY_Proxy_Date" DATA POINT TO STAGE. --------------------------------------------------------------------------------------------------
						
		

		INSERT INTO PREandPostSTAGE 
			(StudentID,
			Program,
			AssignmentType,
			AssessmentName,
			data_type_display,
			School_EnrollmentDate,
			MY_Proxy_Date,
			MY_Proxy_Value,
			MY_Proxy_Interval)
		select 
			a.StudentID,
			a.Program,
			a.AssignmentType,
			a.AssessmentName,
			a.data_type_display,
			a.enrollment_date,
			a.mid_year_proxy_assessment,
			a.score,
			a.Quarter
		FROM #DATA_TYPE_DISPLAY_MY_PROXY a LEFT OUTER JOIN PREandPostSTAGE b ON a.studentID				= b.StudentID
																			  AND a.program				= b.program
																			  AND a.assignmentType		= b.AssignmentType
																			  AND a.assessmentname		= b.assessmentname
																			  AND a.Data_Type_display	= b.Data_type_display
	
		where b.studentID			IS NULL
		AND   b.program				IS NULL
		AND   b.AssignmentType		IS NULL
		AND   b.assessmentname		IS NULL
		AND   b.Data_type_display	IS NULL
	

			--UPDATE THE FOURTH DATA POINT WHERE THE RECORD EXISTS AND THE FOURTH DATA POINT VALUES ARE NULL

			UPDATE PREandPostSTAGE SET
			StudentID				=	b.studentID,
			Program					=	b.Program,
			AssignmentType			=   b.AssignmentType,
			AssessmentName			=	b.AssessmentName,
			data_type_display		=	b.data_type_display,
			MY_Proxy_Date			=	b.mid_year_proxy_assessment,
			MY_Proxy_Value			=	b.score,
			MY_Proxy_Interval		=	b.Quarter

			FROM PREandPostSTAGE a inner join #DATA_TYPE_DISPLAY_MY_PROXY b
								ON  a.studentID			= b.StudentID
								AND a.program			= b.program
								AND a.assignmentType	= b.AssignmentType
								AND a.assessmentname	= b.assessmentname
								AND a.Data_Type_display	= b.Data_type_display
			where MY_Proxy_Date		IS NULL
			AND   MY_Proxy_Value	IS NULL
			AND   MY_Proxy_Interval	IS NULL

			

--5th DATA POINT: INSERT AND UPDATE THE "CYr_MostRecent_Date" DATA POINT TO STAGE. --------------------------------------------------------------------------------------------------


	

		INSERT INTO PREandPostSTAGE 
		(StudentID,
		 Program,
		 AssignmentType,
		 AssessmentName,
		 data_type_display,
		 School_EnrollmentDate,
		 CYr_MostRecent_Date,
		 CYr_MostRecent_Value,
		 CYr_MostRecent_Interval)
		select 
		 a.StudentID,
		 a.Program,
		 a.AssignmentType,
		 a.AssessmentName,
		 a.data_type_display,
		 a.enrollment_date,
		 a.current_year_last_data_point,
		 a.score,
		 a.Quarter
		FROM #DATA_TYPE_DISPLAY_CYr_MostRecent_Date a LEFT OUTER JOIN PREandPostSTAGE b ON a.studentID			= b.StudentID
																			  AND a.program				= b.program
																			  AND a.assignmentType		= b.AssignmentType
																			  AND a.assessmentname		= b.assessmentname
																			  AND a.Data_Type_display	= b.Data_type_display
		where b.studentID			IS NULL
		AND   b.program				IS NULL
		AND   b.AssignmentType		IS NULL
		AND   b.assessmentname		IS NULL
		AND   b.Data_type_display	IS NULL
	

			--UPDATE THE FIFTH DATA POINT WHERE THE RECORD EXISTS AND THE FIFTH DATA POINT VALUES ARE NULL

			UPDATE PREandPostSTAGE SET
			StudentID				=	b.studentID,
			Program					=	b.Program,
			AssignmentType			=   b.AssignmentType,
			AssessmentName			=	b.AssessmentName,
			data_type_display		=	b.data_type_display,
			CYr_MostRecent_Date		=	b.current_year_last_data_point,
			CYr_MostRecent_Value	=	b.score,
			CYr_MostRecent_Interval	=	b.Quarter

			FROM PREandPostSTAGE a inner join #DATA_TYPE_DISPLAY_CYr_MostRecent_Date b
								ON  a.studentID			= b.StudentID
								AND a.program			= b.program
								AND a.assignmentType	= b.AssignmentType
								AND a.assessmentname	= b.assessmentname
								AND a.Data_Type_display	= b.Data_type_display
			where CYr_MostRecent_Date		IS NULL
			AND   CYr_MostRecent_Value 		IS NULL
			AND   CYr_MostRecent_Interval	IS NULL

			

--6th DATA POINT: INSERT AND UPDATE THE "IntStartEnroll_Earliest_Proxy_Date" DATA POINT TO STAGE. --------------------------------------------------------------------------------------------------

		
		 
	
		INSERT INTO PREandPostSTAGE 
		(StudentID,
		 Program,
		 AssignmentType,
		 AssessmentName,
		 data_type_display,
		 School_EnrollmentDate,
		 IntStartEnroll_Earliest_Proxy_Date,
		 IntStartEnroll_Earliest_Proxy_Value,
		 IntStartEnroll_Earliest_Proxy_Interval)
		select 
		 a.StudentID,
		 a.Program,
		 a.AssignmentType,
		 a.AssessmentName,
		 a.data_type_display,
		 a.enrollment_date,
		 a.DATE,    --INTSTARTENROLL_EARLIEST_PROXY_DATE,
		 a.score,
		 a.Quarter
		FROM #DATA_TYPE_DISPLAY_IntStartEnroll_Earliest_Proxy_Date a LEFT OUTER JOIN PREandPostSTAGE b 
																			  ON a.studentID			= b.StudentID
																			  AND a.program				= b.program
																			  AND a.assignmentType		= b.AssignmentType
																			  AND a.assessmentname		= b.assessmentname
																			  AND a.Data_Type_display	= b.Data_type_display
		where b.studentID			IS NULL
		AND   b.program				IS NULL
		AND   b.AssignmentType		IS NULL
		AND   b.assessmentname		IS NULL
		AND   b.Data_type_display	IS NULL
	

			--UPDATE THE SIXTH DATA POINT WHERE THE RECORD EXISTS AND THE SIXTH DATA POINT VALUES ARE NULL

			UPDATE PREandPostSTAGE SET
			StudentID								=	b.studentID,
			Program									=	b.Program,
			AssignmentType							=   b.AssignmentType,
			AssessmentName							=	b.AssessmentName,
			data_type_display						=	b.data_type_display,
			IntStartEnroll_Earliest_Proxy_Date		=	b.DATE,                   --INTSTARTENROLL_EARLIEST_PROXY_DATE,
			IntStartEnroll_Earliest_Proxy_Value		=	b.score,
			IntStartEnroll_Earliest_Proxy_Interval	=	b.Quarter

			FROM PREandPostSTAGE   a inner join #DATA_TYPE_DISPLAY_IntStartEnroll_Earliest_Proxy_Date  b
								ON  a.studentID			= b.StudentID
								AND a.program			= b.program
								AND a.assignmentType	= b.AssignmentType
								AND a.assessmentname	= b.assessmentname
								AND a.Data_Type_display	= b.Data_type_display
			where a.IntStartEnroll_Earliest_Proxy_Date		IS NULL
			AND   a.IntStartEnroll_Earliest_Proxy_Value 	IS NULL
			AND   a.IntStartEnroll_Earliest_Proxy_Interval 	IS NULL


			
--7th DATA POINT: INSERT AND UPDATE THE "IntEndExit_Latest_Proxy_Date" DATA POINT TO STAGE. --------------------------------------------------------------------------------------------------
		 

	INSERT INTO PREandPostSTAGE 
		(StudentID,
		 Program,
		 AssignmentType,
		 AssessmentName,
		 data_type_display,
		 IntEndExit_Latest_Proxy_Date,
		 School_EnrollmentDate,
		 IntEndExit_Latest_Proxy_Value,
		 IntEndExit_Latest_Proxy_Interval)
		select 
		 a.StudentID,			
		 a.Program,
		 a.AssignmentType,
		 a.AssessmentName,
		 a.data_type_display,
		 a.enrollment_date,
		 a.date,
		 a.score,
		 a.Quarter
		FROM #DATA_TYPE_DISPLAY_IntEndExit_Enroll_latest_Proxy_Date a LEFT OUTER JOIN PREandPostSTAGE b 
																			  ON a.studentID			= b.StudentID
																			  AND a.program				= b.program
																			  AND a.assignmentType		= b.AssignmentType
																			  AND a.assessmentname		= b.assessmentname
																			  AND a.Data_Type_display	= b.Data_type_display
		where b.studentID			IS NULL
		AND   b.program				IS NULL
		AND   b.AssignmentType		IS NULL
		AND   b.assessmentname		IS NULL
		AND   b.Data_type_display	IS NULL
	

			--UPDATE THE 7TH DATA POINT WHERE THE RECORD EXISTS AND THE 7TH DATA POINT VALUES ARE NULL

			UPDATE PREandPostSTAGE SET
			StudentID								=	b.studentID,
			Program									=	b.Program,
			AssignmentType							=   b.AssignmentType,
			AssessmentName							=	b.AssessmentName,
			data_type_display						=	b.data_type_display,
			IntEndExit_Latest_Proxy_Date			=	b.date,
			IntEndExit_Latest_Proxy_Value			=	b.score,
			IntEndExit_Latest_Proxy_Interval		=	b.Quarter

			FROM PREandPostSTAGE a inner join  #DATA_TYPE_DISPLAY_IntEndExit_Enroll_latest_Proxy_Date b
								ON  a.studentID			= b.StudentID
								AND a.program			= b.program
								AND a.assignmentType	= b.AssignmentType
								AND a.assessmentname	= b.assessmentname
								AND a.Data_Type_display	= b.Data_type_display
			where IntEndExit_Latest_Proxy_Date		IS NULL
			AND   IntEndExit_Latest_Proxy_Value 	IS NULL
			AND   IntEndExit_Latest_Proxy_Interval 	IS NULL


--8TH DATA POINT: INSERT AND UPDATE THE "Final_MPLatest_Date" DATA POINT TO STAGE.----------------------------------------------------------------------------------------------------------------------------

				INSERT INTO PREandPostSTAGE 
				(StudentID,
				 Program,
				 AssignmentType,
				 AssessmentName,
				 data_type_display,
				 School_EnrollmentDate,
				 Final_MPLatest_Date,
				 Final_MPLatest_Value,
				 Final_MPLatest_Interval)
				select 
					a.StudentID,
					a.Program,
					a.AssignmentType,
					a.AssessmentName,
					a.data_type_display,
					a.enrollment_date,
					a.current_year_last_marking_period_latest_data_point_assessment,
					a.score,
					a.quarter
				FROM #DATA_TYPE_DISPLAY_Last_MPLatest_Interval a LEFT OUTER JOIN PREandPostSTAGE b ON a.studentID		= b.StudentID
																								AND a.program				= b.program
																								AND a.assignmentType		= b.AssignmentType
																								AND a.assessmentname		= b.assessmentname
																								AND a.Data_Type_display		= b.Data_type_display
				where b.studentID			IS NULL
				AND   b.program				IS NULL
				AND   b.AssignmentType		IS NULL
				AND   b.assessmentname		IS NULL
				AND   b.Data_type_display	IS NULL
	
			--UPDATE THE SECOND DATA POINT WHERE THE RECORD EXISTS AND THE SECOND DATA POINT VALUES ARE NULL

			UPDATE PREandPostSTAGE SET
			  StudentID				=	b.studentID,
			  Program				=	b.Program,
			  AssignmentType		=   b.AssignmentType,
			  AssessmentName		=	b.AssessmentName,
			  data_type_display		=	b.data_type_display,
			  Final_MPLatest_Date	=	b.current_year_last_marking_period_latest_data_point_assessment,
			  Final_MPLatest_Value	=	b.score,
			  Final_MPLatest_Interval	=	b.Quarter

			FROM PREandPostSTAGE a inner join #DATA_TYPE_DISPLAY_Last_MPLatest_Interval b
								ON  a.studentID			= b.StudentID
								AND a.program			= b.program
								AND a.assignmentType	= b.AssignmentType
								AND a.assessmentname	= b.assessmentname
								AND a.Data_Type_display	= b.Data_type_display
			where Final_MPLatest_Date		IS NULL
			AND   Final_MPLatest_Value		IS NULL
			AND   Final_MPLatest_Interval	IS NULL

--INSERT INTO DIMPREANDPOSTTAG TABLE---------------------------------------------------------------------------------

		INSERT INTO DimPreAndPostTag 
		SELECT 
					 StudentID, 
					 Program, 
					 AssessmentName,
					 data_type_display,
					 'Assessment',
					 School_Enrollmentdate,
					 PrYr_MostRecent_Date,
					 PrYr_MostRecent_Value,
					 PrYr_MostRecent_Interval,
					 First_MPEarliest_Date,
					 First_MPEarliest_Value,
					 First_MPEarliest_Interval,
					 CYr_Earliest_Date,
					 CYr_Earliest_Value,
					 CYr_Earliest_Interval,
					 MY_Proxy_Date,
					 MY_Proxy_Value,
					 MY_Proxy_Interval,
					 CYr_MostRecent_Date,
					 CYr_MostRecent_Value,
					 CYr_MostRecent_Interval,
					 IntStartEnroll_Earliest_Proxy_Date,
					 IntStartEnroll_Earliest_Proxy_Value,
					 IntStartEnroll_Earliest_Proxy_Interval,
					 IntEndExit_Latest_Proxy_Date,
					 IntEndExit_Latest_Proxy_Value,
					 IntEndExit_Latest_Proxy_Interval,
					 Final_MPLatest_Date,
					 Final_MPLatest_Value,
					 Final_MPLatest_Interval,
					 GETDATE(),
					 CYSCHOOLHOUSE_ID
					 
				FROM PREandPostSTAGE
				
				ORDER BY studentID, program, AssessmentName


	-----------------------------------------------------------------------
    --REPLACE GRADETYPE 'YEARLY ADA' WITH 'YEAR TO DATE ADA'
	-----------------------------------------------------------------------
	
			UPDATE DimPreAndPostTag SET
			GradeType = 'YEARLY ADA'
			WHERE GradeType =  'Year To Date ADA'

	----------------------------------------------------------------------------------------------------------------------------
	--PICK UP CY_SCHOOLHOUSE_ID
	----------------------------------------------------------------------------------------------------------------------------
	
			UPDATE DimPreAndPostTag SET 
			CYSCHOOLHOUSE_ID  = CY_StudentID
			FROM DimPreAndPostTag a LEFT OUTER JOIN DimStudent b
									ON a.StudentID = b.StudentID 

	----------------------------------------------------------------------------------------------------------------------------
	--UPDATE INDICATORAREA FOR ASSESSMENTS
	----------------------------------------------------------------------------------------------------------------------------
	

			UPDATE DimPreAndPostTag SET 
			IndicatorArea = Related_IA
			FROM  DimPreAndPostTag a left outer join AssessmentIA b
									on a.GradeType = b.Assessment_Name
			WHERE a.Facttype = 'Assessment'
			AND IndicatorArea = 'other'
	


	----------------------------------------------------------- END PROCESSING------------------------------------------------------------------------------------------------------------------------

END




GO
