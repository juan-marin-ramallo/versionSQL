/****** Object:  Procedure [dbo].[SaveParameter]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveParameter]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](100)
	,@IdUser [sys].[int]
	,@IdType [sys].[int]
	,@Description [sys].[varchar](500) = NULL
AS
BEGIN

	--Brand Name Duplicated
	IF EXISTS (SELECT 1 FROM [dbo].Parameter 
			   WHERE [Name] = @Name AND [IdType] = @IdType AND [Deleted] = 0) 
		SELECT @Id = -1;
	ELSE
	BEGIN 
		INSERT INTO [dbo].Parameter
				( [Name] ,
				  [CreatedDate] ,
				  [IdUser] ,
				  [Deleted],
				  [IdType],
				  [Description]
				)
		VALUES  ( @Name , -- Name - varchar(50)
				  GETUTCDATE() , -- CreatedDate - datetime
				  @IdUser , -- IdUser - int
				  0,  -- Deleted - bit
				  @IdType, -- IdType - int
				  @Description -- Description - varchar(100)
				)

		SELECT @Id = SCOPE_IDENTITY()
	END

END
