/****** Object:  Procedure [dbo].[GetPersonOfInterestTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Jesús Portillo  
-- Create date: 08/02/2013  
-- Description: SP para obtener los tipos de reponedores  
-- =============================================  
CREATE PROCEDURE [dbo].[GetPersonOfInterestTypes]  
AS  
BEGIN  
 SELECT [Code], [Description], [IdTimeZone]
 FROM [dbo].[PersonOfInterestType]  
END
