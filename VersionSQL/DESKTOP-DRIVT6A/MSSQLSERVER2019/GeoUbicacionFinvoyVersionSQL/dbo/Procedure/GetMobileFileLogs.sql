/****** Object:  Procedure [dbo].[GetMobileFileLogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 27/11/2020
-- Description:	SP para obtener los archivos de log recibidos desde la app
-- =============================================
CREATE PROCEDURE [dbo].[GetMobileFileLogs]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@PersonOfInterestIds [sys].[varchar](MAX) = NULL
AS
BEGIN
	SELECT		MFL.[Id], MFL.[Date], MFL.[IdPersonOfInterest], S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, 
				MFL.[IdMobileFileLogType], MFLT.[Description] AS MobileFileLogTypeDescription, MFL.[Name], MFL.[Url]
	FROM		[dbo].[MobileFileLog] MFL WITH (NOLOCK)
				INNER JOIN [dbo].[MobileFileLogTypeTranslated] MFLT WITH (NOLOCK) ON MFLT.[Id] = MFL.[IdMobileFileLogType]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = MFL.[IdPersonOfInterest]
	WHERE		MFL.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](MFL.[IdPersonOfInterest], @PersonOfInterestIds) = 1))
	ORDER BY	MFL.[Date] desc
END
