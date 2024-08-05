/****** Object:  Procedure [dbo].[GetShareOfShelfIRReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 11/04/2022 
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetShareOfShelfIRReport]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdProductCategorySOS [sys].[int]  
 ,@IdProduct [sys].[varchar](max) = NULL  
 ,@IdProductCategories [sys].[varchar](max) = NULL   
 ,@IdProductBrand [sys].[varchar](max) = NULL  
 ,@IdCompany [sys].[varchar](max) = NULL  
 ,@IdPointOfInterest [sys].[varchar](max) = NULL  
 ,@IdPersonOfInterest [sys].[varchar](max) = NULL  
 ,@IdUser [sys].INT = NULL  
)  
AS  
BEGIN  
 IF @IdProductCategorySOS = 0
 BEGIN
  SET @IdProductCategorySOS = NULL;
 END

  -- Filter DATA
  ;WITH ShareOfShelfIR AS (
	 SELECT   SOS.[Id], SOS.[Date], SOS.[IsManual], SOS.[IsValid], SOS.[DiscardReason], SOS.[GrandTotal], SOS.[ValidationImage]
		, SOS.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.IdDepartment AS [PointOfInterestDepartment], D.[Name] AS [PointOfInterestDepartmentName], POI.[Address] AS [PointOfInterestAddress]
		, POI.ContactName AS [PointOfInterestContactName], POI.ContactPhoneNumber AS [PointOfInterestContactPhoneNumber]  
		, POI.[GrandfatherId] AS HierarchyLevel1Id, POI.[FatherId] AS HierarchyLevel2Id, PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name, PHL1.SapId AS [HierarchyLevel1SapId], PHL2.SapId AS [HierarchyLevel2SapId]  
		, SOS.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.Identifier AS [PersonOfInterestIdentifier], S.MobilePhoneNumber AS [PersonOfInterestMobilePhoneNumber], S.MobileIMEI AS [PersonOfInterestMobileIMEI]  
		, SI.[Id] as [ItemId], SI.[Total], C.IsMain   
	 FROM  [dbo].[ShareOfShelfReport] SOS WITH (NOLOCK)  
		INNER JOIN  [dbo].[ShareOfShelfProductCategory] SOSPC WITH(NOLOCK) ON SOS.Id = SOSPC.IdShareOfShelf  
		INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = SOS.[IdPointOfInterest]  
		INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = SOS.[IdPersonOfInterest]  
		LEFT OUTER JOIN [dbo].[ShareOfShelfItem] SI WITH (NOLOCK) ON SOS.[Id] = SI.IdShareOfShelf  
		LEFT OUTER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = SI.IdProduct  
		LEFT OUTER JOIN [dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = SI.IdProductBrand OR B.[Id] = P.IdProductBrand  
		LEFT OUTER JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = B.IdCompany  
		LEFT OUTER JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON P.Id = PCL.IdProduct  
		LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.Id =  POI.IdDepartment  
		LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK) ON POI.[GrandfatherId] = PHL1.[Id]   
		LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK) ON POI.[FatherId] = PHL2.[Id]  
   
	 WHERE (SOS.ISManual = 0) AND SOS.[Date] >= @DateFrom AND SOS.[Date] <= @DateTo   
		AND ISNULL(@IdProductCategorySOS, SOSPC.IdProductCategory) = SOSPC.IdProductCategory  
		AND (@IdPointOfInterest IS NULL OR dbo.CheckValueInList(POI.[Id], @IdPointOfInterest) = 1)   
		AND (@IdPersonOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)   
		AND (@IdUser IS NULL OR dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)  
		AND (@IdUser IS NULL OR dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)  
		AND (@IdUser IS NULL OR dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)  
		AND (@IdUser IS NULL OR dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)  
		AND (@IdProduct IS NULL OR dbo.CheckValueInList(P.[Id], @IdProduct) = 1)  
		AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)  
		AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)  
		AND (@IdProductCategories IS NULL OR dbo.CheckValueInList(PCL.IdProductCategory, @IdProductCategories) = 1)  
		AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1) OR (dbo.CheckUserInProductCompanies(SI.[IdProductBrand], @IdUser) = 1))   
   
	 GROUP BY SOS.[Id], SOS.[Date], SOS.[IsManual], SOS.[IsValid], SOS.[DiscardReason], SOS.[GrandTotal], SOS.[ValidationImage]
		,SOS.[IdPointOfInterest], POI.[Name], POI.[Identifier], POI.IdDepartment, D.[Name], POI.[Address], POI.ContactName, POI.ContactPhoneNumber  
		,POI.[GrandfatherId], POI.[FatherId] , PHL1.[Name] , PHL2.[Name], PHL1.SapId, PHL2.SapId    
		,SOS.[IdPersonOfInterest], S.[Name], S.[LastName], S.Identifier, S.MobilePhoneNumber , S.MobileIMEI  
		,SI.[Id], SI.[Total], C.IsMain    
  )
  -- Calculate Totals
  ,ShareOfShelfIRWithTotals As (
	  SELECT SOSIR.[Id], SOSIR.[Date], SOSIR.[IsManual], SOSIR.[IsValid], SOSIR.[DiscardReason], SOSIR.[GrandTotal], SOSIR.[ValidationImage] 
		, SOSIR.PointOfInterestId, SOSIR.PointOfInterestName, SOSIR.PointOfInterestIdentifier, SOSIR.[PointOfInterestDepartment], SOSIR.[PointOfInterestDepartmentName], SOSIR.[PointOfInterestAddress]
		, SOSIR.[PointOfInterestContactName], SOSIR.[PointOfInterestContactPhoneNumber]  
		, SOSIR.HierarchyLevel1Id, SOSIR.HierarchyLevel2Id, SOSIR.HierarchyLevel1Name, SOSIR.HierarchyLevel2Name, SOSIR.[HierarchyLevel1SapId], SOSIR.[HierarchyLevel2SapId]  
		, SOSIR.PersonOfInterestId, SOSIR.PersonOfInterestName, SOSIR.PersonOfInterestLastName, SOSIR.[PersonOfInterestIdentifier], SOSIR.[PersonOfInterestMobilePhoneNumber], SOSIR.[PersonOfInterestMobileIMEI]  
		, SUM(IIF(SOSIR.IsMain = 1, SOSIR.[Total], 0)) AS CompanyTotal
	 FROM ShareOfShelfIR SOSIR
	 GROUP BY SOSIR.[Id], SOSIR.[Date], SOSIR.[IsManual], SOSIR.[IsValid], SOSIR.[DiscardReason], SOSIR.[GrandTotal], SOSIR.[ValidationImage] 
		, SOSIR.PointOfInterestId, SOSIR.PointOfInterestName, SOSIR.PointOfInterestIdentifier, SOSIR.[PointOfInterestDepartment], SOSIR.[PointOfInterestDepartmentName], SOSIR.[PointOfInterestAddress]
		, SOSIR.[PointOfInterestContactName], SOSIR.[PointOfInterestContactPhoneNumber]  
		, SOSIR.HierarchyLevel1Id, SOSIR.HierarchyLevel2Id, SOSIR.HierarchyLevel1Name, SOSIR.HierarchyLevel2Name, SOSIR.[HierarchyLevel1SapId], SOSIR.[HierarchyLevel2SapId]  
		, SOSIR.PersonOfInterestId, SOSIR.PersonOfInterestName, SOSIR.PersonOfInterestLastName, SOSIR.[PersonOfInterestIdentifier], SOSIR.[PersonOfInterestMobilePhoneNumber], SOSIR.[PersonOfInterestMobileIMEI]  
 )
 -- Join with categories and imgs
 SELECT SOSIR.[Id], SOSIR.[Date], SOSIR.[IsManual], SOSIR.[IsValid], SOSIR.[DiscardReason], SOSIR.[GrandTotal], SOSIR.[ValidationImage]
    , SOSIR.PointOfInterestId, SOSIR.PointOfInterestName, SOSIR.PointOfInterestIdentifier, SOSIR.[PointOfInterestDepartment], SOSIR.[PointOfInterestDepartmentName], SOSIR.[PointOfInterestAddress]
	, SOSIR.[PointOfInterestContactName], SOSIR.[PointOfInterestContactPhoneNumber]  
    , SOSIR.HierarchyLevel1Id, SOSIR.HierarchyLevel2Id, SOSIR.HierarchyLevel1Name, SOSIR.HierarchyLevel2Name, SOSIR.[HierarchyLevel1SapId], SOSIR.[HierarchyLevel2SapId]  
    , SOSIR.PersonOfInterestId, SOSIR.PersonOfInterestName, SOSIR.PersonOfInterestLastName, SOSIR.[PersonOfInterestIdentifier], SOSIR.[PersonOfInterestMobilePhoneNumber], SOSIR.[PersonOfInterestMobileIMEI]  
	, SOSIR.CompanyTotal
	, PC.[Id] as CategoryId, PC.[Name] as CategoryName
	, SI.[Id] AS [ImageId], SI.[ImageUrl], SI.[ImageName]

 FROM ShareOfShelfIRWithTotals SOSIR
	INNER JOIN  [dbo].[ShareOfShelfProductCategory] SOSPC WITH(NOLOCK) ON SOSIR.Id = SOSPC.IdShareOfShelf  
	INNER JOIN  [dbo].[ProductCategory] PC WITH(NOLOCK) ON PC.Id = SOSPC.IdProductCategory  
	INNER JOIN dbo.ShareOfShelfImage SI ON SOSIR.Id = SI.IdShareOfShelf
 GROUP BY SOSIR.[Id], SOSIR.[Date], SOSIR.[IsManual], SOSIR.[IsValid], SOSIR.[DiscardReason], SOSIR.[GrandTotal], SOSIR.[ValidationImage]
    , SOSIR.PointOfInterestId, SOSIR.PointOfInterestName, SOSIR.PointOfInterestIdentifier, SOSIR.[PointOfInterestDepartment], SOSIR.[PointOfInterestDepartmentName], SOSIR.[PointOfInterestAddress]
	, SOSIR.[PointOfInterestContactName], SOSIR.[PointOfInterestContactPhoneNumber]  
    , SOSIR.HierarchyLevel1Id, SOSIR.HierarchyLevel2Id, SOSIR.HierarchyLevel1Name, SOSIR.HierarchyLevel2Name, SOSIR.[HierarchyLevel1SapId], SOSIR.[HierarchyLevel2SapId]  
    , SOSIR.PersonOfInterestId, SOSIR.PersonOfInterestName, SOSIR.PersonOfInterestLastName, SOSIR.[PersonOfInterestIdentifier], SOSIR.[PersonOfInterestMobilePhoneNumber], SOSIR.[PersonOfInterestMobileIMEI]  
	, SOSIR.CompanyTotal
	, PC.[Id], PC.[Name]
	, SI.[Id], SI.[ImageUrl], SI.[ImageName]
 ORDER BY SOSIR.[Date] DESC, SOSIR.[Id] DESC, PC.[Id] ASC, SI.[Id] ASC
  
END
