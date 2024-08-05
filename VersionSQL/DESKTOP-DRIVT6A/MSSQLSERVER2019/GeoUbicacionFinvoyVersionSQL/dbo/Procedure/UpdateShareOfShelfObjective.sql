/****** Object:  Procedure [dbo].[UpdateShareOfShelfObjective]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para guardar el reporte de Share of Shelf
-- =============================================
CREATE PROCEDURE [dbo].[UpdateShareOfShelfObjective]
(
	 @IdShareOfShelfObjective [sys].[int]
	,@IdProductCategory [sys].[int]
	,@IdZone [sys].[int] = NULL
	,@IdPOIHierarchyLevel1 [sys].[int] = NULL
	,@IdPOIHierarchyLevel2 [sys].[int] = NULL
	,@Items [ShareOfShelfItemTableType] READONLY
	,@Id [INT] OUT
	,@ResultCode [smallint] out
)
AS
BEGIN
	SET @ResultCode = 1

	IF NOT EXISTS (SELECT TOP 1 Id FROM dbo.ShareOfShelfObjective WHERE Id != @IdShareOfShelfObjective AND IdProductCategory = @IdProductCategory AND Deleted = 0 AND 
					((IdZone IS NULL AND @IdZone IS NULL) OR IdZone = @IdZone) AND
					((IdPOIHierarchyLevel1 IS NULL AND @IdPOIHierarchyLevel1 IS NULL) OR IdPOIHierarchyLevel1 = @IdPOIHierarchyLevel1) AND
					((IdPOIHierarchyLevel2 IS NULL AND @IdPOIHierarchyLevel2 IS NULL) OR IdPOIHierarchyLevel2 = @IdPOIHierarchyLevel2)) 

	BEGIN
		UPDATE [dbo].[ShareOfShelfObjective]
		SET [Deleted] = 1
		WHERE Id = @IdShareOfShelfObjective

		INSERT INTO [dbo].[ShareOfShelfObjective]
			   ([IdProductCategory]
			   ,[IdZone]
			   ,[IdPOIHierarchyLevel1]
			   ,[IdPOIHierarchyLevel2]
			   ,[StartDate]
			   ,[EndDate]
			   ,[Deleted])
		 VALUES
			   (@IdProductCategory
			   ,@IdZone
			   ,@IdPOIHierarchyLevel1
			   ,@IdPOIHierarchyLevel2
			   ,GETUTCDATE()
			   ,null
			   ,0)
	
		SET @Id = SCOPE_IDENTITY()
	
		INSERT INTO [dbo].[ShareOfShelfObjectiveItem]
			   ([IdShareOfShelfObjective]
			   ,[IdProductBrand]
			   ,[Value])
		SELECT  @Id, i.[IdProductBrand], i.[Total]
		FROM @Items i

		SET @ResultCode = 0
	END
END
