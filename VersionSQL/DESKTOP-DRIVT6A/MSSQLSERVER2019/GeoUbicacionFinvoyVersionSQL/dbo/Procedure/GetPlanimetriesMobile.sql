/****** Object:  Procedure [dbo].[GetPlanimetriesMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 08/08/2016
-- Description:	SP para obtener las planimetrias por punto usadas en los servicios mobile
-- =============================================
CREATE PROCEDURE [dbo].[GetPlanimetriesMobile]
	@IdPointOfInterest [sys].[int]
AS
BEGIN
	
	SELECT		P.[Id], P.[Name], P.[Description], P.[FileName], P.[Deleted], P.MD5Checksum, B.[Id] AS BrandId, B.[Name] AS BrandName,
				PR.[Id] AS ProviderId , PR.[Name] AS ProviderName, C.[Id] AS CategoryId, C.[Name] AS CategoryName
	
	FROM		[dbo].[Planimetry] P
				INNER JOIN [dbo].[PlanimetryPointOfInterest] PP ON P.[Id] = PP.[IdPlanimetry]
				LEFT JOIN [dbo].[Brand] B ON B.[Id] = P.[IdBrand]
				LEFT JOIN [dbo].[Provider] PR ON PR.[Id] = P.[IdProvider]
				LEFT JOIN [dbo].[Category] C ON C.[Id] = P.[IdCategory]
	
	WHERE		PP.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0
	
	GROUP BY	P.[Id], P.[Name], P.[Description], P.[FileName], P.[Deleted], P.MD5Checksum, B.[Id], B.[Name], 
				PR.[Id] , PR.[Name], C.[Id], C.[Name] 
	
	ORDER BY	P.[Id] DESC
END
