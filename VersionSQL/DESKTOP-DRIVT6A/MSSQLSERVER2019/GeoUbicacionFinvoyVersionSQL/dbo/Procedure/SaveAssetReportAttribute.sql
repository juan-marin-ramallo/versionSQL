/****** Object:  Procedure [dbo].[SaveAssetReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAssetReportAttribute]
	 @Name varchar(100)
	,@IdType int
	,@DefaultValue varchar(MAX) = ''
	,@Order int
	,@IdVisibilityType smallint
	,@Required bit
	,@IdUser int
AS
BEGIN
	declare @Id int
	INSERT INTO AssetReportAttribute ([Name], [IdType], [DefaultValue], [Order], [Required],
		[IdVisibilityType], [IdUser], [CreatedDate], [Enabled], [Deleted])
	VALUES (@Name, @IdType, @DefaultValue, @Order, @Required,
		@IdVisibilityType, @IdUser, GETUTCDATE(), 1, 0)

	SET @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[Field]([Name], [IdFieldGroup], [Order], [IdAssetReportAttribute])
	VALUES (@Name, 15, 80, @Id)

	select @Id
END
