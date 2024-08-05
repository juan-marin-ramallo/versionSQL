/****** Object:  Procedure [dbo].[SavePowerPointStyle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 13/05/2020
-- Description:	SP para almacenar un estilo de powerpoint
-- =============================================
CREATE PROCEDURE [dbo].[SavePowerPointStyle]
(
	 @Id [sys].[int] OUTPUT
    ,@Name [sys].[varchar](100) = NULL
    ,@FontFamily [sys].[varchar](50) = NULL
    ,@BackgroundColor [sys].[varchar](10) = NULL
    ,@BackgroundImageName [sys].[varchar](100) = NULL
    ,@BackgroundImageUrl [sys].[varchar](2000) = NULL
    ,@FooterBackgroundColor [sys].[varchar](10) = NULL
    ,@FooterLeftImageName [sys].[varchar](100) = NULL
    ,@FooterLeftImageUrl [sys].[varchar](2000) = NULL
    ,@FooterRightImageName [sys].[varchar](100) = NULL
    ,@FooterRightImageUrl [sys].[varchar](2000) = NULL
    ,@TitleBackgroundColor [sys].[varchar](10) = NULL
    ,@TitleFontColor [sys].[varchar](10) = NULL
    ,@TitleFontSize [sys].[smallint] = NULL
    ,@SubtitleBackgroundColor [sys].[varchar](10) = NULL
    ,@SubtitleFontColor [sys].[varchar](10) = NULL
    ,@SubtitleFontSize [sys].[smallint] = NULL
    ,@HeaderBackgroundColor [sys].[varchar](10) = NULL
    ,@HeaderFontColor [sys].[varchar](10) = NULL
    ,@HeaderFontSize [sys].[smallint] = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[PowerPointStyle]([Name], [FontFamily], [BackgroundColor], [BackgroundImageName], [BackgroundImageUrl],
		[FooterBackgroundColor], [FooterLeftImageName], [FooterLeftImageUrl], [FooterRightImageName],
		[FooterRightImageUrl], [TitleBackgroundColor], [TitleFontColor], [TitleFontSize],
		[SubtitleBackgroundColor], [SubtitleFontColor], [SubtitleFontSize], [HeaderBackgroundColor],
		[HeaderFontColor], [HeaderFontSize], [Deleted])
	VALUES (@Name, @FontFamily, @BackgroundColor, @BackgroundImageName, @BackgroundImageUrl,
		@FooterBackgroundColor, @FooterLeftImageName, @FooterLeftImageUrl, @FooterRightImageName,
		@FooterRightImageUrl, @TitleBackgroundColor, @TitleFontColor, @TitleFontSize,
		@SubtitleBackgroundColor, @SubtitleFontColor, @SubtitleFontSize, @HeaderBackgroundColor,
		@HeaderFontColor, @HeaderFontSize, 0)

	SELECT @Id = SCOPE_IDENTITY()
END
