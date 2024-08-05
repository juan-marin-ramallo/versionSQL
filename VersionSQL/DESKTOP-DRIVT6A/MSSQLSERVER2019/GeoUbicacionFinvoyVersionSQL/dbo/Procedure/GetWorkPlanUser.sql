/****** Object:  Procedure [dbo].[GetWorkPlanUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/11/2017
-- Description:	SP para obtener algunos datos del usuario creador de un plan
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlanUser]
    @Id [sys].[int]
AS
BEGIN
    SELECT	U.[Id], U.[Name], U.[LastName], U.[Email]
    FROM    [dbo].[User] U
			INNER JOIN [dbo].[WorkPlan] WP ON WP.[IdUser] = U.[Id]
    WHERE   WP.[Id] = @Id;
END
