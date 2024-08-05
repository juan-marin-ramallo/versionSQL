/****** Object:  Procedure [dbo].[CreateWorkPlanRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 05/09/2017
-- Description:	SP para crear el routegroup del plan
-- =============================================
CREATE PROCEDURE [dbo].[CreateWorkPlanRouteGroup]
    @Id [sys].[INT],
	 @IdPerson [sys].[INT]
AS
    BEGIN
	declare @IdRoute [sys].[INT]

	DECLARE @PlanText [sys].[varchar](5000)
	SET @PlanText = dbo.GetCommonTextTranslated('Plan')

	Insert into dbo.RouteGroup
				( Name,
				IdPersonOfInterest,
				StartDate,
				EndDate,
				EditedDate,
				Deleted
				)
				select CONCAT(@PlanText, ': ', CONVERT(varchar, Tzdb.FromUtc(wp.StartDate), 3), ' - ' , CONVERT(varchar,Tzdb.FromUtc(wp.EndDate),3),  p.Name + ' ' + p.LastName) as Name
				, @IdPerson
				,wp.StartDate
				,wp.EndDate
				,GETUTCDATE()
				,0
				from dbo.WorkPlan wp
				inner join dbo.PersonOfInterest p on p.Id = @IdPerson
				where wp.Id = @Id

				SELECT @IdRoute = SCOPE_IDENTITY()
        BEGIN 
            UPDATE  [dbo].WorkPlan
            SET     IdRouteGroup = @IdRoute 
            WHERE   Id = @Id;
        END;

       
    END;
