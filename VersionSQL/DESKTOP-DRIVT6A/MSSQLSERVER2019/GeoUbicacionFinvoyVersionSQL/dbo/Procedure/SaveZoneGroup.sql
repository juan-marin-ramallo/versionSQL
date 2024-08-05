/****** Object:  Procedure [dbo].[SaveZoneGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repetto
-- Create date: 25/09/2012
-- Description:	SP para guardar una Zona
-- =============================================
create PROCEDURE [dbo].[SaveZoneGroup]
(
	@idPersonOfInterest [sys].[int]
	,@idZone [sys].[int]

)
AS
BEGIN

	INSERT INTO [dbo].[ZonePersonOfInterest](IdPersonOfInterest, IdZone)
	VALUES (@idPersonOfInterest, @idZone)
END
