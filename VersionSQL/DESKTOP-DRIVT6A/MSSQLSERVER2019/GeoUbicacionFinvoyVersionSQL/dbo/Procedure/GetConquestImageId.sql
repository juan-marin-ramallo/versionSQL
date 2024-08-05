/****** Object:  Procedure [dbo].[GetConquestImageId]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================
-- Author:		Fede Sobri
-- Create date: 06/06/2019
-- Description:	SP obtener id de imagen 
-- ==============================================================
CREATE PROCEDURE [dbo].[GetConquestImageId]
(       
	 @ImageUniqueName [sys].[varchar](256)
)
AS
BEGIN

	SELECT [Id]
	FROM [dbo].[ConquestImage]
	WHERE [ImageName] = @ImageUniqueName 

END 
