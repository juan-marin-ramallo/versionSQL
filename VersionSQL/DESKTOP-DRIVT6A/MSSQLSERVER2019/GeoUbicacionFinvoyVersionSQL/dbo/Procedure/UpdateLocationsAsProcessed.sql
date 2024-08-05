/****** Object:  Procedure [dbo].[UpdateLocationsAsProcessed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/06/2015
-- Description:	SP para marcar varias locaciones como procesadas
-- =============================================
CREATE PROCEDURE [dbo].[UpdateLocationsAsProcessed]
(
	--@Ids [sys].[varchar](1000)
	@Ids [dbo].IdTableType READONLY
)
AS
BEGIN
	UPDATE	L
	SET		L.[Processed] = 1
	FROM	@Ids I
			INNER JOIN [dbo].[Location] L ON L.[Id] = I.[Id]
END
