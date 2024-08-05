/****** Object:  Procedure [dbo].[GetProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 13/12/2022
-- Description:	Obtiene el reporte de SKU dado
--				por el id recibido
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReport]
	@Id [sys].[int],
	@IdUser [sys].[int] = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT		PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId, PR.[IdPointOfInterest] AS PointOfInterestId,
				PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice], PR.[EditedReason],
				PRS.[Id] AS IdProductReportSection, PRS.[Name] AS ProductReportSectionName, PRS.[Order] AS ProductReportSectionOrder,
				PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,
				PRAT.[IdType] AS IdProductReportAttributeType, PRAV.IdProductReportAttributeOption, PRO.[Text] AS ProductReportAttributeOption,
				PRAT.[Name] AS ProductReportAttributeName, PRAT.[Required] AS ProductReportAttributeRequired,
				PRAV.[ImageName] AS ProductReportAttributeImageName, PRAV.[ImageEncoded] AS ProductReportAttributeImage, PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,
				POI.PointOfInterestName, POI.PointOfInterestIdentifier,
				PEOI.[Name] AS PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,
				P.ProductName, P.ProductIdentifier, P.ProductBarCode
	
	FROM		[dbo].[ProductReportDynamic] PR WITH (NOLOCK)
				INNER JOIN [dbo].[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]
				INNER JOIN [dbo].[PointOfInterestInfo] POI WITH (NOLOCK) ON POI.[PointOfInterestId] = PR.[IdPointOfInterest]
				INNER JOIN [dbo].[ProductInfo] P WITH (NOLOCK) ON P.[Id] = PR.[IdProduct]
				LEFT JOIN [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]
				LEFT JOIN [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]
				LEFT JOIN [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]
				LEFT JOIN [dbo].[ProductReportSection] PRS WITH (NOLOCK) ON PRS.[Id] = PRAT.[IdProductReportSection]

	WHERE 		PR.[Id] = @Id AND
				(PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0) AND
				(PRS.[FullDeleted] = 0) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PR.[IdPersonOfinterest], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(PR.[IdPointOfInterest], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[BrandId], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))

	ORDER BY	PRS.[Order], PRAT.[Order]
END
