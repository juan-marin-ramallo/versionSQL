/****** Object:  Procedure [dbo].[DashboardPersonsIndicator]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 11/10/2019
-- Description:	SP para obtener indicador de tareas
-- =============================================
CREATE PROCEDURE [dbo].[DashboardPersonsIndicator]
	@IdUser [sys].[int] = NULL
	,@DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL

AS
BEGIN

DECLARE @NoActivity [sys].numeric
DECLARE @NoRoute [sys].numeric

SET	@NoActivity = dbo.DashboardPersonsOfInterestWithNoActivity(@IdUser)

SET	@NoRoute = dbo.DashboardPersonsOfInterestWithNoRoute(@IdUser, @DateFrom, @DateTo)


	SELECT		Count (distinct S.[Id]) AS TotalPersons, 
					SUM(CASE WHEN (Tzdb.AreSameSystemDates(L.[Date], GETUTCDATE()) = 1) THEN 1 ELSE 0 END) AS POnline,
					@NoActivity AS NoActivity,
					@NoRoute AS NoRoute
	FROM		[dbo].[AvailablePersonOfInterest] S
				LEFT OUTER JOIN [dbo].[CurrentLocation] L ON S.[Id] = L.[IdPersonOfInterest]
		
	WHERE		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
				



	--GROUP BY	 
	--			L.[Date]
				

	
END
