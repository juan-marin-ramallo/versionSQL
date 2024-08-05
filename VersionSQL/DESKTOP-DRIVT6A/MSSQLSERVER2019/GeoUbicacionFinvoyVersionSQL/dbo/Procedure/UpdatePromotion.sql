/****** Object:  Procedure [dbo].[UpdatePromotion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/07/2016
-- Description:	SP para modificar una promocion comercial
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePromotion]
	 
	 @Id [sys].[int]
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@Name [sys].[varchar](50) = NULL
	,@Description [sys].[varchar](1000) = NULL
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@AllPointOfInterest [sys].bit = NULL
	,@FileName [sys].[varchar](100) = NULL
	,@RealFileName [sys].[varchar](100) = NULL
	,@FileEncoded [sys].[varbinary](MAX) = NULL
	,@MD5Checksum [sys].[VARCHAR](32) = NULL
AS
BEGIN

 	UPDATE [dbo].[Promotion]
 	SET [StartDate] = @StartDate, [EndDate] = @EndDate, [Name] = @Name, [Description] = @Description, [AllPointOfInterest] = @AllPointOfInterest
 	WHERE [Id] = @Id

	--IF @IdPointsOfInterest IS NOT NULL
	--BEGIN 
 --		DELETE FROM [dbo].[PromotionPointOfInterest]
 --		WHERE [IdPromotion] = @Id AND dbo.CheckValueInList([IdPointOfInterest], @IdPointsOfInterest) = 0
	--END
	--ELSE
 --   BEGIN
		DELETE FROM [dbo].[PromotionPointOfInterest]
 		WHERE [IdPromotion] = @Id 
	--END


 	INSERT INTO [dbo].[PromotionPointOfInterest]([IdPromotion], [IdPointOfInterest], [Date])
 	(SELECT @Id AS IdPromotion, P.[Id] AS IdPointOfInterest, GETUTCDATE() AS [Date]
 	 FROM	[dbo].[PointOfInterest] P
 	 WHERE	((@AllPointOfInterest = 1 OR dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
 			AND P.[Deleted] = 0)
			--AND P.[Id] NOT IN ( SELECT PP.[IdPointOfInterest] 
 		--						FROM [dbo].[PromotionPointOfInterest] PP 
 		--						WHERE PP.[IdPromotion] = @Id))

	IF @FileName IS NOT NULL
	BEGIN
		UPDATE [dbo].[Promotion]
 		SET [FileName] = @FileName, [FileEncoded] = @FileEncoded, [RealFileName] = @RealFileName, MD5Checksum = @MD5Checksum
 		WHERE [Id] = @Id
	END


END
