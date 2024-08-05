/****** Object:  ScalarFunction [dbo].[DashboardPersonsOfInterestWithNoRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 24/10/2019
-- Description:	FC para obtener las Personas de Interes que no llevaron adelante ninguna actividad en el correr del dìa
-- =============================================
CREATE FUNCTION [dbo].[DashboardPersonsOfInterestWithNoRoute]
(
	@IdUser [sys].[int]
	,@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
)
returns [sys].numeric
AS
BEGIN

	DECLARE @Result [sys].numeric
		SET @Result = (

	SELECT	Count(Distinct P.[Id])
	FROM	[dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
			
	WHERE	((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) 
			AND (P.[Id] not in 
			(
				Select Distinct RG.[IdPersonOfInterest]
				from dbo.RouteDetail RD
				INNER JOIN [dbo].[RoutePointOfInterest] RP with(nolock) ON RP.Id = RD.IdRoutePointOfInterest
				Inner join dbo.RouteGroup RG  with(nolock) ON RP.IdRouteGroup = RG.Id
				WHERE RD.[RouteDate] BETWEEN @DateFrom AND @DateTo 
				AND RD.[Disabled] = 0
			)

			)

			)

			return @Result
END
