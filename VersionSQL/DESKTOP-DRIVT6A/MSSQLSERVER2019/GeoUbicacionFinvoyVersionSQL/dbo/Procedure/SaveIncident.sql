/****** Object:  Procedure [dbo].[SaveIncident]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 26/07/2016
-- Description:	SP para guardar un incidente
-- Change: Matias Corso - 18/10/17 - Agrego tipo de incidente
-- =============================================
CREATE PROCEDURE [dbo].[SaveIncident]
	@CreatedDate [sys].[DATETIME],
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@IdIncidentType [sys].[int] = NULL,
	@Description [sys].[varchar] (250) = NULL,
	@ImageName [sys].[varchar] (100) = NULL,
	@ImageArray [sys].[image] = NULL,
	@ImageUrl [sys].[varchar] (5000) = NULL,
	@ImageName2 [sys].[varchar] (100) = NULL,
	@ImageArray2 [sys].[image] = NULL,
	@ImageUrl2 [sys].[varchar] (5000) = NULL,
	@ImageName3 [sys].[varchar] (100) = NULL,
	@ImageArray3 [sys].[image] = NULL,
	@ImageUrl3 [sys].[varchar] (5000) = NULL,
	@Id [sys].[int] OUT

AS

BEGIN

	SET @Id = 0 
	
	IF NOT EXISTS ( SELECT 1 
					FROM [dbo].[Incident] I WITH (NOLOCK)
					LEFT JOIN [dbo].[IncidentType] IT WITH (NOLOCK) ON IT.[Id] = I.[IdIncidentType]
					WHERE I.[IdPersonOfInterest] = @IdPersonOfInterest AND
						  I.[IdPointOfInterest] = @IdPointOfInterest AND 
						  (@IdIncidentType IS NULL OR (IT.[Id] = @IdIncidentType)) AND 
						  I.[CreatedDate] = @CreatedDate)
	BEGIN
		INSERT INTO [dbo].[Incident]
			( [Description] ,
			[ImageName] ,
			[ImageEncoded] ,
			[ImageUrl] ,
			[ImageName2] ,
			[ImageEncoded2] ,
			[ImageUrl2] ,
			[ImageName3] ,
			[ImageEncoded3] ,
			[ImageUrl3] ,
			[IdPersonOfInterest] ,
			[IdPointOfInterest] ,
			[CreatedDate],
			[ReceivedDate],
			[IdIncidentType]
				)
		VALUES  ( @Description , -- Description - varchar(250)
			@ImageName ,
			@ImageArray , -- ImageEncoded - varbinary(max)
			@ImageUrl ,
			@ImageName2 ,
			@ImageArray2 , -- ImageEncoded2 - varbinary(max)
			@ImageUrl2 ,
			@ImageName3 ,
			@ImageArray3 , -- ImageEncoded3 - varbinary(max)
			@ImageUrl3 ,
			@IdPersonOfInterest , -- IdPersonOfInterest - int
			@IdPointOfInterest , -- IdPointOfInterest - int
			@CreatedDate,  -- CreatedDate - datetime
			GETUTCDATE(),
			@IdIncidentType -- IdIncidentType - int
			)

		SET @Id = SCOPE_IDENTITY() 
		
		EXEC [dbo].[SavePointsOfInterestActivity]
				@IdPersonOfInterest = @IdPersonOfInterest
				,@IdPointOfInterest = @IdPointOfInterest
				,@DateIn = @CreatedDate
				,@AutomaticValue = 6

	END

END
