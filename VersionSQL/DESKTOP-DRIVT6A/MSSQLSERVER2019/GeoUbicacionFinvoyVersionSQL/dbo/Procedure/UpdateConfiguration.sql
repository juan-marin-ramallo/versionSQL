/****** Object:  Procedure [dbo].[UpdateConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/09/2012
-- Description:	SP para obtener las configuraciones
-- =============================================
CREATE PROCEDURE [dbo].[UpdateConfiguration]
(
	 @Id [sys].[int]
	,@Value [sys].[varchar](250)
)
AS
BEGIN
    DECLARE @PreviousSystemTimeZone [sys].[varchar](250)
    SET @PreviousSystemTimeZone = NULL

    IF @Id = 1070 --ZonaHorariaSistema
	BEGIN
        SET @PreviousSystemTimeZone = (SELECT TOP(1) [Value] FROM [dbo].[Configuration] WHERE [Id] = @Id)
	END

	UPDATE	[dbo].[Configuration]
	SET		[Value] = @Value
	WHERE	[Id] = @Id

	IF @PreviousSystemTimeZone IS NOT NULL AND @PreviousSystemTimeZone <> @Value
	BEGIN
        DELETE FROM [dbo].[SystemTimeZoneDetail]
        
		INSERT INTO [dbo].[SystemTimeZoneDetail]([OffsetMinutes], [UtcStart], [UtcEnd], [LocalStart], [LocalEnd])
		SELECT	I.OffsetMinutes, I.UtcStart, I.UtcEnd, I.LocalStart, I.LocalEnd
		FROM	[Tzdb].[Intervals] AS I WITH (NOLOCK)
		WHERE	I.[ZoneId] = Tzdb.GetZoneId(@Value)
	END

	SELECT TOP 1 n.Code
	FROM [dbo].[Notification] n
		INNER JOIN [dbo].[UserNotification] un on un.CodeNotification = n.Code
		INNER JOIN [dbo].[User] u on u.Id = un.IdUser and u.[Status] = 'H'
	WHERE n.IdConfiguration = @Id
END
