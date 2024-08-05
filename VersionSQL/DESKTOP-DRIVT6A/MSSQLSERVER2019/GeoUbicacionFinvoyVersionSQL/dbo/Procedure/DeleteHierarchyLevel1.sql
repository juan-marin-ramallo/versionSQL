/****** Object:  Procedure [dbo].[DeleteHierarchyLevel1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/05/2017
-- Description:	SP para eliminar una jerarquia nivel 1
-- =============================================
create PROCEDURE [dbo].[DeleteHierarchyLevel1]
(
	 @Id [sys].[int]
)
AS
BEGIN
		UPDATE	[dbo].[POIHierarchyLevel1]		
		SET		[Deleted] = 1 		
		WHERE	[Id] = @Id

		UPDATE	[dbo].[POIHierarchyLevel2]
		SET		[HierarchyLevel1Id] = NULL
		WHERE	[HierarchyLevel1Id] = @Id	

		UPDATE	[dbo].[PointOfInterest]
		SET		[GrandfatherId] = NULL
		WHERE	[GrandfatherId] = @Id	

END
