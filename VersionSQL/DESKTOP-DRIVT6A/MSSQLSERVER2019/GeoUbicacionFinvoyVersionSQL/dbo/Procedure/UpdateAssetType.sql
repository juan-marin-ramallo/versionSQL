/****** Object:  Procedure [dbo].[UpdateAssetType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAssetType]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
)
AS
BEGIN
	
		--AssetType Name Duplicated
		IF EXISTS (SELECT 1 FROM AssetType WITH (NOLOCK) WHERE [Name] = @Name AND [Deleted] = 0 AND @Id != Id) SELECT -1 AS Id;

		ELSE
		BEGIN 
			
			UPDATE	[dbo].[AssetType]	
			SET	 [Name] = @Name,
				 [Description] = @Description,
				 [EditedDate] = GETUTCDATE()
		
			WHERE [Id] = @Id

		SELECT @Id as Id;

		END

END
