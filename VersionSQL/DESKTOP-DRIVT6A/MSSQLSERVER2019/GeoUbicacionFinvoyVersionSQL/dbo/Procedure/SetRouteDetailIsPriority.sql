/****** Object:  Procedure [dbo].[SetRouteDetailIsPriority]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cbarbarini
-- Create date: 21/12/2021
-- Description: Actualiza IsPriority en RouteDetail
-- =============================================
CREATE PROCEDURE [dbo].[SetRouteDetailIsPriority]
	@IdRoutDetail INT
	, @IsPriority BIT
AS
BEGIN
	UPDATE RouteDetail SET IsPriority = @IsPriority WHERE Id = @IdRoutDetail

	SELECT 1
END
