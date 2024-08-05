/****** Object:  Procedure [dbo].[UpdatePersonOfInterestType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Jesús Portillo  
-- Create date: 25/09/2012  
-- Description: SP para eliminar un repositor  
-- =============================================  
CREATE PROCEDURE [dbo].[UpdatePersonOfInterestType]  
(  
  @Code [sys].[char](1),  
  @Description [sys].[varchar](20),  
  @IdPermissions [sys].[varchar](max),  
  @IdTimeZone [sys].[varchar](50)  = NULL
)  
AS  
BEGIN  
 UPDATE [dbo].[PersonOfInterestType]  
 SET [Description] = @Description,
	IdTimeZone = @IdTimeZone
 WHERE [Code] = @Code  
  
 DELETE [dbo].[PersonOfInterestTypePermission]  
 WHERE [CodePersonOfInterestType] = @Code  
  AND [dbo].[CheckValueInList](IdPersonOfInterestPermission, @IdPermissions) = 0  
  
 INSERT INTO [dbo].[PersonOfInterestTypePermission] ([CodePersonOfInterestType], IdPersonOfInterestPermission)  
 SELECT @Code ,P.[Id]  
 FROM [dbo].[PersonOfInterestPermissionTranslated] P  
  LEFT OUTER JOIN [PersonOfInterestTypePermission] T ON P.[Id] = T.[IdPersonOfInterestPermission] AND T.[CodePersonOfInterestType] = @Code  
 WHERE T.[CodePersonOfInterestType] IS NULL AND [dbo].[CheckValueInList](P.[Id], @IdPermissions) > 0  
  
END
