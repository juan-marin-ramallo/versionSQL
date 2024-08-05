/****** Object:  Procedure [dbo].[UpdateAssetReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAssetReportAttribute]
	 @Id int
	,@Name varchar(100)
	,@DefaultValue varchar(MAX) = ''
	,@Order int
	,@IdVisibilityType smallint
	,@Required bit
AS
BEGIN

	IF EXISTS (SELECT 1 FROM [dbo].AssetReportAttribute WITH (NOLOCK) WHERE [Name] = @Name AND [Deleted] = 0 AND @Id <> [Id]) 
		SELECT -1 AS Id;

	ELSE BEGIN
		UPDATE AssetReportAttribute
		SET [Name] = @Name
		   ,[DefaultValue] = @DefaultValue
		   ,[Order] = @Order
		   ,[Required] = @Required
		   ,[IdVisibilityType] = @IdVisibilityType
		WHERE [Id] = @Id

		UPDATE AssetReportAttributeOption
		SET [Deleted] = 1
		WHERE [IdAssetReportAttribute] = @Id

		UPDATE Field
		SET [Name] = @Name
		WHERE [IdAssetReportAttribute] = @Id

		SELECT @Id as Id;
	END
END
