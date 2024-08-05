/****** Object:  Procedure [dbo].[UpdateHierarchyLevel2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/10/2017
-- Description:	SP para actualizar una jerarquia nivel 2
-- =============================================
CREATE PROCEDURE [dbo].[UpdateHierarchyLevel2]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](100)
	,@Identifier [sys].[varchar](100)
	,@IdHierarchyLevel1 [sys].[int] = NULL
)
AS
BEGIN

	--ProductCategory Name Duplicated
	IF EXISTS (SELECT 1 FROM [dbo].[POIHierarchyLevel2] WHERE [Name] = @Name AND Deleted = 0 
				AND @Id <> Id) SELECT -1 AS Id;

	ELSE
	BEGIN 
		IF EXISTS (SELECT 1 FROM [dbo].[POIHierarchyLevel2] WHERE [SapId] = @Identifier 
					AND Deleted = 0 AND @Id <> Id) SELECT -2 AS Id;
		ELSE
		BEGIN
			
			UPDATE	[dbo].[POIHierarchyLevel2]
			SET		[Name] = @Name,
					[SapId] = @Identifier,
					[HierarchyLevel1Id] = @IdHierarchyLevel1	
			WHERE	 [Id] = @Id

			--Actualizo el nivel 1 de los puntos de interes que tienen a este nivel 2
			UPDATE	[dbo].[PointOfInterest]
			SET		[GrandfatherId] = @IdHierarchyLevel1
			WHERE	[FatherId] = @Id

			SELECT @Id as Id;
		END
	END

END
