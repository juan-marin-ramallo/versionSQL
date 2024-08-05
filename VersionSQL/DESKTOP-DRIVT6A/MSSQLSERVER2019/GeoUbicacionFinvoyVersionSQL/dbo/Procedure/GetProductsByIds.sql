/****** Object:  Procedure [dbo].[GetProductsByIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cristian Barbarini  
-- Create date: 19/12/23  
-- Description: Busca productos por Ids  
-- =============================================  
CREATE PROCEDURE [dbo].[GetProductsByIds]  
 @ProductsId VARCHAR(MAX) = NULL  
AS  
BEGIN  
 SELECT P.[Id], P.[Name], P.[Identifier], P.[BarCode], P.[Indispensable]  
 FROM [dbo].[Product] P WITH (NOLOCK)  
 WHERE dbo.CheckValueInList(P.[Id], @ProductsId)=1  
END
