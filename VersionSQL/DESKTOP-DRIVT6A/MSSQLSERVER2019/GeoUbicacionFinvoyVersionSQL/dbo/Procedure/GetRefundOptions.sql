/****** Object:  Procedure [dbo].[GetRefundOptions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 30/08/2016
-- Description:	SP para obtener los motivos de laS DEVOLUCIONES
-- =============================================
CREATE PROCEDURE [dbo].[GetRefundOptions]
	@IdOptions [sys].[VARCHAR](max) = NULL
AS
BEGIN

	SELECT		RO.[Id], RO.[Description], RO.[CreatedDate], RO.[IdUser], U.[Name], U.[LastName], RO.[Deleted]

	FROM		[dbo].[ProductRefundOptions] RO
				INNER JOIN [dbo].[User] U ON U.[Id] = RO.[IdUser]
	
	WHERE		RO.[Deleted] = 0 AND
				((@IdOptions IS NULL) OR (dbo.CheckValueInList(RO.[Id], @IdOptions) = 1))
	
	ORDER BY 	RO.[Id]
END
