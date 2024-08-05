/****** Object:  Procedure [dbo].[SyncDocumentInformation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SyncDocumentInformation]
	 @Identifier varchar(100)
	,@Name varchar(100) = NULL
	,@StartDate datetime = NULL
	,@EndDate datetime = NULL
	,@PointIdentifiers varchar(max) = NULL
	,@Type int
	,@Description varchar(100) = NULL
	,@Action int
AS
BEGIN
	
	DECLARE @CreateAction int = 1
	DECLARE @UpdateAction int = 2
	DECLARE @DeleteAction int = 3

	DECLARE @PlanimetryType int = 0
	DECLARE @AgreementType int = 1
	DECLARE @PromotionType int = 2

	DECLARE @DateNow datetime = GETUTCDATE()
	DECLARE @AllPoints bit = (CASE WHEN @PointIdentifiers IS NULL THEN 1 ELSE 0 END)

	IF @Action = @CreateAction
	BEGIN
		
		IF @Type = @PlanimetryType
		BEGIN

			INSERT INTO Planimetry ([Identifier], [Name], [CreatedDate], [AllPointOfInterest],
				[Deleted], [Description], [IdUser])
			SELECT @Identifier, @Name, @DateNow, @AllPoints, 0, @Description, 1
			
			INSERT INTO PlanimetryPointOfInterest ([IdPlanimetry], [IdPointOfInterest], [Date])
			SELECT SCOPE_IDENTITY(), P.[Id], @DateNow
			FROM PointOfInterest P
			WHERE P.[Deleted] = 0 
			  AND (@AllPoints = 1 OR [dbo].CheckVarcharInList (P.[Identifier], @PointIdentifiers) = 1)
		END
		ELSE IF @Type = @AgreementType
		BEGIN

			INSERT INTO Agreement ([Identifier], [Name], [CreatedDate], [AllPointOfInterest],
				[Deleted], [Description], [IdUser], [StartDate], [EndDate])
			SELECT @Identifier, @Name, @DateNow, @AllPoints, 0, @Description, 1, @StartDate, @EndDate

			INSERT INTO AgreementPointOfInterest ([IdAgreement], [IdPointOfInterest], [Date])
			SELECT SCOPE_IDENTITY(), P.[Id], @DateNow
			FROM PointOfInterest P
			WHERE P.[Deleted] = 0 
			  AND (@AllPoints = 1 OR [dbo].CheckVarcharInList (P.[Identifier], @PointIdentifiers) = 1)
		END
		ELSE 
		BEGIN

			INSERT INTO Promotion ([Identifier], [Name], [CreatedDate], [AllPointOfInterest],
				[Deleted], [Description], [IdUser], [StartDate], [EndDate])
			SELECT @Identifier, @Name, @DateNow, @AllPoints, 0, @Description, 1, @StartDate, @EndDate

			INSERT INTO PromotionPointOfInterest ([IdPromotion], [IdPointOfInterest], [Date])
			SELECT SCOPE_IDENTITY(), P.[Id], @DateNow
			FROM PointOfInterest P
			WHERE P.[Deleted] = 0 
			  AND (@AllPoints = 1 OR [dbo].CheckVarcharInList (P.[Identifier], @PointIdentifiers) = 1)
		END

	END 
	ELSE IF @Action = @UpdateAction 
	BEGIN
		
		IF @Type = @PlanimetryType
		BEGIN

			UPDATE Planimetry 
			SET  [Name] = @Name
				,[AllPointOfInterest] = @AllPoints
				,[Deleted] = 0
				,[Description] = @Description
			WHERE [Identifier] = @Identifier

			DELETE FROM PlanimetryPointOfInterest
			WHERE [IdPlanimetry] = SCOPE_IDENTITY()
						
			INSERT INTO PlanimetryPointOfInterest ([IdPlanimetry], [IdPointOfInterest], [Date])
			SELECT SCOPE_IDENTITY(), P.[Id], @DateNow
			FROM PointOfInterest P
			WHERE P.[Deleted] = 0 
			  AND (@AllPoints = 1 OR [dbo].CheckVarcharInList (P.[Identifier], @PointIdentifiers) = 1)
		END
		ELSE IF @Type = @AgreementType
		BEGIN

			UPDATE Agreement 
			SET  [Name] = @Name
				,[AllPointOfInterest] = @AllPoints
				,[Deleted] = 0
				,[Description] = @Description
				,[StartDate] = @StartDate
				,[EndDate] = @EndDate
			WHERE [Identifier] = @Identifier			

			DELETE FROM AgreementPointOfInterest
			WHERE [IdAgreement] = SCOPE_IDENTITY()

			INSERT INTO AgreementPointOfInterest ([IdAgreement], [IdPointOfInterest], [Date])
			SELECT SCOPE_IDENTITY(), P.[Id], @DateNow
			FROM PointOfInterest P
			WHERE P.[Deleted] = 0 
			  AND (@AllPoints = 1 OR [dbo].CheckVarcharInList (P.[Identifier], @PointIdentifiers) = 1)
		END
		ELSE 
		BEGIN

			UPDATE Promotion 
			SET  [Name] = @Name
				,[AllPointOfInterest] = @AllPoints
				,[Deleted] = 0
				,[Description] = @Description
				,[StartDate] = @StartDate
				,[EndDate] = @EndDate
			WHERE [Identifier] = @Identifier

			DELETE FROM PromotionPointOfInterest
			WHERE [IdPromotion] = SCOPE_IDENTITY()

			INSERT INTO PromotionPointOfInterest ([IdPromotion], [IdPointOfInterest], [Date])
			SELECT SCOPE_IDENTITY(), P.[Id], @DateNow
			FROM PointOfInterest P
			WHERE P.[Deleted] = 0 
			  AND (@AllPoints = 1 OR [dbo].CheckVarcharInList (P.[Identifier], @PointIdentifiers) = 1)
		END
	END
	ELSE IF @Action = @DeleteAction
	BEGIN

		IF @Type = @PlanimetryType
		BEGIN

			UPDATE Planimetry 
			SET [Deleted] = 1
			WHERE [Identifier] = @Identifier

			DELETE FROM PlanimetryPointOfInterest
			WHERE [IdPlanimetry] = SCOPE_IDENTITY()
		END
		ELSE IF @Type = @AgreementType
		BEGIN

			UPDATE Agreement 
			SET [Deleted] = 1
			WHERE [Identifier] = @Identifier			

			DELETE FROM AgreementPointOfInterest
			WHERE [IdAgreement] = SCOPE_IDENTITY()
		END
		ELSE 
		BEGIN

			UPDATE Promotion 
			SET [Deleted] = 1
			WHERE [Identifier] = @Identifier

			DELETE FROM PromotionPointOfInterest
			WHERE [IdPromotion] = SCOPE_IDENTITY()
		END
	END
END
