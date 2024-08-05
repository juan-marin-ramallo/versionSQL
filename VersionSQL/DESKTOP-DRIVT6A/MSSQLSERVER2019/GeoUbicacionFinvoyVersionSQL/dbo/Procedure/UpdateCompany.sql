/****** Object:  Procedure [dbo].[UpdateCompany]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para actualizar una compania
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCompany]
	 @Id [sys].[INT]
	,@Name [sys].[varchar](50)
	,@Identifier [sys].[VARCHAR](50) = null
	,@Description [sys].[varchar](512) = null
	,@ImageName [sys].[varchar](256) = null
	,@IsMain [sys].[BIT]
	,@ResultCode [sys].[smallint] OUTPUT
AS
BEGIN
	IF @IsMain = 1 AND EXISTS (SELECT 1 FROM dbo.[Company] WITH (NOLOCK) WHERE [IsMain] = 1 AND Deleted = 0 AND Id <> @Id)
	BEGIN
		SET @ResultCode = -1
	END
	ELSE IF @Identifier IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.[Company] WITH (NOLOCK) WHERE [Identifier] = @Identifier AND Deleted = 0 AND Id <> @Id)
	BEGIN
		SET @ResultCode = -2
    END
	ELSE
	BEGIN
		UPDATE [dbo].[Company]
		SET  [Name] = @Name
			,[Identifier] = @Identifier
			,[Description] = @Description
			,[ImageName] = @ImageName
			,[IsMain] = @IsMain
		WHERE [Id] = @Id
		SET @ResultCode = 0
    END
END
