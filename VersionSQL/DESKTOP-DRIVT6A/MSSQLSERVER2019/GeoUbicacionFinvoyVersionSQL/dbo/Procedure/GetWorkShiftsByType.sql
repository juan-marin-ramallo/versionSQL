/****** Object:  Procedure [dbo].[GetWorkShiftsByType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/08/2023
-- Description:	SP para obtener los turnos de
--              trabajo disponibles, dados por
--              el parámetro @IdType
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkShiftsByType]
	 @IdType [sys].[int]
	,@IncludeDeleted [sys].[bit] = 0
AS
BEGIN
    SELECT  [Id], [Name], [StartTime], [EndTime]
    FROM    [dbo].[WorkShift] WITH (NOLOCK)
	WHERE	[IdType] = @IdType
			AND (@IncludeDeleted = 1 OR [Deleted] = 0)
END
