/****** Object:  ScalarFunction [dbo].[DashboardPersonsOfInterestWithNoActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 24/10/2019
-- Description:	FC para obtener las Personas de Interes que no llevaron adelante ninguna actividad en el correr del dìa
-- =============================================
CREATE FUNCTION [dbo].[DashboardPersonsOfInterestWithNoActivity]
(
	@IdUser [sys].[int]
)
returns [sys].numeric
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()
	DECLARE @Result [sys].numeric
		SET @Result = (

	SELECT	Count(Distinct P.[Id])
	FROM	[dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterestSchedule] PS WITH (NOLOCK) ON PS.[IdPersonOfInterest] = P.[Id]
	WHERE	PS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(@Now)) AND 
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) 
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[CompletedForm] CF WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(CF.Date, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[ProductReportDynamic] PR WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PR.ReportDateTime, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[ProductRefund] PR WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PR.Date, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[Incident] I WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(I.CreatedDate, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[AssetReport] AR WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(AR.Date, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[ProductMissingPointOfInterest] PMP WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PMP.Date, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[PointOfInterestManualVisited] PMP WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PMP.CheckInDate, @Now) = 1)
			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[PointOfInterestMark] PMM WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PMM.CheckInDate, @Now) = 1)
			)

			return @Result
END
