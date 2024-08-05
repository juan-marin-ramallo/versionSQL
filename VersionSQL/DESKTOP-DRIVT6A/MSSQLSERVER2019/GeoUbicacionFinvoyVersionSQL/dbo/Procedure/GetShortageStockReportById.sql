/****** Object:  Procedure [dbo].[GetShortageStockReportById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 04/08/2016
-- Description:	SP para obtener el reporte de faltantes en detalle
-- =============================================
CREATE PROCEDURE [dbo].[GetShortageStockReportById]
    @IdProductMissingReport [sys].[int]
AS 
BEGIN

    SET NOCOUNT ON;

    SELECT  PMP.[Id], PMP.[Date] as ReportDate, P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
			S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName,
			PMP.[MissingConfirmation]
    
	FROM	[dbo].[ProductMissingPointOfInterest] PMP 
			INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = PMP.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = PMP.[IdPersonOfInterest]
    
	WHERE	PMP.[Id] = @IdProductMissingReport AND PMP.[Deleted] = 0
		  
END
