/****** Object:  Procedure [dbo].[SaveCampaign]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 20/05/2019
-- Description:	SP para guardar una campaña
-- =============================================
CREATE PROCEDURE [dbo].[SaveCampaign]
(
	 @Id [sys].[int] = 0 OUTPUT
	,@StartDate [sys].DATETIME
	,@EndDate [sys].DATETIME
	,@Name [sys].VARCHAR(150)
	,@Description [sys].VARCHAR(MAX) = NULL
	,@Prize [sys].VARCHAR(250) = NULL
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@IdPersonsOfInterest [sys].[varchar](MAX) = NULL
	,@AllPointOfInterest [sys].bit = 0
	,@AllPersonOfInterest [sys].bit = 0
	,@CampaignConquestTypes [dbo].[CampaignConquestTypeTableType] READONLY
)
AS
BEGIN

	--******************************************
	IF NOT EXISTS (SELECT Id FROM [dbo].[Campaign] WHERE [Name] = @Name AND Deleted = 0)
	BEGIN
		INSERT INTO [dbo].Campaign
				( [Name] ,
				  [Description],
				  Prize,
				  [StartDate] ,
				  [EndDate] ,
				  [Deleted],
				  AllPointOfInterest,
				  AllPersonOfInterest,
				  CreatedDate
				)
		VALUES  ( @Name,
				  @Description,
				  @Prize, 
				  @StartDate ,
				  @EndDate ,
				  0,
				  @AllPointOfInterest,
				  @AllPersonOfInterest,
				  GETUTCDATE()
				)
	
		SELECT @Id = SCOPE_IDENTITY()

		INSERT INTO [dbo].[CampaignConquestType]
				   ([IdCampaign]
				   ,[IdConquestType]
				   ,[Weight]
				   ,[Amount])
		SELECT @Id,[IdConquestType],[Weight],[Amount]
		FROM @CampaignConquestTypes


		IF @AllPersonOfInterest = 0 AND @IdPersonsOfInterest IS NOT NULL
		BEGIN
			Insert into dbo.CampaignPersonOfInterest ([IdCampaign], [IdPersonOfInterest])
			(Select @Id as IdCampaign, p.Id
			from dbo.PersonOfInterest p
			WHERE (dbo.CheckValueInList(p.[Id], @IdPersonsOfInterest) = 1))
		end

		IF @AllPointOfInterest = 0 AND @IdPointsOfInterest IS NOT NULL 
		BEGIN
			Insert into dbo.CampaignPointOfInterest ([IdCampaign], [IdPointOfInterest])
			(Select @Id as IdCampaign, p.Id
			from dbo.PointOfInterest p
			WHERE (dbo.CheckValueInList(p.[Id], @IdPointsOfInterest) = 1))
		END
    END
	ELSE
	BEGIN
		SET @Id = -1
    END
END
