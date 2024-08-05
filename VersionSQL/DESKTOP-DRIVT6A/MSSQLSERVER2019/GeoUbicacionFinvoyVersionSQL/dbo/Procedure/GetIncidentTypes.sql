/****** Object:  Procedure [dbo].[GetIncidentTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 18/10/2016
-- Description:	SP para obtener los tipos de observaciones
-- =============================================
CREATE PROCEDURE [dbo].[GetIncidentTypes]
	@IdOptions [sys].[VARCHAR](max) = NULL
AS

BEGIN

	SELECT		IT.[Id], IT.[Name] AS IncidentTypeName, IT.[Description], IT.[CreatedDate], IT.[IdUser], U.[Name], U.[LastName], IT.[Deleted]

	FROM		[dbo].[IncidentType] IT WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = IT.[IdUser]
	
	WHERE		IT.[Deleted] = 0  AND
				((@IdOptions IS NULL) OR (dbo.CheckValueInList(IT.[Id], @IdOptions) = 1))
	
	ORDER BY 	IT.[Id]
END
