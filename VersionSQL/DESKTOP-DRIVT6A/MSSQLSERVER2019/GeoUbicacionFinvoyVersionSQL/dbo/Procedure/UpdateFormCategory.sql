/****** Object:  Procedure [dbo].[UpdateFormCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 11/10/2016
-- Description:	SP para actualizar una categoría de tarea
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFormCategory]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
)
AS
BEGIN

		--FormCategory Name Duplicated
		IF EXISTS (SELECT 1 FROM FormCategory WITH (NOLOCK) WHERE [Name] = @Name AND Deleted = 0 AND @Id != Id) SELECT -1 AS Id;

		ELSE
		BEGIN 
			UPDATE	[dbo].[FormCategory]
		
			SET		 [Name] = @Name,
					 [Description] = @Description,
					 [EditedDate] = GETUTCDATE()
		
			WHERE	 [Id] = @Id

			SELECT @Id as Id;
		END

END
