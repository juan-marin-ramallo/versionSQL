/****** Object:  Procedure [dbo].[GetOrdersReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE [dbo].[GetOrdersReport]      
  @IdPointsOfInterest varchar(MAX) = NULL      
 ,@IdPersonsOfInterest varchar(MAX) = NULL      
 ,@IdUser int = NULL      
 ,@DateFrom datetime = NULL      
 ,@DateTo datetime = NULL      
 ,@IdOrderReport int = null      
 ,@Limit int = 2147483647      
AS      
BEGIN      
      
 ;WITH FilteredOrders as (      
  SELECT TOP (@Limit) O.[Id],O.[IdPersonOfInterest],O.[IdPointOfInterest]      
   , O.[OrderDateTime], O.[ReceivedDateTime], O.[Comment], O.[Emails], O.[Status]      
   , S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier      
   , POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier      
  FROM [dbo].[OrderReport] O      
   INNER JOIN [dbo].[PersonOfInterest] S ON O.IdPersonOfInterest = S.Id      
   INNER JOIN [dbo].[PointOfInterest] POI ON O.IdPointOfInterest = POI.Id      
  WHERE (@DateFrom IS NULL OR O.OrderDateTime BETWEEN @DateFrom AND @DateTo)      
   AND (@IdOrderReport IS NULL OR O.Id = @IdOrderReport)      
   AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(O.[IdPersonOfInterest], @IdPersonsOfInterest) = 1))       
   AND ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(O.[IdPointOfInterest], @IdPointsOfInterest) = 1))         
   AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(O.[IdPersonOfInterest], @IdUser) = 1))      
   AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(O.[IdPointOfInterest], @IdUser) = 1))      
   AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))      
   AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))       
  ORDER BY O.OrderDateTime DESC      
 )      
 SELECT  O.[Id],O.[IdPersonOfInterest],O.[IdPointOfInterest]      
   , O.[OrderDateTime], O.[ReceivedDateTime], O.[Comment], O.[Emails], O.[Status]      
   , O.PersonOfInterestName, O.PersonOfInterestLastName, O.PersonOfInterestIdentifier      
   , O.PointOfInterestName, O.PointOfInterestIdentifier      
   , OP.[Id] AS IdOrderReportProductQuantity, OP.[IdProduct], OP.[Quantity]      
   , P.[Name] AS ProductName,P.[BarCode] AS ProductBarCode,P.[Identifier] AS ProductIdentifier      
   , OV.Id AS IdOrderReportAttributeValue, OV.[Value], OV.[ImageName], OV.[ImageUrl]      
   , OA.[Id] AS IdOrderReportAttribute, OA.[Name] AS OrderReportAttributeName, OA.[IdType]      
   , OO.Id AS IdOrderReportAttributeOption, OO.[Text] AS OrderReportAttributeOptionText      
   , OS.[Name] AS StatusName
 FROM FilteredOrders O      
  INNER JOIN [dbo].[OrderReportProductQuantity] OP ON O.Id = OP.IdOrderReport      
  INNER JOIN [dbo].[Product] P ON OP.IdProduct = P.Id      
  LEFT OUTER JOIN [dbo].[OrderReportAttributeValue] OV ON O.Id = OV.IdOrderReport and OP.IdProduct = OV.IdProduct      
  LEFT OUTER JOIN [dbo].[OrderReportAttribute] OA ON OV.IdOrderReportAttribute = OA.Id      
  LEFT OUTER JOIN [dbo].[OrderReportAttributeOption] OO ON OV.IdOrderReportAttributeOption = OO.Id      
  LEFT OUTER JOIN [dbo].[OrderStatus] OS ON O.[Status] = OS.Id      
 ORDER BY O.OrderDateTime DESC, OP.Id ASC, OA.[Order] ASC      
      
END
