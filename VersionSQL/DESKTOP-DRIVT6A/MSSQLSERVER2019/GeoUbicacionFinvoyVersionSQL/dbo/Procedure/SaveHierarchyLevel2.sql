/****** Object:  Procedure [dbo].[SaveHierarchyLevel2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/05/2017
-- Description:	SP para guardar una jerarquia nivel 2
-- =============================================
CREATE PROCEDURE [dbo].[SaveHierarchyLevel2]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](100)
	,@Identifier [sys].[varchar](100)
	,@IdHierarchyLevel1 [sys].[int] = NULL
	,@IdUser [sys].[int]
AS
BEGIN
	
	--[POIHierarchyLevel1] Name Duplicated
	IF EXISTS (SELECT 1 FROM dbo.[POIHierarchyLevel2] WITH (NOLOCK) WHERE [Name] = @Name AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN 
		IF EXISTS (SELECT 1 FROM dbo.[POIHierarchyLevel2] WITH (NOLOCK) WHERE [SapId] = @Identifier AND Deleted = 0) SELECT @Id = -2;
		ELSE
		BEGIN
			INSERT INTO dbo.[POIHierarchyLevel2]
					( [Name] ,
					  [SapId] ,
					  [CreatedDate] ,
					  [IdUser] ,
					  [Deleted],
					  [HierarchyLevel1Id]
					)
			VALUES  ( @Name , -- Name - varchar(100)
					  @Identifier , -- @Identifier - varchar(250)
					  GETUTCDATE() , -- CreatedDate - datetime
					  @IdUser , -- IdUser - int
					  0, -- Deleted - bit
					  @IdHierarchyLevel1
					)

			SELECT @Id = SCOPE_IDENTITY()
		END
	END

END
