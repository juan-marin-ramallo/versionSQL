/****** Object:  Procedure [dbo].[SaveShareOfShelf]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para guardar el reporte de Share of Shelf
-- =============================================
CREATE PROCEDURE [dbo].[SaveShareOfShelf]
(
	 @IdPersonOfInterest [INT]
	,@IdPointOfInterest [INT]
	,@Date [DATETIME]
	,@Hierarchies [IdTableType] READONLY
	,@Items [ShareOfShelfItemTableType] READONLY
	,@Images [ImageTableType] READONLY
	,@Id [INT] OUT
)
AS
BEGIN
	DECLARE @IsManual [sys].[bit] = 1
	DECLARE @GrandTotal [DECIMAL](18,2) = (SELECT SUM([Total]) FROM @Items)
	IF @GrandTotal IS NULL BEGIN
		SET @IsManual = 0
		SET @GrandTotal = 0
	END

	INSERT INTO [dbo].[ShareOfShelfReport]
           ([Date]
           ,[IdPointOfInterest]
           ,[IdPersonOfInterest]
		   ,[GrandTotal]
		   ,[IsManual]
		   ,[IsValid]
		   ,[ReceivedDate])
     VALUES
           (@Date
           ,@IdPointOfInterest
           ,@IdPersonOfInterest
		   ,@GrandTotal
		   ,@IsManual
		   ,IIF(@IsManual = 1, 1, NULL)
		   ,GETUTCDATE())
	
	SET @Id = SCOPE_IDENTITY()
	
	INSERT INTO [dbo].[ShareOfShelfProductCategory]
           ([IdShareOfShelf]
           ,[IdProductCategory])
    SELECT  @Id, h.[Id]
	FROM @Hierarchies h
	
	INSERT INTO [dbo].[ShareOfShelfItem]
           ([IdShareOfShelf]
           ,[IdProduct]
           ,[IdProductBrand]
           ,[Total])
    SELECT  @Id, i.[IdProduct], i.[IdProductBrand], i.[Total]
	FROM @Items i

	
	INSERT INTO [dbo].[ShareOfShelfImage]
	(
	    [IdShareOfShelf],
	    [ImageName],
	    [ImageUrl]
	)
    SELECT  @Id, i.[ImageName], NULL
	FROM @Images i

	EXEC [dbo].[SavePointsOfInterestActivity]
				@IdPersonOfInterest = @IdPersonOfInterest
			,@IdPointOfInterest = @IdPointOfInterest
			,@DateIn = @Date
			,@AutomaticValue = 11

END
