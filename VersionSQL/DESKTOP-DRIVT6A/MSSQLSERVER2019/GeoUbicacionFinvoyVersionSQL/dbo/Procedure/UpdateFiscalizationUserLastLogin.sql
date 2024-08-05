/****** Object:  Procedure [dbo].[UpdateFiscalizationUserLastLogin]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 17/08/2023
-- Description:	SP para actualizar la fecha/hora
--				de último acceso para un usuario
--				fiscalizador
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFiscalizationUserLastLogin]
(
	 @Id [sys].[int]
    ,@Ip [sys].[varchar](20)
)
AS
BEGIN
	UPDATE	[dbo].[FiscalizationUser]
	SET		[LastLoginDate] = GETUTCDATE(), [LastLoginIp] = @Ip
	WHERE	[Id] = @Id
END
