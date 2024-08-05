/****** Object:  Procedure [dbo].[SaveMarkAuthenticationError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveMarkAuthenticationError]
	@Id [sys].[int] OUTPUT  
    ,@Date DATETIME
    ,@IdPersonOfInterest INT
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
    ,@IdType INT
    ,@MessageError VARCHAR(MAX)
	,@OperationCode NVARCHAR(50) OUTPUT
AS
BEGIN

	DECLARE @LatLong [sys].[geography]
	SET @LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)			
	DECLARE @IdPointOfInterest INT = (SELECT TOP 1 [Id] FROM [dbo].[GetNearPointsOfInterestWithConfRoute](@IdPersonOfInterest, @Latitude, @Longitude))


    INSERT INTO dbo.MarkErrorLog (Date, ReceivedDate, IdPersonOfInterest,IdType,IdPointOfInterest, Latitude, Longitude,  ErrorMessage, OperationCode)
    VALUES (@Date,SYSDATETIME(), @IdPersonOfInterest, @IdType, @IdPointOfInterest, @Latitude, @Longitude, @MessageError, 'PE')

	SELECT @Id = SCOPE_IDENTITY()  
	
	SET @OperationCode = 'PE-' + CAST(@Id AS NVARCHAR(10))

	UPDATE dbo.MarkErrorLog
	SET OperationCode = @OperationCode
	WHERE Id = @Id

END
