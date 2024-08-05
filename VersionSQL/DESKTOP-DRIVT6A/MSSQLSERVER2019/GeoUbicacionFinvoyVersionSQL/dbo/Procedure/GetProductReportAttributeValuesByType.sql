/****** Object:  Procedure [dbo].[GetProductReportAttributeValuesByType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 26/12/2022
-- Description:	SP para obtener todos los valores
--				reportados para un control de SKU
--				según el tipo dado por parámetros
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributeValuesByType]
(
	 @IdProductReport [sys].[int],
	 @IdType [sys].[int]
)
AS
BEGIN
	SELECT		PRA.[Id] AS ProductReportAttributeId, PRA.[Name] AS ProductReportAttributeName,
				PRA.[IdType] AS ProductReportTypeId,
				PRAV.[Id] AS ProductReportAttributeValueId, PRAV.[Value] AS ProductReportAttributeValue,
				PRAV.[ImageUrl] AS ProductReportImageUrl, PRAV.[ImageEncoded] AS ProductReportImageEncoded, PRAV.[ImageName] as ProductReportImageName,
				PRS.[Name] AS ProductReportSectionName, PRS.[Id] AS ProductReportSectionId,
				PRAV.[IdProductReportAttributeOption] AS OptionId
						
	FROM		[dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK)
				INNER JOIN [dbo].[ProductReportAttribute] PRA WITH (NOLOCK) ON PRA.[Id] = PRAV.[IdProductReportAttribute]
				INNER JOIN [dbo].[ProductReportSection] PRS WITH (NOLOCK) ON PRS.Id = PRA.IdProductReportSection

	WHERE		PRAV.[IdProductReport] = @IdProductReport AND PRA.[IdType] = @IdType
				AND PRA.[FullDeleted] = 0 AND PRS.[FullDeleted] = 0
						
	GROUP BY	PRA.[Id], PRA.[Name], PRAV.[Id], PRAV.[Value],PRA.[IdType], PRAV.[ImageUrl], 
				PRAV.[ImageEncoded], PRAV.[ImageName], PRS.[Name], PRS.[Id], PRAV.[IdProductReportAttributeOption]
	
	ORDER BY	PRS.[Id], PRA.[Id]
END
