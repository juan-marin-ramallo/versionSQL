/****** Object:  Procedure [dbo].[SaveAssetType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAssetType]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
	,@IdUser [sys].[int]
AS
BEGIN

	--AssetType Name Duplicated
	IF EXISTS (SELECT 1 FROM AssetType WITH (NOLOCK) WHERE [Name] = @Name AND [Deleted] = 0) SELECT @Id = -1;
	ELSE
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		INSERT INTO dbo.[AssetType] ([Name], [Description], [CreatedDate], [IdUser], [Deleted], [EditedDate])
		VALUES (@Name, @Description, @Now, @IdUser, 0, @Now)

		SELECT @Id = SCOPE_IDENTITY()
	END
	
END
