/****** Object:  Procedure [dbo].[SaveUserDepartments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/11/2012
-- Description:	SP para guardar departamentos de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserDepartments]
(
	 @IdUser [sys].[int]
	,@IdDepartments [sys].[varchar](200)
)
AS
BEGIN
	INSERT INTO [dbo].[UserDepartment](IdUser, IdDepartment)
	(SELECT	@IdUser, D.[Id]
	FROM	[dbo].[Department] D
	WHERE	dbo.CheckValueInList(D.[Id], @IdDepartments) = 1)
END
