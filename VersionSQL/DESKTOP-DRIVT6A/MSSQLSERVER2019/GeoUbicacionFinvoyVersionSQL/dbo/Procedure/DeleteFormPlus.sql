/****** Object:  Procedure [dbo].[DeleteFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/03/2023
-- Description:	SP para eliminar un formulario plus
-- =============================================
CREATE PROCEDURE [dbo].[DeleteFormPlus] 
	@Id [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	CREATE TABLE #FormIds
	(
		[Id] [sys].[int] NOT NULL
	)

	UPDATE	[dbo].[FormPlus]
	SET		[Deleted] = 1, [DeletedDate] = @Now
	OUTPUT	deleted.[IdForm]
	INTO	#FormIds
	WHERE	[Id] = @Id

	UPDATE	F
	SET		F.[Deleted] = 1, F.[DeletedDate] = @Now
	FROM	[dbo].[Form] F
			INNER JOIN #FormIds FI ON FI.[Id] = F.[Id]

	DROP TABLE #FormIds
END
