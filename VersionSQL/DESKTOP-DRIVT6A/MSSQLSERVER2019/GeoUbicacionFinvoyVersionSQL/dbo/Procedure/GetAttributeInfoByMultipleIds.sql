/****** Object:  Procedure [dbo].[GetAttributeInfoByMultipleIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 25/11/2019
-- Description:	SP para obtener los nombres y valores de los atributos de control de stock en base a varios ids que juntos son unicos
-- =============================================
CREATE PROCEDURE [dbo].[GetAttributeInfoByMultipleIds]
(
	 @IdPersonOfInterest [sys].[int],
	 @IdProduct [sys].[int],
	 @IdPointOfInterest [sys].[int],
	 @ReportDateTime [sys].[Datetime]
)
AS
BEGIN
	SELECT		PRA.[Id] AS ProductReportAttributeId, PRA.[Name] AS ProductReportAttributeName,
				PRA.[IdType] AS ProductReportTypeId,
				PRAV.[Id] AS ProductReportAttributeValueId, PRAV.[Value] AS ProductReportAttributeValue, 
				PRAV.[ImageUrl] AS ProductReportImageUrl, PRAV.[ImageEncoded] AS ProductReportImageEncoded, PRAV.[ImageName] as ProductReportImageName,
				PRS.[Name] AS ProductReportSectionName, PRS.[Id] AS ProductReportSectionId
						
	FROM		[dbo].[ProductReportAttribute] PRA
				INNER JOIN [dbo].[ProductReportAttributeValue] PRAV ON PRA.[Id] = PRAV.[IdProductReportAttribute] 
				INNER JOIN [dbo].[ProductReportDynamic] PRAD ON PRAV.[IdProductReport] = PRAD.[Id]
				INNER JOIN [dbo].[ProductReportSection] PRS ON PRS.Id = PRA.IdProductReportSection

	WHERE		PRAD.[IdPersonOfInterest] = @IdPersonOfInterest AND PRAD.[IdPointOfInterest] = @IdPointOfInterest
				AND PRAD.[IdProduct] = @IdProduct AND PRAD.[ReportDateTime] = @ReportDateTime
						
	GROUP BY	PRA.[Id], PRA.[Name], PRAV.[Id], PRAV.[Value],PRA.[IdType], PRAV.[ImageUrl], 
				PRAV.[ImageEncoded], PRAV.[ImageName], PRS.[Name], PRS.[Id]
	
	ORDER BY	PRS.[Id], PRA.[Id]
END
