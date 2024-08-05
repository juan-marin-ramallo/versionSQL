/****** Object:  Procedure [dbo].[SavePersonOfInterestType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Jesús Portillo  
-- Create date: 25/09/2012  
-- Description: SP para eliminar un repositor  
-- =============================================  
CREATE PROCEDURE [dbo].[SavePersonOfInterestType]  
(  
  @Description [sys].[varchar](20),  
  @IdPermissions [sys].[varchar](max),
  @IdTimeZone [sys].[varchar](50) = NULL
)  
AS  
BEGIN  
 DECLARE @Code [sys].[char](1) = LEFT(@Description, 1)  
  
 IF EXISTS (SELECT TOP 1 1 FROM [dbo].[PersonOfInterestType] WHERE Code = @Code)  
 BEGIN  
  SET @Code = (SELECT TOP 1 P.Code  
     FROM ( SELECT 'A' as Code UNION SELECT 'B' as Code UNION SELECT 'C' as Code UNION SELECT 'D' as Code  
       UNION SELECT 'E' as Code UNION SELECT 'F' as Code UNION SELECT 'G' as Code UNION SELECT 'H' as Code  
       UNION SELECT 'I' as Code UNION SELECT 'J' as Code UNION SELECT 'K' as Code UNION SELECT 'L' as Code  
       UNION SELECT 'M' as Code UNION SELECT 'N' as Code UNION SELECT 'Ñ' as Code UNION SELECT 'O' as Code  
       UNION SELECT 'P' as Code UNION SELECT 'Q' as Code UNION SELECT 'R' as Code UNION SELECT 'S' as Code  
       UNION SELECT 'T' as Code UNION SELECT 'U' as Code UNION SELECT 'V' as Code UNION SELECT 'W' as Code  
       UNION SELECT 'X' as Code UNION SELECT 'Y' as Code UNION SELECT 'Z' as Code) P  
     WHERE P.[Code] NOT IN (SELECT T.[Code] FROM [dbo].[PersonOfInterestType] T))  
 END  
  
 INSERT INTO [dbo].[PersonOfInterestType]([Code], [Description],[IdTimeZone])  
 VALUES (@Code, @Description, @IdTimeZone)  
  
 INSERT INTO [dbo].[PersonOfInterestTypePermission] ([CodePersonOfInterestType], IdPersonOfInterestPermission)  
 SELECT @Code ,P.[Id]  
 FROM [dbo].[PersonOfInterestPermissionTranslated] P  
 WHERE [dbo].[CheckValueInList](P.[Id], @IdPermissions) > 0  
  
END
