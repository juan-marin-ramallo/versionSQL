/****** Object:  Procedure [dbo].[UpdateAgreement]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/08/2016
-- Description:	SP para modificar un contrato o acuerdo comercial
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAgreement]
	 
	 @Id [sys].[int]
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@Name [sys].[varchar](50) = NULL
	,@Description [sys].[varchar](1000) = NULL
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@AllPointOfInterest [sys].bit = NULL
	,@FileName [sys].[varchar](100) = NULL
	,@FileType [sys].[varchar](50) = NULL
	,@RealFileName [sys].[varchar](100) = NULL
	,@FileEncoded [sys].[varbinary](MAX) = NULL
	,@MD5Checksum [sys].[VARCHAR](32) = NULL
AS
BEGIN

 	UPDATE [dbo].[Agreement]
 	SET [StartDate] = @StartDate, [EndDate] = @EndDate, [Name] = @Name, [Description] = @Description, [AllPointOfInterest] = @AllPointOfInterest
 	WHERE [Id] = @Id
	
	--IF @IdPointsOfInterest IS NOT NULL
	--BEGIN 
 --		DELETE FROM [dbo].[AgreementPointOfInterest]
 --		WHERE [IdAgreement] = @Id AND dbo.CheckValueInList([IdPointOfInterest], @IdPointsOfInterest) = 0
	--END
	--ELSE
 --   BEGIN
		DELETE FROM [dbo].[AgreementPointOfInterest]
 		WHERE [IdAgreement] = @Id 
	--END


 	INSERT INTO [dbo].[AgreementPointOfInterest]([IdAgreement], [IdPointOfInterest], [Date])
 	(SELECT @Id AS IdAgreement, P.[Id] AS IdPointOfInterest, GETUTCDATE() AS [Date]
 	 FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
 	 WHERE	((@AllPointOfInterest = 1 OR dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
 			AND P.[Deleted] = 0)
			--AND P.[Id] NOT IN ( SELECT PP.[IdPointOfInterest] 
 		--						FROM [dbo].[AgreementPointOfInterest] PP WITH (NOLOCK)
 		--						WHERE PP.[IdAgreement] = @Id))

	IF @FileName IS NOT NULL
	BEGIN
		UPDATE [dbo].[Agreement]
 		SET [FileName] = @FileName, [FileEncoded] = @FileEncoded, [RealFileName] = @RealFileName, [FileType] = @FileType, MD5Checksum = @MD5Checksum
 		WHERE [Id] = @Id
	END

END
