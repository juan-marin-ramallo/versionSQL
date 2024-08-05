/****** Object:  Procedure [dbo].[GetPersonOfInterestStatistics]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- Modified by: Juan Marin
-- Modified Date: 06/12/2023
-- Description: Para corregir problema en la GT-483 se comenta CASE usado para mostrar el PointOfInterestName
-- =============================================  
CREATE PROCEDURE [dbo].[GetPersonOfInterestStatistics]  
  @Id int,  
  @Date datetime,  
  @IncludeAutomaticVisits bit,  
  @IdUser int = NULL  
AS  
BEGIN  
   
 DECLARE @AutomaticInType int = 0  
 DECLARE @AutomaticOutType int = 1  
 DECLARE @ManualInType int = 2  
 DECLARE @ManualOutType int = 3  
 DECLARE @NfcInType int = 4  
 DECLARE @NfcOutType int = 5  
 DECLARE @MarkType int = 6  
 DECLARE @CompletedFormType int = 7  
 DECLARE @MissingProductsType int = 8  
 DECLARE @ProductReportType int = 9  
 DECLARE @ProductRefundType int = 10  
 DECLARE @DocumentReportType int = 11  
 DECLARE @AssetReportType int = 12  
 DECLARE @IncidentReportType int = 13  
 DECLARE @PhotoReportType int = 14  
 DECLARE @ShareOfShelfType int = 15  
 DECLARE @OrderReportType int = 16  
 DECLARE @AssortmentReportType int = 17  
  
 SELECT   
  [Date],  
  [Latitude],  
  [Longitude],   
  /*(CASE WHEN tbl.[Latitude] = 0 or tbl.[Longitude] = 0 then NULL ELSE tbl.[PointOfInterestName] END) AS*/ [PointOfInterestName],  
  [TypeSpecificValues],  
  [TypeSpecificId],  
  [Type]  
 FROM  
 (  
  -- Marca entrada automatica  
  SELECT POIV.[LocationInDate] AS [Date],  
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @AutomaticInType AS [Type]  
  FROM PersonOfInterest P  
  JOIN PointOfInterestVisited POIV ON P.[Id] = POIV.[IdPersonOfInterest]  
  JOIN PointOfInterest POI ON POI.[Id] = POIV.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(POIV.[LocationInDate], @Date) = 1  
  
  UNION  
  
  -- Marca salida automatica  
  SELECT POIV.[LocationOutDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @AutomaticOutType AS [Type]  
  FROM PersonOfInterest P  
  JOIN PointOfInterestVisited POIV ON P.[Id] = POIV.[IdPersonOfInterest]  
  JOIN PointOfInterest POI ON POI.[Id] = POIV.[IdPointOfInterest]  
  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(POIV.[LocationOutDate], @Date) = 1  
   
  UNION  
  
  -- Marca entrada manual   
  SELECT POIMV.[CheckInDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @ManualInType AS [Type]  
  FROM PersonOfInterest P  
  JOIN PointOfInterestManualVisited POIMV ON P.[Id] = POIMV.[IdPersonOfInterest]  
  JOIN PointOfInterest POI ON POI.[Id] = POIMV.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(POIMV.[CheckInDate], @Date) = 1  
  
  UNION  
  
  -- Marca salida manual  
  SELECT POIMV.[CheckOutDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @ManualOutType AS [Type]  
  FROM PersonOfInterest P  
  JOIN PointOfInterestManualVisited POIMV ON P.[Id] = POIMV.[IdPersonOfInterest]  
  JOIN PointOfInterest POI ON POI.[Id] = POIMV.[IdPointOfInterest]  
  WHERE P.[Id] = @Id       AND Tzdb.AreSameSystemDates(POIMV.[CheckOutDate], @Date) = 1  
  
  UNION  
  
  -- Marca entrada NFC  
  SELECT POIM.[CheckInDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @NfcInType AS [Type]  
  FROM PersonOfInterest P  
  JOIN PointOfInterestMark POIM ON P.[Id] = POIM.[IdPersonOfInterest]  
  JOIN PointOfInterest POI ON POI.[Id] = POIM.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(POIM.[CheckInDate], @Date) = 1  
  
  UNION  
  
  -- Marca salida NFC  
  SELECT POIM.[CheckOutDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @NfcOutType AS [Type]  
  FROM PersonOfInterest P  
  JOIN PointOfInterestMark POIM ON P.[Id] = POIM.[IdPersonOfInterest]  
  JOIN PointOfInterest POI ON POI.[Id] = POIM.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(POIM.[CheckOutDate], @Date) = 1  
  
  UNION  
  
  -- Marca de tarjetero  
  SELECT M.[Date] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      M.[Type] AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @MarkType AS [Type]  
  FROM PersonOfInterest P  
  JOIN Mark M ON P.[Id] = M.[IdPersonOfInterest]  
  LEFT OUTER JOIN PointOfInterest POI ON POI.[Id] = M.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(M.[Date], @Date) = 1  
  
  UNION  
  
  -- Tarea completada  
  SELECT CF.[Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      CF.[Latitude],   
      CF.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      F.[Name] AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @CompletedFormType AS [Type]  
  FROM PersonOfInterest P  
  JOIN [dbo].[CompletedForm] CF ON CF.[IdPersonOfInterest] = P.[Id]  
  LEFT OUTER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = CF.[IdPointOfInterest]  
  JOIN [dbo].[Form] F ON F.[Id] = CF.[IdForm]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(CF.[Date], @Date) = 1  
    
  UNION  
  
  -- Faltante de productos  
  SELECT PM.[Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      PR.[Name] AS TypeSpecificValues,  
      PM.[Id] AS TypeSpecificId,  
      @MissingProductsType AS [Type]  
  FROM PersonOfInterest P  
  JOIN [dbo].[ProductMissingPointOfInterest] PM ON PM.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PM.[IdPointOfInterest]  
  JOIN [dbo].[ProductMissingReport] PMR ON PMR.[IdMissingProductPoi] = PM.[Id]  
  JOIN [dbo].[Product] PR ON PR.[Id] = PMR.[IdProduct]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(PM.[Date], @Date) = 1  
   
  UNION  
  
  -- Reporte de SKU (un producto)  
  SELECT PRD.[ReportDateTime] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      PR.[Name] AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @ProductReportType AS [Type]  
  FROM PersonOfInterest P  
  JOIN [dbo].[ProductReportDynamic] PRD ON PRD.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PRD.[IdPointOfInterest]  
  JOIN [dbo].[Product] PR ON PR.[Id] = PRD.[IdProduct]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(PRD.[ReportDateTime], @Date) = 1  
  
  UNION  
  
  -- Devolucion de SKU  
  SELECT PRF.[Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      PR.[Name] AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @ProductRefundType AS [Type]  
  FROM PersonOfInterest P  
  JOIN [dbo].[ProductRefund] PRF ON PRF.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PRF.[IdPointOfInterest]  
  JOIN [dbo].[Product] PR ON PR.[Id] = PRF.[IdProduct]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(PRF.[Date], @Date) = 1  
  
  UNION  
  
  -- Reporte de documentos  
  SELECT D.[Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @DocumentReportType AS [Type]  
  FROM [dbo].[PersonOfInterest] P   
  JOIN [dbo].[DocumentReport] D ON D.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = D.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(D.[Date], @Date) = 1  
      
  UNION  
  
  -- Reporte de activos  
  SELECT A.[Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @AssetReportType AS [Type]  
  FROM [dbo].[PersonOfInterest] P   
  JOIN [dbo].[AssetReportDynamic] A ON A.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = A.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(A.[Date], @Date) = 1  
  
  UNION  
  
  -- Reporte de observaciones  
  SELECT I.[CreatedDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @IncidentReportType AS [Type]  
  FROM [dbo].[PersonOfInterest] P   
  JOIN [dbo].[Incident] I ON I.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = I.[IdPointOfInterest]  
  WHERE P.[Id] = @Id   
    AND Tzdb.AreSameSystemDates(I.[CreatedDate], @Date) = 1  
  
  UNION  
  
  -- Reporte de antes y despues  
  SELECT PR.[ReportDate] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @PhotoReportType AS [Type]  
  FROM [dbo].[PersonOfInterest] P  
  JOIN [dbo].[PhotoReport] PR ON PR.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PR.[IdPointOfInterest]  
  WHERE P.[Id] = @Id  
    AND Tzdb.AreSameSystemDates(PR.[ReportDate], @Date) = 1  
  
  UNION  
  
  -- Reporte SOS  
  SELECT SOS.[Date] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @ShareOfShelfType AS [Type]  
  FROM [dbo].[PersonOfInterest] P  
  JOIN [dbo].[ShareOfShelfReport] SOS ON SOS.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = SOS.[IdPointOfInterest]  
  WHERE P.[Id] = @Id  
    AND Tzdb.AreSameSystemDates(SOS.[Date], @Date) = 1  
  
  UNION  
  
  -- Reporte de Pedidos  
  SELECT O.[OrderDateTime] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @OrderReportType AS [Type]  
  FROM [dbo].[PersonOfInterest] P  
  JOIN [dbo].[OrderReport] O ON O.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = O.[IdPointOfInterest]  
  WHERE P.[Id] = @Id  
    AND Tzdb.AreSameSystemDates(O.[OrderDateTime], @Date) = 1  
  
  UNION  
  
  -- Reporte de Cumplimiento de Surtido  
  SELECT AR.[Date] AS [Date],   
      P.[Id] AS IdPersonOfInterest,   
      P.[IdDepartment] AS IdDepartmentPerson,  
      POI.[Id] AS IdPointOfInterest,   
      POI.[IdDepartment] AS IdDepartmentPoint,  
      POI.[Latitude],   
      POI.[Longitude],  
      POI.[Name] AS [PointOfInterestName],  
      NULL AS TypeSpecificValues,  
      NULL AS TypeSpecificId,  
      @AssortmentReportType AS [Type]  
  FROM [dbo].[PersonOfInterest] P  
  JOIN [dbo].[AssortmentReport] AR ON AR.[IdPersonOfInterest] = P.[Id]  
  JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = AR.[IdPointOfInterest]  
  WHERE P.[Id] = @Id  
    AND Tzdb.AreSameSystemDates(AR.[Date], @Date) = 1  
  
 ) AS tbl  
   
 WHERE ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones([IdPersonOfInterest], @IdUser) = 1))  
   AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments([IdDepartmentPerson], @IdUser) = 1))  
   AND ((@IdUser IS NULL) OR ([IdPointOfInterest] IS NULL) OR (dbo.CheckUserInPointOfInterestZones([IdPointOfInterest], @IdUser) = 1))  
   AND ((@IdUser IS NULL) OR ([IdDepartmentPoint] IS NULL) OR (dbo.CheckDepartmentInUserDepartments([IdDepartmentPoint], @IdUser) = 1))  
  -- AND (tbl.[Latitude] <>0 or tbl.[Longitude]<>0)  
  
 ORDER BY [Date]  
  
END
