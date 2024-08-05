/****** Object:  Procedure [dbo].[GetShortageTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 06/11/2016
-- Description:	SP para obtener los tipos de faltantes
-- =============================================
CREATE PROCEDURE [dbo].[GetShortageTypes]
as
BEGIN

	SELECT		PMRT.[Id], PMRT.[Name], PMRT.[CreatedDate], PMRT.[IdUser], U.[Name], U.[LastName], PMRT.[Deleted]

	FROM		[dbo].[ProductMissingReportType] PMRT WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = PMRT.[IdUser]
	
	WHERE		PMRT.[Deleted] = 0  
	
	ORDER BY 	PMRT.[Id]
END
