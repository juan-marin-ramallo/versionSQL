/****** Object:  Procedure [dbo].[SaveRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 23/08/2015
-- Description:	SP para guardar una ruta agrupada
-- =============================================
CREATE PROCEDURE [dbo].[SaveRouteGroup]
(
	 @Id [sys].[int] = 0 OUTPUT
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@RouteName [sys].VARCHAR(50) = NULL
    ,@IdPersonOfInterest [sys].[INT] = NULL
)
AS
BEGIN

	--******************************************

	INSERT INTO [dbo].[RouteGroup]
	        ( [IdPersonOfInterest] ,
	          [StartDate] ,
	          [EndDate] ,
	          [Name] ,
	          [EditedDate],
			  [Deleted]
	        )
	VALUES  ( @IdPersonOfInterest, 
	          @StartDate ,
	          @EndDate , 
	          @RouteName ,
	          GETUTCDATE(),
			  0
	        )
	
	SELECT @Id = SCOPE_IDENTITY()
	
END
