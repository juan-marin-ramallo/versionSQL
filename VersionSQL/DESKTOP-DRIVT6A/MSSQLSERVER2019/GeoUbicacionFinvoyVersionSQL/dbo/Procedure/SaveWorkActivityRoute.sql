/****** Object:  Procedure [dbo].[SaveWorkActivityRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[SaveWorkActivityRoute]
    @Id [sys].[INT] ,
    @WPId [sys].[INT] ,
    @POIId [sys].[INT] ,
    @ActDate [sys].[DATETIME]
AS
    BEGIN

	--Brand Name Duplicated
	--IF EXISTS (SELECT 1 FROM [dbo].[Brand] WHERE [Name] = @Name AND [Deleted] = 0) 
	--	SELECT @Id = -1;
	--ELSE
        DECLARE @IdRPOI [sys].[INT];

		DECLARE @GeneratedByPlanText [sys].[varchar](5000)
		SET @GeneratedByPlanText = dbo.GetCommonTextTranslated('GeneratedByPlan')

        BEGIN 
            INSERT  INTO [dbo].[RoutePointOfInterest]
                    ( IdPointOfInterest ,
                      Comment ,
                      RecurrenceCondition ,
                      RecurrenceNumber ,
                      AlternativeRoute ,
                      IdRouteGroup ,
                      Deleted ,
                      EditedDate
				    )
            VALUES  ( @POIId , -- 
                      @GeneratedByPlanText , -- 
                      'D' ,
                      1 , --
                      1 ,  -- 
                      ( SELECT TOP 1
                                wp.IdRouteGroup
                        FROM    dbo.WorkPlan wp
                        WHERE   Id = @WPId
                      ) ,
                      0 ,
                      GETUTCDATE()
                    );

            SELECT  @IdRPOI = SCOPE_IDENTITY();

            UPDATE  dbo.WorkActivity
            SET     RoutePointOfInterestId = @IdRPOI
            WHERE   Id = @Id;

            UPDATE  dbo.WorkActivityPlanned
            SET     RoutePointOfInterestId = @IdRPOI
            WHERE   WorkActivityId = @Id;

            INSERT  INTO [dbo].[RouteDetail]
                    ( RouteDate ,
                      IdRoutePointOfInterest ,
                      [Disabled] ,
                      NoVisited ,
                      NoVisitedApprovedState
				    )
            VALUES  ( @ActDate , -- 
                      @IdRPOI , -- 
                      0 ,
                      0 , --
                      0
				    );

        END;

    END;
