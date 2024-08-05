/****** Object:  Procedure [dbo].[UpdatePlanimetry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 15/08/2016
-- Description:	SP para modificar una planimetría
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePlanimetry]
	 
	 @Id [sys].[int]
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@Name [sys].[varchar](50) = NULL
	,@Description [sys].[varchar](1000) = NULL
	,@AllPointOfInterest [sys].bit = NULL
	,@FileName [sys].[varchar](100) = NULL
	,@RealFileName [sys].[varchar](100) = NULL
	,@FileEncoded [sys].[varbinary](MAX) = NULL
	,@IdCategory [sys].[INT] = NULL
	,@IdBrand [sys].[INT] = NULL
	,@IdProvider [sys].[INT] = NULL
	,@MD5Checksum [sys].[VARCHAR](32) = NULL
AS
BEGIN

 	UPDATE		[dbo].[Planimetry]
 	SET			[Name] = @Name, [Description] = @Description, [AllPointOfInterest] = @AllPointOfInterest,
				[IdCategory] = @IdCategory, [IdBrand] = @IdBrand, [IdProvider] = @IdProvider
 	WHERE		[Id] = @Id
	
	--IF @IdPointsOfInterest IS NOT NULL
	--BEGIN 
 --		DELETE FROM [dbo].[PlanimetryPointOfInterest]
 --		WHERE [IdPlanimetry] = @Id AND dbo.CheckValueInList([IdPointOfInterest], @IdPointsOfInterest) = 0
	--END
	--ELSE
 --   BEGIN
		DELETE FROM [dbo].[PlanimetryPointOfInterest]
 		WHERE [IdPlanimetry] = @Id 
	--END


 	INSERT INTO [dbo].[PlanimetryPointOfInterest]([IdPlanimetry], [IdPointOfInterest], [Date])
 	(SELECT @Id AS IdPlanimetry, P.[Id] AS IdPointOfInterest, GETUTCDATE() AS [Date]
 	 FROM	[dbo].[PointOfInterest] P
 	 WHERE	((@AllPointOfInterest = 1 OR dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
 			AND P.[Deleted] = 0 )
			--AND P.[Id] NOT IN ( SELECT PP.[IdPointOfInterest] 
 		--						FROM [dbo].[PlanimetryPointOfInterest] PP 
 		--						WHERE PP.[IdPlanimetry] = @Id))

	IF @FileName IS NOT NULL
	BEGIN
		UPDATE [dbo].[Planimetry]
 		SET [FileName] = @FileName, [FileEncoded] = @FileEncoded, [RealFileName] = @RealFileName, MD5Checksum = @MD5Checksum
 		WHERE [Id] = @Id
	END

END
