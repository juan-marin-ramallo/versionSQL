/****** Object:  Procedure [dbo].[GetCustomReportFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomReportFields]
	@FieldIds varchar(MAX)
AS
BEGIN
	
	SELECT	F.[Id] AS IdField, F.[Name] AS FieldName,
			F.[IdCustomAttribute], F.[IdProductReportAttribute], FG.[Id] as IdFieldGroup, F.[IdOrderReportAttribute], F.[IdAssetReportAttribute]
	
	FROM	[dbo].[FieldTranslated] F WITH(NOLOCK)
			JOIN [dbo].[FieldGroupTranslated] FG WITH(NOLOCK) ON FG.[Id] = F.[IdFieldGroup]
	
	WHERE	F.[Deleted] = 0 
			AND ((@FieldIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FieldIds) = 1))
	
	ORDER BY FG.[Order], F.[Order]
	 
END
