/****** Object:  Procedure [dbo].[SaveCompany]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para obtener companias
-- =============================================
CREATE PROCEDURE [dbo].[SaveCompany]
     @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@Identifier [sys].[VARCHAR](50) = null
	,@Description [sys].[varchar](512) = null
	,@ImageName [sys].[varchar](256) = null
	,@IsMain [sys].[bit]
AS
BEGIN
	
	IF @IsMain = 1 AND EXISTS (SELECT 1 FROM dbo.[Company] WITH (NOLOCK) WHERE [IsMain] = 1 AND Deleted = 0)
	BEGIN
		SET @Id = -1
    END
	ELSE IF @Identifier IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.[Company] WITH (NOLOCK) WHERE [Identifier] = @Identifier AND Deleted = 0)
	BEGIN
		SET @Id = -2
    END
	ELSE 
	BEGIN
		INSERT INTO [dbo].[Company]
			   ([Name]
			   ,[Identifier]
			   ,[Description]
			   ,[ImageName]
			   ,[IsMain])
		 VALUES
			   (@Name
			   ,@Identifier
			   ,@Description
			   ,@ImageName
			   ,@IsMain)

		SET @Id = SCOPE_IDENTITY()
	END
END
