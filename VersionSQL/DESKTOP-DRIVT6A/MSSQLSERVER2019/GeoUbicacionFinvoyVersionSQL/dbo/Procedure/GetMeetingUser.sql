/****** Object:  Procedure [dbo].[GetMeetingUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/11/2017
-- Description:	SP para obtener algunos datos del usuario creador de una reunión
-- =============================================
CREATE PROCEDURE [dbo].[GetMeetingUser]
    @Id [sys].[int]
AS
BEGIN
    SELECT	U.[Id], U.[Name], U.[LastName], U.[Email]
    FROM    [dbo].[User] U
			INNER JOIN [dbo].[Meeting] M ON M.[UserId] = U.[Id]
    WHERE   M.[Id] = @Id;
END
