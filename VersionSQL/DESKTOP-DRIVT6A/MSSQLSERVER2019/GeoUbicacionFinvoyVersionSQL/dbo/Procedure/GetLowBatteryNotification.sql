/****** Object:  Procedure [dbo].[GetLowBatteryNotification]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 15/05/2015
-- Description:	SP para obtener la información necesaria para el reporte de bateria.
-- =============================================
CREATE PROCEDURE [dbo].[GetLowBatteryNotification]
(
	@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @ConfiguredBattery [sys].[int]
	SET @ConfiguredBattery = (SELECT CONVERT (int, [Value]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 19)

	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SELECT	  P.[Id], P.[Name], P.[LastName], L.[Date], L.[BatteryLevel], P.[Identifier]
	FROM	    [dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
			      INNER JOIN [dbo].[CurrentLocation] L WITH (NOLOCK) ON P.[Id] = L.[IdPersonOfInterest]
	WHERE     L.[BatteryLevel] < @ConfiguredBattery
      			AND dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1
      			AND dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1
				AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
									FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
									WHERE   @Now >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR @Now < PA.[ToDate]))
  --GROUP BY  P.[Id], P.[Name], P.[LastName], L.[Date], L.[BatteryLevel], P.[Identifier]
END
