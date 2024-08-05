/****** Object:  Procedure [dbo].[SaveConquestVerification]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================
-- Author:		Fede Sobri
-- Create date: 06/06/2019
-- Description:	SP guardar una nueva verificacion conquista 
-- ==============================================================
CREATE PROCEDURE [dbo].[SaveConquestVerification]
(       
	 @Id [sys].[int] OUTPUT
	,@IdConquest [sys].[int] 
	,@IdPersonOfInterest [sys].[int] = NULL
	,@IdUser [sys].[int] = NULL
	,@Date [sys].[DATETIME]
	,@Description [sys].[varchar](250) = NULL
	,@IsVerified [sys].[bit]  
	,@Images [dbo].[ImageTableType] READONLY
)
AS
BEGIN

	IF EXISTS (SELECT TOP 1 [Id] FROM [dbo].[ConquestVerification] WHERE [IdConquest] = @IdConquest)
	BEGIN
		SET @Id = -1
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[ConquestVerification]
			   ([IdConquest]
			   ,[IdPersonOfInterest]
			   ,[IdUser]
			   ,[Description]
			   ,[Date]
			   ,[IsVerified])
		 VALUES
			   (@IdConquest
			   ,@IdPersonOfInterest
			   ,@IdUser
			   ,@Description
			   ,@Date
			   ,@IsVerified)

		SET @Id = SCOPE_IDENTITY()

		INSERT INTO [dbo].[ConquestVerificationImage] (IdConquestVerification, ImageName)
		SELECT @Id, I.[ImageName]
		FROM @Images I
	END
END 
