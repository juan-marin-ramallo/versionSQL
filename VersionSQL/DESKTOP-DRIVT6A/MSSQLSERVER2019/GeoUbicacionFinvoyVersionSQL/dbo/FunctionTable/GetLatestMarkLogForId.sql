/****** Object:  TableFunction [dbo].[GetLatestMarkLogForId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[GetLatestMarkLogForId] (@Id INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP 1 *
    FROM dbo.MarkLog ML
    WHERE ML.IdEntry = @Id
    ORDER BY ML.Id DESC
)

--use [GeoUbicacionGU144]
