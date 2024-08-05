/****** Object:  Procedure [dbo].[UpsertPersonCustomAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 05/10/2022
-- Description: SP para guardar/actualizar las metas de personas
-- =============================================
CREATE PROCEDURE [dbo].[UpsertPersonCustomAttributes]
(
	@Id INT,
	@Name VARCHAR(255),
	@IdType INT,
	@IdUser INT
)
AS
BEGIN
	IF @Id > 0 BEGIN
		UPDATE [dbo].[PersonCustomAttribute] SET [Name] = @Name, [IdType] = @IdType WHERE [Id] = @Id;
	END
	ELSE BEGIN
		INSERT INTO [dbo].[PersonCustomAttribute] VALUES(@Name, @IdType, @IdUser, GETDATE(), 0);
	END
END
