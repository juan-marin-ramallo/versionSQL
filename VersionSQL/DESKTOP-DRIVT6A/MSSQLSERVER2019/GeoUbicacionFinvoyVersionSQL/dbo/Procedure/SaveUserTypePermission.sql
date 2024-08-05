/****** Object:  Procedure [dbo].[SaveUserTypePermission]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		JGL
-- Create date: 13/07/2017
-- Description:	SP para guardar permiso de un tipo de usuario
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserTypePermission]
(
	 @IdUserType [sys].[int]
	,@IdPermission [sys].[smallint]
	,@CanView [sys].[bit] = NULL
	,@CanEdit [sys].[bit] = NULL
	,@CanViewAll [sys].[BIT] = NULL
)
AS
BEGIN

	INSERT INTO [dbo].[UserTypePermission]([IdUserType], [IdPermission], [View], [Edit], [ViewAll])
	VALUES		(@IdUserType, @IdPermission, @CanView, @CanEdit, @CanViewAll)
END
