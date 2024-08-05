/****** Object:  Procedure [dbo].[GetDynamicReferenceValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 10/11/2023
-- Description:	SP para obtener todas las referencias y sus valores atachados a una combinacion de dinamica, producto y punto de interes
-- Modified date: 21/11/2023
-- Description: Add parameter to include reference values deleted
-- =============================================================================
CREATE PROCEDURE [dbo].[GetDynamicReferenceValue]
(
	 @IdDynamicProductPointOfInterest [int],
	 @IncludeDynamicReferenceValueDeleted [bit] = 0
)
AS
BEGIN
SET NOCOUNT ON

	SELECT	DRV.[Id] AS DynamicReferenceValueId, DR.[Id] AS DynamicReferenceId, DR.[Name] AS DynamicReferenceName, DRV.[Value] AS DynamicReferenceValue,
			DRV.IdDynamicProductPointOfInterest AS DynamicProductPointOfInterestId, DRV.Deleted AS DynamicReferenceValueDeleted 
		FROM [dbo].[DynamicReferenceValue] DRV WITH (NOLOCK)
		INNER JOIN [dbo].[DynamicReference] DR WITH (NOLOCK) ON DR.Id = DRV.IdDynamicReference
		WHERE DRV.IdDynamicProductPointOfInterest = @IdDynamicProductPointOfInterest
		AND		(@IncludeDynamicReferenceValueDeleted = 1 OR DRV.Deleted = 0)
		ORDER BY DR.[Name]
END
