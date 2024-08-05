/****** Object:  Procedure [dbo].[UpdateParameter]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[UpdateParameter]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](100)
	,@IdType [sys].[int]
	,@Description [sys].[varchar](500) = NULL
)
AS
BEGIN

		--Brand Name Duplicated
		IF EXISTS (SELECT 1 FROM [dbo].Parameter WHERE [Name] = @Name AND [Deleted] = 0 AND @Id <> [Id]) 
			SELECT -1 AS Id;
		ELSE
		BEGIN 
			UPDATE	[dbo].Parameter		
			SET		[Name] = @Name,
					[IdType] = @IdType	,
					[Description] = @Description
			WHERE	[Id] = @Id

			SELECT @Id as Id;
		END

END
