/****** Object:  Procedure [dbo].[GetOrderStatusTrazabilitiesByOrderId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cristian Barbarini  
-- Create date: 15/08/2023  
-- Description: Devuelve los estados disponibles para los pedidos  
-- =============================================  
CREATE PROCEDURE [dbo].[GetOrderStatusTrazabilitiesByOrderId]  
 @IdOrderReport INT  
AS  
BEGIN  
  
 SELECT ort.[IdOrderReport], os.[Name] AS [StatusName], ort.[OrderDateTime], CASE WHEN peoi.[Id] IS NOT NULL THEN CONCAT(peoi.[Name], ' ', peoi.[LastName]) ELSE CONCAT(u.[Name], ' ', u.[LastName]) END AS PersonName, ordt.[IdType], ordt.[Comment], ordt.[ImageName], ordt.[ImageUrl]  
 FROM [dbo].[OrderReportTrazability] ort  
 LEFT JOIN [dbo].[OrderStatus] os ON ort.[Status] = os.Id  
 LEFT JOIN [dbo].[PersonOfInterest] peoi ON ort.[IdPersonOfInterest] = peoi.[Id]  
 LEFT JOIN [dbo].[User] u ON ort.[IdUser] = u.[Id]  
 LEFT JOIN [dbo].[OrderReportDocumentTrazability] ordt ON ort.[IdOrderReport] = ordt.[IdOrderReport] AND ort.[Status] = ordt.[Status]  
 WHERE ort.[IdOrderReport] = @IdOrderReport AND ort.[IsModification] = 0  
 GROUP BY ort.[IdOrderReport], os.[Name], ort.[OrderDateTime], peoi.[Id], peoi.[Name], peoi.[LastName], u.[Name], u.[LastName], ordt.[IdType], ordt.[Comment], ordt.[ImageName], ordt.[ImageUrl]  
 ORDER BY ort.[OrderDateTime]  
END
