/****** Object:  Procedure [dbo].[GetFormCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 11/10/2016
-- Description:	SP para obtener las categorías de las tareas
-- =============================================
CREATE PROCEDURE [dbo].[GetFormCategory]
	@IdOptions [sys].[VARCHAR](max) = NULL
AS
BEGIN

	SELECT		FC.[Id], FC.[Name] as FormCategoryName, FC.[Description], FC.[CreatedDate], FC.[IdUser], U.[Name], U.[LastName], FC.[Deleted]

	FROM		[dbo].[FormCategory] FC
				INNER JOIN [dbo].[User] U ON U.[Id] = FC.[IdUser]
	
	WHERE		FC.[Deleted] = 0 AND
				((@IdOptions IS NULL) OR (dbo.CheckValueInList(FC.[Id], @IdOptions) = 1))
	
	ORDER BY 	FC.[Name]
END
