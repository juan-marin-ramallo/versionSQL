/****** Object:  Procedure [dbo].[SaveRouteGroupExcel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 24/10/2016
-- Description:	SP para guardar una ruta agrupada por excel
-- =============================================
CREATE PROCEDURE [dbo].[SaveRouteGroupExcel]
(
	 @Id [sys].[int] = 0 OUTPUT
	,@IsPersonOfInterestDisabled [sys].[bit] OUTPUT
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@RouteName [sys].VARCHAR(50) = NULL
    ,@PersonOfInterestIdentifier [sys].[varchar](20)
)
AS
BEGIN
	DECLARE @IdPersonOfInterest [sys].[INT]
	DECLARE @PersonOfInterestStatus [sys].[char]

	SELECT TOP (1) @IdPersonOfInterest = Id, @PersonOfInterestStatus = [Status] FROM [dbo].[PersonOfInterest] WITH (NOLOCK) WHERE [Identifier] = @PersonOfInterestIdentifier AND [Deleted] = 0

	IF @IdPersonOfInterest IS NOT NULL
	BEGIN
    IF @PersonOfInterestStatus IS NOT NULL AND @PersonOfInterestStatus = 'H'
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
  
  		SET @Id = SCOPE_IDENTITY()
		SET @IsPersonOfInterestDisabled = 0
  		--******************************************
    END
    ELSE
  	BEGIN
  		SET @Id = 0
      SET @IsPersonOfInterestDisabled = 1
  	END
	END
	ELSE
	BEGIN
		SET @Id = 0
    SET @IsPersonOfInterestDisabled = 0
	END
END
