/****** Object:  Procedure [dbo].[GetLastLocationOfPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 22/10/2014
-- Description:	SP para obtener las ultimas coordenadas de una persona de interes
-- =============================================
CREATE PROCEDURE [dbo].[GetLastLocationOfPersonOfInterest]
	 @MobileIMEI [sys].[varchar](40) = NULL
	,@IdPersonOfInterest [sys].[int] = NULL
AS
BEGIN

	DECLARE @MobileIMEILocal [sys].[varchar](40) =  @MobileIMEI
	DECLARE @IdPersonOfInterestLocal [sys].[int] = @IdPersonOfInterest

	IF @IdPersonOfInterestLocal IS NULL
	BEGIN
		SET @IdPersonOfInterestLocal = (SELECT S.[Id] FROM [dbo].[AvailablePersonOfInterest] S WITH (NOLOCK) WHERE S.[MobileIMEI] LIKE '%' + @MobileIMEILocal + '%')
	END

	IF @IdPersonOfInterestLocal IS NOT NULL
	BEGIN 
		SELECT		TOP(1) L.[Id], L.[Date], L.[Latitude] AS Latitude, L.[Longitude] AS Longitude, L.[Processed], L.[BatteryLevel], 
					P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, P.[Id] AS PersonOfInterestId
		FROM		[dbo].[Location] L WITH (NOLOCK)
					INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON L.[IdPersonOfInterest] = P.[Id]
		WHERE		L.[IdPersonOfInterest] = @IdPersonOfInterestLocal
		GROUP BY	L.[Id], L.[Date], L.[Latitude], L.[Longitude], L.[Processed], L.[BatteryLevel], P.[Name], P.[LastName], P.[Id]
		ORDER BY	L.[Date] desc
	END	
END
