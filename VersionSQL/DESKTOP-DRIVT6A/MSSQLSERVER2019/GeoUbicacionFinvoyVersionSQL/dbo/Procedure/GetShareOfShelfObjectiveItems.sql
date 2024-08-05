/****** Object:  Procedure [dbo].[GetShareOfShelfObjectiveItems]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfObjectiveItems]
(
	 @IdShareOfShelfObjective [sys].[int]
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL 
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
	SELECT		SI.Id, SI.IdProductBrand, B.[Name] AS [ProductBrandName], SI.[Value]
	
	FROM		[dbo].[ShareOfShelfObjective] SOS WITH (NOLOCK)
				LEFT OUTER JOIN	[dbo].[ShareOfShelfObjectiveItem] SI WITH (NOLOCK) ON SOS.[Id] = SI.IdShareOfShelfObjective
				LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = SI.IdProductBrand
				LEFT OUTER JOIN	[dbo].[Company] C WITH (NOLOCK) ON C.[Id] = B.IdCompany
	
	WHERE		SOS.Id = @IdShareOfShelfObjective
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(SI.[IdProductBrand], @IdUser) = 1)) 

	GROUP BY	SI.Id, SI.IdProductBrand, B.[Name], SI.[Value]
	ORDER BY	B.[Name] asc
END
