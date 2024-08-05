/****** Object:  Procedure [dbo].[GetPersonOfInterestTypesByScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 24/10/2018
-- Description:	SP para obtener LOS PERFILES ASIGNADOS A UN CRONOGEAMA DE ACTIVIDADES
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestTypesByScheduleProfile]
@IdScheduleProfile [sys].[int] = NULL
AS
BEGIN
	SELECT	[Code], [Description]
	FROM	[dbo].[PersonOfInterestType] P
			INNER JOIN [dbo].[ScheduleProfileGeneralAssignation] SPG ON SPG.[IdPersonOfInterestType] = P.[Code]
	WHERE	@IdScheduleProfile IS NULL OR SPG.[IdScheduleProfile] = @IdScheduleProfile
END
