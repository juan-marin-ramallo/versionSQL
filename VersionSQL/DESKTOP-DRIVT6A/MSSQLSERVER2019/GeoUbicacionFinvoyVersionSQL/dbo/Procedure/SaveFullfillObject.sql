/****** Object:  Procedure [dbo].[SaveFullfillObject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 23/05/2017
-- Description:	SP para guardar un reporte de planimetria/promociones o contratos
-- =============================================
CREATE PROCEDURE [dbo].[SaveFullfillObject]
	@CreatedDate [sys].[DATETIME],
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@IdDocument [sys].[int],
	@TypeDocument [sys].[int], --0 Es planimetria, 1 contratos y 2 promociones
	@ImageName [sys].[varchar] (100) = NULL,
	@ImageArray [sys].[image] = NULL,
	@ImageUrl [sys].[varchar] (5000) = NULL,
	@ImageName2 [sys].[varchar] (100) = NULL,
	@ImageArray2 [sys].[image] = NULL,
	@ImageUrl2 [sys].[varchar] (5000) = NULL,
	@ImageName3 [sys].[varchar] (100) = NULL,
	@ImageArray3 [sys].[image] = NULL,
	@ImageUrl3 [sys].[varchar] (5000) = NULL,
	@IsFullfilled [sys].[bit],
	@Id [sys].[int] OUT

AS

BEGIN

	SET @Id = 0 
	
	INSERT INTO [dbo].[DocumentReport]
        ([IdDocument]
		,[DocumentType]
        ,[IdPointOfInterest]
        ,[IdPersonOfInterest]
        ,[Date]
        ,[ImageName]
		,[ImageEncoded]
        ,[ImageUrl]
        ,[ImageName2]
		,[ImageEncoded2]
        ,[ImageUrl2]
        ,[ImageName3]
		,[ImageEncoded3]
        ,[ImageUrl3]
        ,[ReceivedDate]
        ,[IsFullfilled])
	VALUES
        (@IdDocument
		,@TypeDocument
        ,@IdPointOfInterest
        ,@IdPersonOfInterest
        ,@CreatedDate
        ,@ImageName
        ,@ImageArray
        ,@ImageUrl
        ,@ImageName2
        ,@ImageArray2
        ,@ImageUrl2
        ,@ImageName3
        ,@ImageArray3
        ,@ImageUrl3
        ,GETUTCDATE()
        ,@IsFullfilled)

	SET @Id = SCOPE_IDENTITY()

	EXEC [dbo].[SavePointsOfInterestActivity]
			@IdPersonOfInterest = @IdPersonOfInterest
			,@IdPointOfInterest = @IdPointOfInterest
			,@DateIn = @CreatedDate
			,@AutomaticValue = 8

END
