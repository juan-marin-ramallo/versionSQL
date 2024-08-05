/****** Object:  Procedure [dbo].[GetGroupedConfigurations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 29/06/2015
-- Description:	SP para obtener todas las configuraciones agrupadas para editar
-- =============================================
CREATE PROCEDURE [dbo].[GetGroupedConfigurations](
	@SuperAdmin [sys].[bit] = 0
)
AS
BEGIN
	SELECT	ISNULL(CGP.[Id], CG.[Id]) [GroupId], ISNULL(CGP.[Name], CG.[Name]) [GroupName], ISNULL(CGP.[Description], CG.[Description]) [GroupDescription], ISNULL(CGP.[Visible], CG.[Visible]) [GroupVisible]
			,CASE	WHEN CGP.[Id] IS NOT NULL THEN CG.[Id]
					ELSE NULL
			END AS [SubgroupId]
			, CASE	WHEN CGP.[Id] IS NOT NULL THEN CG.[Name]
					ELSE NULL
			END AS [SubgroupName]
			, CASE	WHEN CGP.[Id] IS NOT NULL THEN CG.[Description]
					ELSE NULL
			END AS [SubgroupDescription]
			, CASE	WHEN CGP.[Id] IS NOT NULL THEN CG.[Visible]
					ELSE NULL
			END AS [SubgroupVisible]
			, C.[Id], C.[Name], C.[Description], C.[HelpMessage], C.[Value], C.[Type], C.[Visible]
	FROM	[dbo].[ConfigurationTranslated] C WITH (NOLOCK)
			INNER JOIN [dbo].[ConfigurationGroupTranslated] CG WITH (NOLOCK) ON C.[IdConfigurationGroup] = CG.[Id]
			LEFT OUTER JOIN [dbo].[ConfigurationGroupTranslated] CGP WITH (NOLOCK) ON CG.[IdParent] = CGP.[Id]
	WHERE	@SuperAdmin = 1 OR (CG.[Visible] = 1 AND C.[Visible] = 1 AND (CGP.[Id] IS NULL OR CGP.[Visible] = 1))
	ORDER BY CG.[Order], C.[Order]
END
