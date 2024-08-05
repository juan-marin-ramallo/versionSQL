/****** Object:  Procedure [dbo].[GetPlanimetries]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 09/08/2016
-- Description:	SP para obtener las planimetrias
-- =============================================
CREATE PROCEDURE [dbo].[GetPlanimetries]

	 @IdUser [sys].[int] = NULL
	,@PlanimetryIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](MAX) = NULL
	,@BrandIds [sys].[varchar](MAX) = NULL
	,@ProviderIds [sys].[varchar](MAX) = NULL
	,@AllPlanimetries [sys].[bit] = NULL
	,@FilterOption [sys].[int] = 2
AS
BEGIN
	
	SELECT		P.[Id], P.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, P.[AllPointOfInterest],
				P.[CreatedDate], P.[Deleted], P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name] as CategoryName,
				C.[Id] as CategoryId, B.[Name] as BrandName, B.[Id] as BrandId, PRO.[Name] as ProviderName, PRO.[Id] as ProviderId
	
	FROM		[dbo].[Planimetry] P
				INNER JOIN [dbo].[User] U ON P.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[PlanimetryPointOfInterest] PP ON P.[Id] = PP.[IdPlanimetry] 
				LEFT JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PP.[IdPointOfInterest] AND POI.[Deleted] = 0
				LEFT JOIN [dbo].[Category] C ON C.[Id] = P.[IdCategory]
				LEFT JOIN [dbo].[Brand] B ON B.[Id] = P.[IdBrand]
				LEFT JOIN [dbo].[Provider] PRO ON PRO.[Id] = P.[IdProvider] 
	
	WHERE		((@PlanimetryIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PlanimetryIds) = 1)) AND
				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](PP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
				((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](P.[IdCategory], @CategoryIds) = 1)) AND
				((@BrandIds IS NULL) OR (dbo.[CheckValueInList](P.[IdBrand], @BrandIds) = 1)) AND
				((@ProviderIds IS NULL) OR (dbo.[CheckValueInList](P.[IdProvider], @ProviderIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
				((@AllPlanimetries = 1) OR (P.[IdUser] = @IdUser))
				AND
				((@FilterOption = 1) 
					OR (@FilterOption = 2 AND P.[Deleted] = 0) --ACTIVOS
					OR (@FilterOption = 3 AND P.[Deleted] = 1) --Eliminados
				)
				
	GROUP BY	P.[Id], P.[Name], U.[Id], U.[Name], U.[LastName], P.[AllPointOfInterest], P.[CreatedDate], P.[Deleted], 
				P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name], C.[Id], B.[Name], B.[Id], PRO.[Name] , PRO.[Id]

	ORDER BY	P.[CreatedDate] DESC

	--IF @AllPlanimetries = 1
	--BEGIN
	--	IF @PointOfInterestIds IS NOT NULL
 --   BEGIN

	--	SELECT		P.[Id], P.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, P.[AllPointOfInterest],
	--				P.[CreatedDate], P.[Deleted], P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name] as CategoryName,
	--				C.[Id] as CategoryId, B.[Name] as BrandName, B.[Id] as BrandId, PRO.[Name] as ProviderName, PRO.[Id] as ProviderId
	
	--	FROM		[dbo].[Planimetry] P
	--				INNER JOIN [dbo].[User] U ON P.[IdUser] = U.[Id]
	--				INNER JOIN [dbo].[PlanimetryPointOfInterest] PP ON P.[Id] = PP.[IdPlanimetry] 
	--				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PP.[IdPointOfInterest] AND POI.[Deleted] = 0
	--				LEFT JOIN [dbo].[Category] C ON C.[Id] = P.[IdCategory]
	--				LEFT JOIN [dbo].[Brand] B ON B.[Id] = P.[IdBrand]
	--				LEFT JOIN [dbo].[Provider] PRO ON PRO.[Id] = P.[IdProvider] 
	
	--	WHERE		((@PlanimetryIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PlanimetryIds) = 1)) AND
	--				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](PP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
	--				((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](P.[IdCategory], @CategoryIds) = 1)) AND
	--				((@BrandIds IS NULL) OR (dbo.[CheckValueInList](P.[IdBrand], @BrandIds) = 1)) AND
	--				((@ProviderIds IS NULL) OR (dbo.[CheckValueInList](P.[IdProvider], @ProviderIds) = 1)) AND
	--				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
	--				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) 
	
	--	GROUP BY	P.[Id], P.[Name], U.[Id], U.[Name], U.[LastName], P.[AllPointOfInterest], P.[CreatedDate], P.[Deleted], 
	--				P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name], C.[Id], B.[Name], B.[Id], PRO.[Name] , PRO.[Id]
	
	
	--	ORDER BY	P.[CreatedDate] DESC
	--END
 --   ELSE
 --   BEGIN
	--	SELECT		P.[Id], P.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, P.[AllPointOfInterest],
	--				P.[CreatedDate], P.[Deleted], P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name] as CategoryName,
	--				C.[Id] as CategoryId, B.[Name] as BrandName, B.[Id] as BrandId, PRO.[Name] as ProviderName, PRO.[Id] as ProviderId
	
	--	FROM		[dbo].[Planimetry] P
	--				INNER JOIN [dbo].[User] U ON P.[IdUser] = U.[Id]
	--				LEFT JOIN [dbo].[Category] C ON C.[Id] = P.[IdCategory]
	--				LEFT JOIN [dbo].[Brand] B ON B.[Id] = P.[IdBrand]
	--				LEFT JOIN [dbo].[Provider] PRO ON PRO.[Id] = P.[IdProvider] 
	
	--	WHERE		((@PlanimetryIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PlanimetryIds) = 1)) AND
	--				((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](P.[IdCategory], @CategoryIds) = 1)) AND
	--				((@BrandIds IS NULL) OR (dbo.[CheckValueInList](P.[IdBrand], @BrandIds) = 1)) AND
	--				((@ProviderIds IS NULL) OR (dbo.[CheckValueInList](P.[IdProvider], @ProviderIds) = 1))
	
	--	GROUP BY	P.[Id], P.[Name], U.[Id], U.[Name], U.[LastName], P.[AllPointOfInterest], P.[CreatedDate], P.[Deleted], 
	--				P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name], C.[Id], B.[Name], B.[Id], PRO.[Name] , PRO.[Id]
	
	
	--	ORDER BY	P.[CreatedDate] DESC
	--END
	--END
	--ELSE
	--BEGIN
	--	--SOLO LOS DEL USUARIO
	--	IF @PointOfInterestIds IS NOT NULL
	--	BEGIN

	--		SELECT		P.[Id], P.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, P.[AllPointOfInterest],
	--					P.[CreatedDate], P.[Deleted], P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name] as CategoryName,
	--					C.[Id] as CategoryId, B.[Name] as BrandName, B.[Id] as BrandId, PRO.[Name] as ProviderName, PRO.[Id] as ProviderId
	
	--		FROM		[dbo].[Planimetry] P
	--					INNER JOIN [dbo].[User] U ON P.[IdUser] = U.[Id]
	--					INNER JOIN [dbo].[PlanimetryPointOfInterest] PP ON P.[Id] = PP.[IdPlanimetry] 
	--					INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PP.[IdPointOfInterest] AND POI.[Deleted] = 0
	--					LEFT JOIN [dbo].[Category] C ON C.[Id] = P.[IdCategory]
	--					LEFT JOIN [dbo].[Brand] B ON B.[Id] = P.[IdBrand]
	--					LEFT JOIN [dbo].[Provider] PRO ON PRO.[Id] = P.[IdProvider] 
	
	--		WHERE		((@PlanimetryIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PlanimetryIds) = 1)) AND
	--					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](PP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
	--					((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](P.[IdCategory], @CategoryIds) = 1)) AND
	--					((@BrandIds IS NULL) OR (dbo.[CheckValueInList](P.[IdBrand], @BrandIds) = 1)) AND
	--					((@ProviderIds IS NULL) OR (dbo.[CheckValueInList](P.[IdProvider], @ProviderIds) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
	--					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
	--					P.[IdUser] = @IdUser 
	
	--		GROUP BY	P.[Id], P.[Name], U.[Id], U.[Name], U.[LastName], P.[AllPointOfInterest], P.[CreatedDate], P.[Deleted], 
	--					P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name], C.[Id], B.[Name], B.[Id], PRO.[Name] , PRO.[Id]
	
	
	--		ORDER BY	P.[CreatedDate] DESC
	--	END
	--	ELSE
	--	BEGIN
	--		SELECT		P.[Id], P.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, P.[AllPointOfInterest],
	--					P.[CreatedDate], P.[Deleted], P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name] as CategoryName,
	--					C.[Id] as CategoryId, B.[Name] as BrandName, B.[Id] as BrandId, PRO.[Name] as ProviderName, PRO.[Id] as ProviderId
	
	--		FROM		[dbo].[Planimetry] P
	--					INNER JOIN [dbo].[User] U ON P.[IdUser] = U.[Id]
	--					LEFT JOIN [dbo].[Category] C ON C.[Id] = P.[IdCategory]
	--					LEFT JOIN [dbo].[Brand] B ON B.[Id] = P.[IdBrand]
	--					LEFT JOIN [dbo].[Provider] PRO ON PRO.[Id] = P.[IdProvider] 
	
	--		WHERE		((@PlanimetryIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PlanimetryIds) = 1)) AND
	--					((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](P.[IdCategory], @CategoryIds) = 1)) AND
	--					((@BrandIds IS NULL) OR (dbo.[CheckValueInList](P.[IdBrand], @BrandIds) = 1)) AND
	--					((@ProviderIds IS NULL) OR (dbo.[CheckValueInList](P.[IdProvider], @ProviderIds) = 1)) AND
	--					P.[IdUser] = @IdUser 
	
	--		GROUP BY	P.[Id], P.[Name], U.[Id], U.[Name], U.[LastName], P.[AllPointOfInterest], P.[CreatedDate], P.[Deleted], 
	--					P.[DeletedDate], P.[Description], P.[RealFileName], C.[Name], C.[Id], B.[Name], B.[Id], PRO.[Name] , PRO.[Id]
	
	
	--		ORDER BY	P.[CreatedDate] DESC
	--	END
	--END
END
