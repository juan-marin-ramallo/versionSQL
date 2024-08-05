/****** Object:  Procedure [dbo].[UpdateUserPermissionWithType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/07/2017
-- Description:	SP para ACTUALIZAR los permisos de un usuario que tenga un tipo en particular
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserPermissionWithType]
(
	 @IdUserType [sys].[int]
)
AS
BEGIN
	DELETE FROM [dbo].[UserPermission] where [IdUser] IN (SELECT  U.[Id] FROM [dbo].[User] U WHERE U.[Type] = @IdUserType)
	
	INSERT INTO [dbo].[UserPermission](IdUser, IdPermission, CanView, CanEdit, CanViewAll)
	SELECT	U.[Id], UTP.[IdPermission], UTP.[View], UTP.[Edit], UTP.[ViewAll]
	FROM	[dbo].[User] U
			INNER JOIN [dbo].[UserTypePermission] UTP ON UTP.[IdUserType] = U.[Type]
	WHERE	UTP.[IdUserType] = @IdUserType
END

-- OLD)
--ALTER PROCEDURE [dbo].[UpdateUserPermissionWithType]
--(
--	 @IdUserType [sys].[int]
--)
--AS
--BEGIN

--	DELETE FROM [dbo].[UserPermission] where [IdUser] IN (SELECT  U.[Id] FROM [dbo].[User] U WHERE U.[Type] = @IdUserType)
	
--	DECLARE @IdAux  AS INT
	
--	DECLARE cur CURSOR FOR SELECT U.[Id]
--	FROM 	dbo.[User] U
--	WHERE	U.[Type] = @IdUserType
    
--	OPEN cur

--	FETCH NEXT FROM cur INTO @IdAux

--		WHILE @@FETCH_STATUS = 0 
--		BEGIN
--			INSERT INTO [dbo].[UserPermission](IdUser, IdPermission, CanView, CanEdit, CanViewAll)
--			SELECT	@IdAux, UTP.[IdPermission], UTP.[View], UTP.[Edit], UTP.[ViewAll]
--			FROM	[dbo].[UserTypePermission] UTP 
--			WHERE	[IdUserType] = @IdUserType
	
--		FETCH NEXT FROM cur INTO @IdAux
--		END

--	CLOSE cur    
--	DEALLOCATE cur

--END
