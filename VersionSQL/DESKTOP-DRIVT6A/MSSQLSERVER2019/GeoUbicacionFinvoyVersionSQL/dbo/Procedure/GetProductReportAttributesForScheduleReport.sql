/****** Object:  Procedure [dbo].[GetProductReportAttributesForScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 15/07/2022
-- Description:	Devuelve los atributos de Control
--				de SKU para la definición de
--				condiciones en el envío de reportes
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributesForScheduleReport]
AS
BEGIN
	SELECT		PRS.[Id] AS IdSection, PRS.[Name] AS SectionName, PRS.[Deleted] AS SectionDeleted,
				PRA.[Id] AS IdAttribute, PRA.[Name] AS AttributeName,
				T.[Id] AS IdType, T.[Description] AS TypeDescription,
				AO.[Id] AS IdOption, AO.[Text] AS OptionText

	FROM		[dbo].[ProductReportSection] PRS WITH (NOLOCK)
				INNER JOIN [dbo].[ProductReportAttribute] PRA WITH (NOLOCK) ON PRA.[IdProductReportSection] = PRS.[Id]
				INNER JOIN	[dbo].[ProductReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = PRA.[IdType] 
				LEFT OUTER JOIN [dbo].[ProductReportAttributeOption] AO WITH (NOLOCK) ON AO.IdProductReportAttribute = PRA.[Id]

	WHERE		PRS.[FullDeleted] = 0
				AND PRA.[FullDeleted] = 0
				AND PRA.[IdType] IN (2, 3, 5, 7, 8, 11, 12) --4, 
				AND (AO.[Id] IS NULL OR AO.[Deleted] = 0)

	ORDER BY	PRS.[Order], PRS.[Id], PRA.[Order], PRA.[Id]
END
