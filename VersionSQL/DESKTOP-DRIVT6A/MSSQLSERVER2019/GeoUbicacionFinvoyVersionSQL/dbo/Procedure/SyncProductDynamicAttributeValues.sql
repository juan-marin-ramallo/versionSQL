/****** Object:  Procedure [dbo].[SyncProductDynamicAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 21/04/2023
-- Description:	Optimización del procedimiento
--              dbo.SyncProductDynamicAttributeValue
-- =============================================
CREATE PROCEDURE [dbo].[SyncProductDynamicAttributeValues]
	@Data [ProductDynamicAttributeTableType] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

    UPDATE  P
    SET     P.[Column_1] = D.[Column_1], P.[Column_2] = D.[Column_2], P.[Column_3] = D.[Column_3], P.[Column_4] = D.[Column_4], P.[Column_5] = D.[Column_5],
            P.[Column_6] = D.[Column_6], P.[Column_7] = D.[Column_7], P.[Column_8] = D.[Column_8], P.[Column_9] = D.[Column_9], P.[Column_10] = D.[Column_10],
            P.[Column_11] = D.[Column_11], P.[Column_12] = D.[Column_12], P.[Column_13] = D.[Column_13], P.[Column_14] = D.[Column_14], P.[Column_15] = D.[Column_15],
            P.[Column_16] = D.[Column_16], P.[Column_17] = D.[Column_17], P.[Column_18] = D.[Column_18], P.[Column_19] = D.[Column_19], P.[Column_20] = D.[Column_20],
            P.[Column_21] = D.[Column_21], P.[Column_22] = D.[Column_22], P.[Column_23] = D.[Column_23], P.[Column_24] = D.[Column_24], P.[Column_25] = D.[Column_25]
    FROM    [dbo].[Product] P
            INNER JOIN @Data AS D ON P.[Identifier] = D.[Identifier]
    WHERE   P.[Deleted] = 0
			
	--Actualizo log para que se reflejen los cambios en el celular
	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now

	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], @Now
	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK)
            LEFT JOIN [dbo].[ProductPointOfInterestChangeLog] AS prpoi WITH (NOLOCK) ON prpoi.[IdPointOfInterest] = poi.[Id]
	WHERE	POI.[Deleted] = 0
            AND prpoi.[IdPointOfInterest] IS NULL
END
