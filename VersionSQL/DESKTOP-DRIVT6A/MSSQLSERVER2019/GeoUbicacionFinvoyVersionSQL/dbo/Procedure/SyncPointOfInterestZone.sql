/****** Object:  Procedure [dbo].[SyncPointOfInterestZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/04/2021
-- Description:	Para sincronizar agrupaciones DE PUNTOS
-- =============================================
CREATE PROCEDURE [dbo].[SyncPointOfInterestZone]
(
	 @Zones [ZonesTableType] READONLY
)
AS
BEGIN
	INSERT [dbo].[Zone] ([Description], [Date], ApplyToAllPersonOfInterest, ApplyToAllPointOfInterest)
	SELECT  Z.[Description], CURRENT_TIMESTAMP,0,0
	FROM    @Zones Z
			LEFT OUTER JOIN [dbo].[Zone] Z2 ON Z.[Description] = Z2.[Description]
	WHERE   Z2.[Id] IS NULL

END
