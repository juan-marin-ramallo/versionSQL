/****** Object:  Procedure [dbo].[UpdateIncidentType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 18/10/2016
-- Description:	SP para actualizar tipo de observación
-- =============================================
CREATE PROCEDURE [dbo].[UpdateIncidentType]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
)
AS
BEGIN
	
		--IncidentType Name Duplicated
		IF EXISTS (SELECT 1 FROM IncidentType WITH (NOLOCK) WHERE [Name] = @Name AND Deleted = 0 AND @Id != Id) SELECT -1 AS Id;

		ELSE
		BEGIN 
			UPDATE	[dbo].[IncidentType]
		
		SET		 [Name] = @Name,
				 [Description] = @Description,
				 [EditedDate] = GETUTCDATE()
		
		WHERE	 [Id] = @Id

		SELECT @Id as Id;
		END

END
