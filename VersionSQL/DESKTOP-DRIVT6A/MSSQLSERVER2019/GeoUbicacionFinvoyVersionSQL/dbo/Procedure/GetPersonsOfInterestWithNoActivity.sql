/****** Object:  Procedure [dbo].[GetPersonsOfInterestWithNoActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/04/2017
-- Description:	SP para obtener las Personas de Interes que no llevaron adelante ninguna actividad en el correr del dìa
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestWithNoActivity]
(
	@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SELECT	  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Status], P.[Type],
			      P.[IdDepartment]
	FROM	    [dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
      			INNER JOIN [dbo].[PersonOfInterestSchedule] PS WITH (NOLOCK) ON PS.[IdPersonOfInterest] = P.[Id]
	WHERE	    PS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(@Now))
      			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
      			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) 
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[CompletedForm] CF WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(CF.Date, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[ProductReportDynamic] PR WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PR.ReportDateTime, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[ProductRefund] PR WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PR.Date, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[Incident] I WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(I.CreatedDate, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[AssetReport] AR WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(AR.Date, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[ProductMissingPointOfInterest] PMP WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PMP.Date, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[PointOfInterestManualVisited] PMP WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PMP.CheckInDate, @Now) = 1)
      			AND P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[PointOfInterestMark] PMM WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates(PMM.CheckInDate, @Now) = 1)
				AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
								  FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
								  WHERE   @Now >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR @Now < PA.[ToDate]))
  GROUP BY  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Status], P.[Type],
			      P.[IdDepartment]
END
