/****** Object:  Procedure [dbo].[GetFieldColumnTitles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFieldColumnTitles]
	@FieldIds varchar(2000) = NULL
AS
BEGIN

	SELECT F.[Name], F.[ColumnTitle], F.[IdFieldGroup]
	FROM FieldTranslated F WITH (NOLOCK)
	WHERE (@FieldIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FieldIds) = 1)
	ORDER BY F.[Order]

END
