/****** Object:  Procedure [dbo].[DeleteZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repetto
-- Create date: 25/09/2012
-- Description:	SP para eliminar una Zona
-- =============================================
CREATE PROCEDURE [dbo].[DeleteZone]
(
	 @Id [sys].[int],
	 @ResultCode [sys].[int] OUTPUT
)
AS
BEGIN

	--if (@Id in(select uz.IdZone From [dbo].[UserZone] uz) or @Id in(select poiz.IdZone From[dbo].[PointOfInterestZone] poiz) or @Id in(select peoiz.IdZone From[dbo].[PersonOfInterestZone] peoiz))
	--	BEGIN
	--		set @ResultCode=0;
	--	END
	--else
	--	BEGIN

			DELETE 
			FROM	[dbo].[PointOfInterestZone] 
			WHERE	[IdZone] = @Id

			DELETE 
			FROM	[dbo].[PersonOfInterestZone] 
			WHERE	[IdZone] = @Id

			DELETE 
			FROM	[dbo].[UserZone] 
			WHERE	[IdZone] = @Id

			DELETE FROM	[dbo].[Zone] 
			WHERE Id = @Id 
			set @ResultCode=1;
		--END
END
