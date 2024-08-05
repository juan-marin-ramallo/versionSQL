/****** Object:  Procedure [dbo].[GetTemporaryLicensesReportDetailed]    Committed by VersionSQL https://www.versionsql.com ******/

-- ===================================================
-- Author:  Cristian Barbarini
-- Create date: 29/09/2022
-- Description: SP para obtener licencias temporales
-- ===================================================
CREATE PROCEDURE [dbo].[GetTemporaryLicensesReportDetailed]
(
	@DateFrom DATETIME
	, @DateTo DATETIME
	, @IdUser INT = NULL
	, @IdPersonOfInterest VARCHAR(MAX) = NULL
	, @IdPersonOfInterestZone VARCHAR(MAX) = NULL
) AS
BEGIN
	WITH TemporalData
	AS
	(
		SELECT poia.IdPersonOfInterest, CAST(tzdb.FromUtc(poia.DateIn) AS DATE) AS DateIn, CAST(tzdb.FromUtc(poia.DateOut) AS DATE) AS DateOut
		FROM PointOfInterestActivity poia WITH (NOLOCK)
		LEFT OUTER JOIN PersonOfInterestZone poiz WITH (NOLOCK) ON poiz.IdPersonOfInterest = poia.IdPersonOfInterest
		WHERE (poia.DateIn BETWEEN @DateFrom AND @DateTo
			OR poia.DateOut BETWEEN @DateFrom AND @DateTo)
		AND (poia.IdPointOfInterestManualVisited IS NOT NULL
			OR poia.ActionValue IS NOT NULL)
		UNION
		SELECT cf.IdPersonOfInterest, CAST(tzdb.FromUtc(cf.Date) AS DATE) AS DateIn, CAST(tzdb.FromUtc(cf.Date) AS DATE) AS DateOut
		FROM CompletedForm cf WITH (NOLOCK)
		WHERE cf.IdPointOfInterest IS NULL
			AND cf.Date BETWEEN @DateFrom AND @DateTo
	),
	GroupedPersons AS
	(
		SELECT IdPersonOfInterest, CASE WHEN Day(DateIn) <> Day(DateOut) THEN 2 ELSE 1 END AS Quantity
		FROM TemporalData
		GROUP BY IdPersonOfInterest, DateIn, DateOut
	)

	SELECT pi.Id AS PersonOfInterestId, pi.Identifier AS PersonOfInterestIdentifier, pi.Name AS PersonOfInterestName, pi.LastName AS PersonOfInterestLastName, SUM(gp.Quantity) AS Quantity
	FROM PersonOfInterest pi
	LEFT JOIN GroupedPersons gp ON gp.IdPersonOfInterest = pi.Id
	WHERE (@IdPersonOfInterest IS NULL OR dbo.CheckValueInList(pi.Id, @IdPersonOfInterest) = 1)
	GROUP BY pi.Id, pi.Identifier, pi.Name, pi.LastName, gp.IdPersonOfInterest
	ORDER BY IdPersonOfInterest DESC
END
