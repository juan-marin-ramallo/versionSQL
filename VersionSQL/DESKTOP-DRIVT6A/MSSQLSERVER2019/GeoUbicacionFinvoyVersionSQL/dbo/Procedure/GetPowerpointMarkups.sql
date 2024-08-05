/****** Object:  Procedure [dbo].[GetPowerpointMarkups]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 08/06/2017
-- Description:	SP para obtener los diseños de powerpoints
-- =============================================
CREATE PROCEDURE [dbo].[GetPowerpointMarkups]	
	 @MarkupsIds [sys].[varchar](max) = NULL
AS
BEGIN

	SELECT m.[Id], m.[Name]
			,e.[Id] as [ElementId], e.[Name] as [ElementName], e.X, e.Y, e.Cx, e.Cy
	FROM [dbo].[PowerpointMarkupTranslated] m WITH (NOLOCK)
			INNER JOIN [dbo].[PowerpointMarkupElement] e WITH (NOLOCK) on m.Id = e.IdPowerpointMarkup
	WHERE @MarkupsIds IS NULL OR [dbo].[CheckValueInList](m.Id, @MarkupsIds) > 0
	ORDER BY m.Id asc, e.Id asc
	
END
