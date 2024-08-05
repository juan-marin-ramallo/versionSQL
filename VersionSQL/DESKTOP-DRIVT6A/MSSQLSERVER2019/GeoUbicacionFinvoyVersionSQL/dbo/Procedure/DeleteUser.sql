/****** Object:  Procedure [dbo].[DeleteUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para eliminar un usuario
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUser]
(
	 @Id [sys].[int]
)
AS
BEGIN
	-- Obtengo todas las notis con subscriptores
	DECLARE @SubsCount Table(CodeNotification [int], SubCount [int])
	INSERT INTO @SubsCount (CodeNotification, SubCount)
	SELECT n.CodeNotification, COUNT(n.IdUser) as SubCount
	FROM [dbo].[UserNotification] n
	INNER JOIN [dbo].[User] u on u.Id = n.IdUser and u.[Status] = 'H'
	GROUP BY n.CodeNotification
	HAVING COUNT(n.IdUser) > 0

	--DELETE FROM	[dbo].[User]
	--WHERE		Id = @Id
	UPDATE [dbo].[User]
	SET Status = 'D'
	WHERE Id=@Id

	-- de las notis con subscriptores obtengo las que no tienen más subscriptores
	SELECT sc.CodeNotification
	FROM @SubsCount sc
	LEFT OUTER JOIN [dbo].[UserNotification] n ON n.CodeNotification = sc.CodeNotification
	LEFT OUTER JOIN [dbo].[User] u on u.Id = n.IdUser and u.[Status] = 'H'
	GROUP BY sc.CodeNotification, sc.SubCount
	HAVING COUNT(u.Id) = 0

END
