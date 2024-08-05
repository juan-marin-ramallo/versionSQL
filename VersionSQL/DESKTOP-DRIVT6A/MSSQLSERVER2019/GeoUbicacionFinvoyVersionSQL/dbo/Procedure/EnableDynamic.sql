/****** Object:  Procedure [dbo].[EnableDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Juan Marin Ramallo
-- Create date: 12/11/2023
-- Description:	Activa una dinamica
-- =============================================
CREATE PROCEDURE [dbo].[EnableDynamic]
	@Id int
AS
BEGIN
	
		UPDATE	[dbo].[Dynamic]
		SET		[Disabled] = 0
		WHERE	[Id] = @Id
END
