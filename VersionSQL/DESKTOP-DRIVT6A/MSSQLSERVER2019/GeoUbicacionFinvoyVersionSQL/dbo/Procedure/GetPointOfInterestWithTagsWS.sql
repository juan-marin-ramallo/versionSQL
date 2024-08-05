/****** Object:  Procedure [dbo].[GetPointOfInterestWithTagsWS]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/03/2016
-- Description:	SP para obtener los puntos de interes con sus respectivos tags utilizados para los web services
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestWithTagsWS]

AS
BEGIN
	SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				P.[NFCTagId] AS PointOfInterestNFCTagId

	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
	
	WHERE		P.[Deleted] = 0 AND P.[NFCTagId] IS NOT NULL
	
	ORDER BY	P.[Id] DESC
END
