/****** Object:  Procedure [dbo].[SaveConquestImage]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================
-- Author:		Fede Sobri
-- Create date: 06/06/2019
-- Description:	SP obtener id de imagen 
-- ==============================================================
CREATE PROCEDURE [dbo].[SaveConquestImage]
(     @Id [sys].[int]   
	 ,@ImageUrl [sys].[varchar](512)
)
AS
BEGIN

	UPDATE [dbo].[ConquestImage]
	SET [ImageUrl] = @ImageUrl
	WHERE [Id] = @Id

END 
