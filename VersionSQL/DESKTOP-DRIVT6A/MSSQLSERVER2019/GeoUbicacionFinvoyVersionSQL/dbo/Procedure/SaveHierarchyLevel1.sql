/****** Object:  Procedure [dbo].[SaveHierarchyLevel1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/05/2017
-- Description:	SP para guardar una jerarquia nivel 1
-- =============================================
CREATE PROCEDURE [dbo].[SaveHierarchyLevel1]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](100)
	,@Identifier [sys].[varchar](100)
	,@IdUser [sys].[int]
AS
BEGIN
	
	--[POIHierarchyLevel1] Name Duplicated
	IF EXISTS (SELECT 1 FROM dbo.[POIHierarchyLevel1] WITH (NOLOCK) WHERE [Name] = @Name AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN 
		IF EXISTS (SELECT 1 FROM dbo.[POIHierarchyLevel1] WITH (NOLOCK) WHERE [SapId] = @Identifier AND Deleted = 0) SELECT @Id = -2;
		ELSE
		BEGIN
			INSERT INTO dbo.[POIHierarchyLevel1]
					( [Name] ,
					  [SapId] ,
					  [CreatedDate] ,
					  [IdUser] ,
					  [Deleted]
					)
			VALUES  ( @Name , -- Name - varchar(100)
					  @Identifier , -- @Identifier - varchar(250)
					  GETUTCDATE() , -- CreatedDate - datetime
					  @IdUser , -- IdUser - int
					  0 -- Deleted - bit
					)

			SELECT @Id = SCOPE_IDENTITY()
		END
	END

END
