/****** Object:  Procedure [dbo].[ActivateFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/03/2023
-- Description:	SP para activar un formulario plus
-- =============================================
CREATE PROCEDURE [dbo].[ActivateFormPlus] 
	@Id [sys].[int]
AS
BEGIN
	CREATE TABLE #FormIds
	(
		[Id] [sys].[int] NOT NULL
	)

	UPDATE	[dbo].[FormPlus]
	SET		[Deleted] = 0, [DeletedDate] = NULL
	OUTPUT	deleted.[IdForm]
	INTO	#FormIds
	WHERE	[Id] = @Id

	UPDATE	F
	SET		F.[Deleted] = 0, F.[DeletedDate] = NULL
	FROM	[dbo].[Form] F
			INNER JOIN #FormIds FI ON FI.[Id] = F.[Id]

	DROP TABLE #FormIds
END
