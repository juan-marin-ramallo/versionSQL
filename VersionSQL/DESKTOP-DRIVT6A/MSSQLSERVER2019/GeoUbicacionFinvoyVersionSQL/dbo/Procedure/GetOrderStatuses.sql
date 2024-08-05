/****** Object:  Procedure [dbo].[GetOrderStatuses]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cristian Barbarini  
-- Create date: 15/08/2023  
-- Description: Devuelve los estados disponibles para los pedidos  
-- =============================================  
CREATE PROCEDURE [dbo].[GetOrderStatuses]  
AS  
BEGIN  
  
SELECT os.*, ons.IdNextStatus  
FROM OrderStatus os  
LEFT JOIN OrderNextStatus ons ON os.Id = ons.IdStatus  
  
SELECT *  
FROM OrderStatusDocument osd  
INNER JOIN OrderStatus os ON osd.IdStatus = os.Id  
  
END
