/****** Object:  Procedure [dbo].[SavePromotion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston L.
-- Create date: 27/07/2016
-- Description:	SP para guardar una promoción comercial
-- =============================================
CREATE PROCEDURE [dbo].[SavePromotion]
 
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT]
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@Description [sys].[varchar](1000) = NULL
	,@AllPointOfInterest [sys].bit = NULL
	,@FileName [sys].[varchar](100) = NULL
	,@RealFileName [sys].[varchar](100) = NULL
	,@FileEncoded [sys].[varbinary](MAX) = NULL
	,@MD5Checksum [sys].[VARCHAR](32) = NULL
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @IdAux  AS INT

	INSERT INTO dbo.Promotion([Name], [StartDate],[EndDate],[Description],[FileName],[FileEncoded],[CreatedDate],[Deleted],[IdUser], [AllPointOfInterest], [RealFileName], MD5Checksum)
	VALUES  ( @Name, @StartDate, @EndDate, @Description ,@FileName, @FileEncoded, @Now ,0 , @IdUser, @AllPointOfInterest, @RealFileName, @MD5Checksum)
	
	SELECT @Id = SCOPE_IDENTITY()
	
	INSERT INTO [dbo].[PromotionPointOfInterest]([IdPromotion], [IdPointOfInterest], [Date])
	(	SELECT	@Id AS IdPromotion, P.[Id] AS [IdPointOfInterest], @Now AS [Date]
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE	P.[Deleted] = 0 AND (@AllPointOfInterest = 1 OR dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
	
END
