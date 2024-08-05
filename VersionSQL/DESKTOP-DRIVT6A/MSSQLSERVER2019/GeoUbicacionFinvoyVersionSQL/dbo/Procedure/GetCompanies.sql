/****** Object:  Procedure [dbo].[GetCompanies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para obtener companias
-- =============================================
CREATE PROCEDURE [dbo].[GetCompanies]
	 @IncludeDeleted [sys].[BIT] = 0
	,@IdCompany [sys].[INT] = null
	,@IdCompanies [sys].VARCHAR(max) = NULL
    ,@IdProductBrands [sys].VARCHAR(max) = NULL
	,@IdUser [sys].INT = NULL
AS
BEGIN

	SELECT C.[Id]
		  ,C.[Name]
		  ,C.[Identifier]
		  ,C.[Description]
		  ,C.[ImageName]
		  ,C.[IsMain]
		  ,C.[Deleted]
	FROM [dbo].[Company] C
		LEFT OUTER JOIN [dbo].[ProductBrand] PB ON C.Id = PB.IdCompany
	WHERE (C.[Deleted] = 0 OR @IncludeDeleted = 1)
		AND (@IdCompany IS NULL OR @IdCompany = C.[Id])
		AND (@IdCompanies IS NULL OR [dbo].CheckValueInList(C.[Id], @IdCompanies) > 0)
		AND (@IdProductBrands IS NULL OR [dbo].CheckValueInList(PB.[Id], @IdProductBrands) > 0)
		AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(C.[Id], @IdUser) = 1))
	GROUP BY C.[Id]
		  ,C.[Name]
		  ,C.[Identifier]
		  ,C.[Description]
		  ,C.[ImageName]
		  ,C.[IsMain]
		  ,C.[Deleted]
	ORDER BY C.[IsMain] DESC,	C.[Name] asc
    
END
