/****** Object:  Procedure [dbo].[GetIsUserWorkPlan]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetIsUserWorkPlan]
     @Id [sys].[int]
    ,@IdUser [sys].[int]
AS
BEGIN
    SELECT	1
    FROM	[dbo].[WorkPlan] WITH (NOLOCK)
    WHERE   [Id] = @Id
			AND [IdUser] = @IdUser
END
