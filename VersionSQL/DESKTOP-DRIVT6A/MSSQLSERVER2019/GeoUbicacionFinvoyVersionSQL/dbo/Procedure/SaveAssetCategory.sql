/****** Object:  Procedure [dbo].[SaveAssetCategory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveAssetCategory]
    @Id [sys].[int] OUTPUT,
	@Identifier [sys].[VARCHAR](50) = NULL,
	@Name [sys].[VARCHAR](50) = NULL, 
    @IsSubCategory [sys].[bit] = NULL, 
	@IdCategoryFather [sys].[int] = NULL,
	@IdUser [sys].[int] = NULL
AS 
BEGIN
    SET NOCOUNT ON;

	DECLARE @Exist AS [sys].[int]
	
    SELECT	@Exist = COUNT(1)
    FROM	dbo.[AssetCategory]
    WHERE	([Name] = @Name OR [Identifier] = @Identifier) AND [Deleted] = 0
	
	IF @Exist = 0
	BEGIN

		INSERT INTO [dbo].[AssetCategory]
           ([Name]
           ,[Identifier]
           ,[IsSubCategory]
           ,[IdCategoryFather]
           ,[CreatedDate]
           ,[IdUser]
           ,[Deleted])
		VALUES
           (@Name,@Identifier
           ,@IsSubCategory
           ,@IdCategoryFather
           ,GETUTCDATE()
           ,@IdUser,0)

		SELECT @Id = SCOPE_IDENTITY()
	END
	ELSE
		SET @Id = -1
END
