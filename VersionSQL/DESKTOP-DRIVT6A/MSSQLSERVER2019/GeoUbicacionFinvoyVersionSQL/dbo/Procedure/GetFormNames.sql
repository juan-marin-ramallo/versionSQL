/****** Object:  Procedure [dbo].[GetFormNames]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 22/01/2014
-- Description:	SP para obtener los nombres de los formularios y su id
-- =============================================

CREATE PROCEDURE [dbo].[GetFormNames]
	@IdUser [sys].[int] = NULL,
	@OnlyCompleted [sys].[bit] = NULL
AS
BEGIN
	SELECT	F.[Name]
			,F.[Id]
			,F.[NonPointOfInterest]
			,CASE WHEN Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], GETUTCDATE()) = 1 AND F.[Deleted] = 0 then 1 else 0 end as ActiveForm		
			,F.IsFormPlus AS IsFormPlus
	FROM	[dbo].[Form] F
	WHERE	(@OnlyCompleted IS NULL OR Exists (SELECT 1 from [dbo].[CompletedForm] WHERE [IdForm] = F.[Id]))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1))
	ORDER BY ActiveForm desc, F.[Name] asc
END
