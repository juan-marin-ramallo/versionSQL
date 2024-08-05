/****** Object:  Procedure [dbo].[UpdateCampaign]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 27/05/2019
-- Description:	SP para actualizar una campaña
-- TODO: Se puede agregar un flag para controlar si fue modificada la asignacion de personas
--       o puntos para hacer el delete y add de nuevo solo cuando es necesario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCampaign]
	 
	 @Id [sys].[int]
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
	,@ResultCode [sys].[int] OUTPUT
AS
BEGIN

	IF NOT EXISTS (SELECT Id FROM [dbo].[Campaign] WHERE [Name] = @Name AND Deleted = 0 AND Id <> @Id)
	BEGIN
		BEGIN TRANSACTION;
		SAVE TRANSACTION UpdateCampaignCompleted;
		BEGIN TRY
			UPDATE [dbo].Campaign
			SET [StartDate] = @StartDate
				, [Name] = @Name
				, [EndDate] = @EndDate
				, [AllPointOfInterest] = @AllPointOfInterest
				, [AllPersonOfInterest] = @AllPersonOfInterest
				, [Description] = @Description
				, [Prize] = @Prize		
			WHERE [Id] = @Id
	
			DELETE [dbo].CampaignPersonOfInterest
			WHERE IdCampaign = @Id
				AND (@AllPersonOfInterest = 1
					OR @IdPersonsOfInterest IS NULL 
					OR dbo.CheckValueInList([IdPersonOfInterest], @IdPersonsOfInterest) = 0)

			IF @AllPersonOfInterest = 0 AND @IdPersonsOfInterest IS NOT NULL
			BEGIN
				Insert into dbo.CampaignPersonOfInterest ([IdCampaign], [IdPersonOfInterest])
				(Select @Id as IdCampaign, P.Id
				from dbo.PersonOfInterest P
					LEFT OUTER JOIN dbo.CampaignPersonOfInterest PC ON PC.IdCampaign = @Id AND P.Id = PC.IdPersonOfInterest
				WHERE PC.IdPersonOfInterest IS NULL
						AND dbo.CheckValueInList(p.[Id], @IdPersonsOfInterest) = 1)
			END
		
			DELETE [dbo].CampaignPointOfInterest 
			WHERE IdCampaign = @Id
				AND (@AllPointOfInterest = 1
					OR @IdPointsOfInterest IS NULL 
					OR dbo.CheckValueInList([IdPointOfInterest], @IdPointsOfInterest) = 0)

			IF @AllPointOfInterest = 0 AND @IdPointsOfInterest IS NOT NULL
			BEGIN
				Insert into dbo.CampaignPointOfInterest ([IdCampaign], [IdPointOfInterest])
				(Select @Id as IdCampaign, p.Id
				from dbo.PointOfInterest p
					LEFT OUTER JOIN dbo.CampaignPointOfInterest PC ON PC.IdCampaign = @Id AND P.Id = PC.IdPointOfInterest
				WHERE PC.IdPointOfInterest IS NULL
					AND dbo.CheckValueInList(p.[Id], @IdPointsOfInterest) = 1)
			END
        
			DELETE CT 
			FROM [dbo].[CampaignConquestType] CT
				LEFT OUTER JOIN @CampaignConquestTypes C ON CT.Id = C.Id
			WHERE CT.IdCampaign = @Id AND C.[Id] IS NULL

			UPDATE CT
			SET  CT.[IdConquestType] = C.[IdConquestType]
				,CT.[Weight] = C.[Weight]
				,CT.[Amount] = C.[Amount]
			FROM [dbo].[CampaignConquestType] CT
				INNER JOIN @CampaignConquestTypes C ON C.Id = CT.Id 
			WHERE CT.IdCampaign = @Id
		
			INSERT INTO [dbo].[CampaignConquestType]
				([IdCampaign]
				,[IdConquestType]
				,[Weight]
				,[Amount])
			SELECT @Id,[IdConquestType],[Weight],[Amount]
			FROM @CampaignConquestTypes
			WHERE [Id] = 0

			SET @ResultCode = 0

		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
			BEGIN
				SET @ResultCode = -2
				ROLLBACK TRANSACTION UpdateCampaignCompleted; -- rollback to UpdateCampaignCompleted
			END
		END CATCH
		COMMIT TRANSACTION 
	END
	ELSE
	BEGIN
		SET @ResultCode = -1
    END
END
