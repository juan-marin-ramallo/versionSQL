/****** Object:  Procedure [dbo].[SavePlanimetry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston L.
-- Create date: 15/08/2016
-- Description:	SP para guardar una planimetria
-- =============================================
CREATE PROCEDURE [dbo].[SavePlanimetry]
 
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT]
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
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @IdAux  AS INT

	INSERT INTO dbo.Planimetry([Name],[Description],[FileName],[FileEncoded],[CreatedDate],[Deleted],[IdUser], [AllPointOfInterest], [RealFileName], [IdCategory], [IdBrand], [IdProvider], MD5Checksum)
	VALUES  ( @Name, @Description ,@FileName, @FileEncoded, @Now ,0 , @IdUser, @AllPointOfInterest, @RealFileName, @IdCategory, @IdBrand, @IdProvider, @MD5Checksum)
	
	SELECT @Id = SCOPE_IDENTITY()
	
	INSERT INTO [dbo].[PlanimetryPointOfInterest]([IdPlanimetry], [IdPointOfInterest], [Date])
	(	SELECT	@Id AS IdPlanimetry, P.[Id] AS [IdPointOfInterest], @Now AS [Date]
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE	P.[Deleted] = 0 AND (@AllPointOfInterest = 1 OR dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
	
END
