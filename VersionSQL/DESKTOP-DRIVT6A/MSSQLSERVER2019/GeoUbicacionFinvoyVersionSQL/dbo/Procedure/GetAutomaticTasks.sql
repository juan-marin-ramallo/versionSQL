/****** Object:  Procedure [dbo].[GetAutomaticTasks]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 19/01/2017
-- Description:	SP para obtener los eventos automáticos
-- =============================================
CREATE PROCEDURE [dbo].[GetAutomaticTasks]
AS
BEGIN
	SELECT	T.[Code], T.[Name], T.[TimeValue]
	
	FROM	[dbo].[AutomaticTaskGeneration] T WITH (NOLOCK)
			INNER JOIN [dbo].[ConfigurationTranslated] C WITH (NOLOCK) ON T.[IdConfiguration] = C.[Id]
	
	WHERE	C.[Value] = 1 
END
