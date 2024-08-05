/****** Object:  Procedure [dbo].[GetFieldTitlesGrouped]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFieldTitlesGrouped]
	@FieldIds varchar(2000)
AS
BEGIN
	
	SELECT F.[Id], F.[Name], F.[ColumnTitle], F.[IdFieldGroup],
		   FG.[Name] AS FieldGroupName
	FROM FieldTranslated F WITH (NOLOCK)
	JOIN FieldGroupTranslated FG WITH (NOLOCK) ON FG.[Id] = F.[IdFieldGroup]
	WHERE dbo.[CheckValueInList](F.[Id], @FieldIds) = 1
	ORDER BY FG.[Order], F.[Order]

END
