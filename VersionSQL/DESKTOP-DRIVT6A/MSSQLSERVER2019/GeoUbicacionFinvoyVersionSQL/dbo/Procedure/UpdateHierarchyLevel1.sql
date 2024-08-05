/****** Object:  Procedure [dbo].[UpdateHierarchyLevel1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/10/2017
-- Description:	SP para actualizar una jerarquia nivel 1
-- =============================================
CREATE PROCEDURE [dbo].[UpdateHierarchyLevel1]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](100)
	,@Identifier [sys].[varchar](100)
)
AS
BEGIN

	--ProductCategory Name Duplicated
	IF EXISTS (SELECT 1 FROM [dbo].[POIHierarchyLevel1] WHERE [Name] = @Name AND Deleted = 0 
				AND @Id <> Id) SELECT -1 AS Id;

	ELSE
	BEGIN 
		IF EXISTS (SELECT 1 FROM [dbo].[POIHierarchyLevel1] WHERE [SapId] = @Identifier 
					AND Deleted = 0 AND @Id <> Id) SELECT -2 AS Id;
		ELSE
		BEGIN
			
			UPDATE	[dbo].[POIHierarchyLevel1]
			SET		[Name] = @Name,
					[SapId] = @Identifier	
			WHERE	[Id] = @Id

			SELECT @Id as Id;
		END
	END

END
