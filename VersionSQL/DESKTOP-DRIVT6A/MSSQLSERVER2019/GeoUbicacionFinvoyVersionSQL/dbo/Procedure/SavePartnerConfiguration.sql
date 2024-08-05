/****** Object:  Procedure [dbo].[SavePartnerConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- =============================================
CREATE PROCEDURE [dbo].[SavePartnerConfiguration]
(
	@Name [varchar](50)= NULL,
	@UrlWeb [varchar](100)= NULL,
	@ImageEncoded [sys].[varbinary](MAX) = NULL,
	@ImageName [varchar](100) = NULL,
	@MaxPIConfigured [int],
	@DeletePartnerLogo [sys].[bit] = NULL
)
AS
BEGIN

	IF @DeletePartnerLogo IS NULL
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()
																		
		IF EXISTS (SELECT 1 FROM [dbo].[PartnerConfiguration] WITH (NOLOCK))
			BEGIN
				UPDATE	[dbo].[PartnerConfiguration]
				SET		[Name] = @Name, [UrlWeb] = @UrlWeb, [ImageName] = @ImageName, [ImageEncoded] = @ImageEncoded, 
						[CreatedDate] = @Now

				UPDATE	[dbo].[PackageConfiguration]
				SET		[Value] = @MaxPIConfigured
				WHERE	[Name] like '%Max Stockers%'	

				SELECT 1
			END
		ELSE
			BEGIN
				UPDATE	[dbo].[PackageConfiguration]
				SET		[Value] = @MaxPIConfigured
				WHERE	[Name] like '%Max Stockers%'

				INSERT INTO	[dbo].[PartnerConfiguration]([Name], [UrlWeb], [ImageName], [ImageEncoded], [CreatedDate])
				VALUES		(@Name, @UrlWeb, @ImageName, @ImageEncoded, @Now)
		
				SELECT 1
			END
	END
	ELSE
	BEGIN
		--Elimino LOGO
		UPDATE	[dbo].[PartnerConfiguration]
		SET		[ImageName] = NULL, [ImageEncoded] = NULL

		SELECT 1
	END
END
