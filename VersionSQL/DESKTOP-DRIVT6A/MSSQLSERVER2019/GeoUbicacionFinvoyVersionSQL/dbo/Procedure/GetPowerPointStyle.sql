/****** Object:  Procedure [dbo].[GetPowerPointStyle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 13/05/2020
-- Description:	SP para obtener un estilo de powerpoint
-- =============================================
CREATE PROCEDURE [dbo].[GetPowerPointStyle]
(
	@Id [sys].[int]
)
AS
BEGIN
	SELECT	[Id], [Name], [FontFamily], [BackgroundColor], [BackgroundImageName], [BackgroundImageUrl],
			[FooterBackgroundColor], [FooterLeftImageName], [FooterLeftImageUrl], [FooterRightImageName],
			[FooterRightImageUrl], [TitleBackgroundColor], [TitleFontColor], [TitleFontSize],
			[SubtitleBackgroundColor], [SubtitleFontColor], [SubtitleFontSize], [HeaderBackgroundColor],
			[HeaderFontColor], [HeaderFontSize]
	FROM	[dbo].[PowerPointStyle] WITH (NOLOCK)
	WHERE	[Id] = @Id
END
