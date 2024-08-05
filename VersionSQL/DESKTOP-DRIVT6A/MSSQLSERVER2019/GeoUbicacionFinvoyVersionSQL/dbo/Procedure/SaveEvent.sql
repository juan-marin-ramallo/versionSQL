/****** Object:  Procedure [dbo].[SaveEvent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 24/09/2012
-- Description:	SP para guardar una evento
-- =============================================
CREATE PROCEDURE [dbo].[SaveEvent]
(
	 @Date [sys].[datetime]
	,@IdPersonOfInterest [sys].[varchar](20)
	,@Type [sys].[varchar](10)
)
AS
BEGIN
	-- Se inserta cualquier tipo de evento. Si es 'Primera Vez De Uso' se inserta una sola vez por stocker imei
	IF @Type <> 'PVU' OR NOT EXISTS(SELECT E.[Id] FROM [dbo].[Event] E WHERE E.[IdPersonOfInterest] = @IdPersonOfInterest AND E.[Type] = 'PVU')
	BEGIN
		INSERT INTO [dbo].[Event]([Date], [IdPersonOfInterest], [Type])
		VALUES (@Date, @IdPersonOfInterest, @Type)
	END
END
