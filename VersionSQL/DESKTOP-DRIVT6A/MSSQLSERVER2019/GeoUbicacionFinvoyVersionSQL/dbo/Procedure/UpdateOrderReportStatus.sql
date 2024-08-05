/****** Object:  Procedure [dbo].[UpdateOrderReportStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  GL
-- Create date: <Create Date,,>
-- Description: GUARDA PEDIDOS ENVIADOS DESDE LA APP
-- =============================================
CREATE PROCEDURE [dbo].[UpdateOrderReportStatus]
    @Id [sys].[int]
    ,@Status [sys].[smallint]
    ,@OrderDate [sys].[datetime] = null
    ,@IdPersonOfInterest [sys].[int] = null
    ,@Documents OrderStatusDocumentTableType readonly
    ,@IdUser [sys].[int] = null
AS
BEGIN 
    DECLARE @ReceivedDate DATETIME = GETUTCDATE(), @PreviusStatus SMALLINT;
    SELECT @PreviusStatus = [Status] FROM OrderReport WHERE Id = @Id
    UPDATE [dbo].[OrderReport]
    SET [Status] = @Status
    WHERE Id = @Id

    IF EXISTS(SELECT 1 FROM [dbo].[Configuration] WHERE [Description] = 'Seguimiento de Pedidos' AND [Value] = 1)
    BEGIN
        INSERT INTO [dbo].[OrderReportTrazability] ([IdOrderReport], [OrderDateTime], [ReceivedDateTime], [Status], [IdProduct], [ProductName], [ProductPrice], [Quantity], [IsModification], [IdPersonOfInterest], [IdUser])
        SELECT [IdOrderReport], @OrderDate, @ReceivedDate, @Status, [IdProduct], [ProductName], [ProductPrice], [Quantity], 0, @IdPersonOfInterest, @IdUser
        FROM OrderReportTrazability
        WHERE IdOrderReport = @Id AND [Status] = @PreviusStatus

        IF EXISTS(SELECT 1 FROM @Documents)
        BEGIN
            INSERT INTO [dbo].[OrderReportDocumentTrazability] ([IdOrderReport], [IdType], [Status], [Comment], [ImageName], [ImageUrl])
            SELECT @Id, IdType, IdStatus, Comment, ImageName, ImageUrl
            FROM @Documents
        END
    END
END
