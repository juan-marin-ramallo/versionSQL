/****** Object:  Procedure [dbo].[GetUserWorkPlans]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para obtener un plan segun POI
-- =============================================
CREATE PROCEDURE [dbo].[GetUserWorkPlans]
    (
      @DateFrom [sys].[DATETIME] = NULL ,
      @DateTo [sys].[DATETIME] = NULL ,
	  @UsersIds [sys].[NVARCHAR](MAX) = NULL ,
      @WorkPlanStates [sys].[VARCHAR](MAX) = NULL ,
      @IdUser [sys].[INT] = NULL ,
      @Approval [sys].[BIT]
    )
AS
    BEGIN

        SELECT  wp.[Id], wp.[StartDate], wp.[EndDate], wp.[ApprovedState], wp.[ApprovingUserId], wp.[ApprovedDate],
				wp.[ApprovedReason], wp.[IdUser], wp.[CreationDate], wp.[Deleted], wp.[IdRouteGroup],
                u.[IdPersonOfInterest] ,
                u.[Name] AS UserName ,
                u.LastName AS UserLastName ,
                dbo.GetWorkPlanCompletitionFunctionById(wp.Id) AS Completition
        FROM    [dbo].WorkPlan wp
                INNER JOIN dbo.[User] u ON u.Id = wp.IdUser
        WHERE   ( ( @DateFrom IS NULL )
                  OR ( @DateTo IS NULL )
                  OR wp.StartDate BETWEEN @DateFrom AND @DateTo
                )
                AND wp.Deleted = 0
                AND ( @WorkPlanStates IS NULL
                      OR dbo.[CheckValueInList](wp.ApprovedState, @WorkPlanStates) = 1
                    )
                AND ( ( @Approval = 0 --Es para planificacion
                        AND @IdUser = u.Id
                      )
                      OR( @Approval = 1 --Es para aprobacion
					   and dbo.CheckUserInPersonOfInterestZones(u.IdPersonOfInterest, @IdUser) = 1
					   AND (U.Id <> @IdUser)) --Para que no se pueda aprobar agendas de la propia persona.
					)

				AND ( @UsersIds IS NULL
					  OR dbo.[CheckValueInList](u.Id, @UsersIds) = 1
					)
        ORDER BY wp.StartDate DESC, wp.CreationDate DESC;
    END;
