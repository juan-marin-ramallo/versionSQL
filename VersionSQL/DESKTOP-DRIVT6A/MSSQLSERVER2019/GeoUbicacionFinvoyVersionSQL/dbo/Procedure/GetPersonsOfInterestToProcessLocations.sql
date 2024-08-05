/****** Object:  Procedure [dbo].[GetPersonsOfInterestToProcessLocations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 16/04/2015
-- Description:	SP para obtener las Personas de Interes con locaciones pendientes de procesar si tiene
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestToProcessLocations]
(
	@IdPersonsOfInterestToExclude [sys].[varchar](1000) = NULL
)
AS
BEGIN
	SELECT	[Id], [Name], [LastName], [Identifier], [MobilePhoneNumber], [MobileIMEI], [Status], [Type], 
			[IdDepartment]
	FROM	[dbo].[AvailablePersonOfInterest] WITH (NOLOCK)
	WHERE	[Id] IN (
						SELECT		[IdPersonOfInterest]
						FROM		[dbo].[Location] WITH (NOLOCK)
						WHERE		[Processed] = 0
						GROUP BY	[IdPersonOfInterest]
					 )
			AND	((@IdPersonsOfInterestToExclude IS NULL) OR (dbo.CheckValueInList([Id], @IdPersonsOfInterestToExclude) = 0))
END
