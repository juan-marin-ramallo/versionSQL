/****** Object:  Procedure [dbo].[UpdateShareOfShelf]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 14/06/21
-- Description:	SP para actualizar el reporte de Share of Shelf
-- =============================================
CREATE PROCEDURE [dbo].[UpdateShareOfShelf]
(
	 @Id [INT] 
	,@IsValid [sys].[bit]
	,@ValidationDate [sys].[datetime]
	,@ValidationImage [sys].[varchar](512) = NULL
	,@ValidationDescription [sys].[varchar](8000) = NULL
	,@DiscardReason [sys].[varchar](2000) = NULL
	,@Items [ShareOfShelfItemProductBrandTableType] READONLY
    ,@ItemsCoordinates [ShareOfShelfItemProductBrandCoordinatesTableType] READONLY
    ,@EmptySpaces [ShareOfShelfEmptySpaceTableType] READONLY
)
AS
BEGIN
    IF EXISTS (SELECT TOP 1 Id FROM dbo.ShareOfShelfReport WHERE Id = @Id AND [IsManual] = 0) --AND [ValidationReceivedDate] IS NULL)
		--AND NOT EXISTS (SELECT TOP 1 Id FROM dbo.ShareOfShelfItem WHERE [IdShareOfShelf] = @Id)
	BEGIN
		DELETE FROM [dbo].[ShareOfShelfEmptySpace] WHERE [IdShareOfShelf] = @Id

		DELETE	SOSIC
		FROM	[dbo].[ShareOfShelfItemCoordinates] SOSIC
				INNER JOIN [dbo].[ShareOfShelfItem] SOSI ON SOSI.[IdShareOfShelf] = @Id AND SOSI.[Id] = SOSIC.[IdShareOfShelfItem]

		DELETE FROM [dbo].[ShareOfShelfItem] WHERE [IdShareOfShelf] = @Id
	END

    IF @IsValid = 0
    BEGIN
        UPDATE [dbo].[ShareOfShelfReport]
        SET  [IsManual] = 0
            ,[IsValid] = @IsValid
            ,[ValidationDate] = @ValidationDate
            ,[ValidationImage] = @ValidationImage
            ,[ValidationDescription] = @ValidationDescription
            ,[DiscardReason] = @DiscardReason
            ,[ValidationReceivedDate] = GETUTCDATE()
            ,[GrandTotal] = 0
        WHERE Id = @Id
    END
    ELSE
    BEGIN
        DECLARE @InsertedItem TABLE
        (
            [Id] [sys].[int],
            [IdProductBrand] [sys].[int]
        )
            
        DECLARE @GrandTotal [DECIMAL](18,2) = (SELECT SUM([Total]) FROM @Items)
        IF @GrandTotal IS NULL BEGIN
            SET @GrandTotal = 0
        END

        UPDATE [dbo].[ShareOfShelfReport]
        SET  [IsValid] = @IsValid
            ,[ValidationDate] = @ValidationDate
            ,[ValidationImage] = @ValidationImage
            ,[ValidationDescription] = @ValidationDescription
            ,[DiscardReason] = NULL
            ,[ValidationReceivedDate] = GETUTCDATE()
            ,[GrandTotal] = @GrandTotal
        WHERE Id = @Id
        
        INSERT INTO [dbo].[ShareOfShelfItem]
            ([IdShareOfShelf]
            ,[IdProductBrand]
            ,[Total])
        OUTPUT  INSERTED.Id, INSERTED.IdProductBrand
        INTO    @InsertedItem
        SELECT  @Id, I.[IdProductBrand], I.[Total]
        FROM    @Items I

        INSERT INTO [dbo].[ShareOfShelfItemCoordinates]
            ([IdShareOfShelfItem]
            ,[X0]
            ,[Y0]
            ,[X1]
            ,[Y1])
        SELECT  I.[Id], IC.[X0], IC.[Y0], IC.[X1], IC.[Y1]
        FROM    @ItemsCoordinates IC
                INNER JOIN @InsertedItem I ON I.[IdProductBrand] = IC.[IdProductBrand]

        IF EXISTS (SELECT TOP(1) 1 FROM @EmptySpaces)
        BEGIN
            INSERT INTO [dbo].[ShareOfShelfEmptySpace]
                ([IdShareOfShelf]
                ,[X0]
                ,[Y0]
                ,[X1]
                ,[Y1])
            SELECT  @Id, [X0], [Y0], [X1], [Y1]
            FROM    @EmptySpaces
        END
    END
END
