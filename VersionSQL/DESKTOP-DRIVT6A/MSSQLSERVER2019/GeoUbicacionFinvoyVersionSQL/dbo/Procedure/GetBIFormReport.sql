/****** Object:  Procedure [dbo].[GetBIFormReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 13/03/17
-- Description:	SP que obtiene la info necesaria para el reporte de formularios de modulo de BI
-- =============================================
CREATE PROCEDURE [dbo].[GetBIFormReport]
	@LastReportedDate datetime
AS
BEGIN
	DECLARE @YesText [sys].[varchar](5000)
	SET @YesText = '"' + UPPER(dbo.GetCommonTextTranslated('Yes')) + '"'

	DECLARE @NoText [sys].[varchar](5000)
	SET @NoText = '"' + UPPER(dbo.GetCommonTextTranslated('No')) + '"'

	

	select CONCAT( '"', F.[Name],'"') AS FormName, 
			CASE WHEN FC.[Name] IS NOT NULL THEN  CONCAT('"', FC.[Name] ,'"') ELSE 'NULL' END AS CategoryName,
		CONCAT( '"', S.[Name], ' ', S.[LastName],'"') AS PersonOfInterestFullName,
		CONCAT( '"', POI.[Identifier], '-', POI.[Name],'"') AS PointOfInterestFullName,
		CONCAT( '"', POI.[Latitude], ', ', POI.[Longitude], '"') AS PointOfInterestCoordinate,
		ISNULL(CONVERT(VARCHAR,FORMAT(CAST(Tzdb.FromUtc(CF.[Date]) AS [sys].[date]),'yyyy-MM-dd'),21), 'NULL')  AS CompletedDate,
		CONCAT( '"', Q.[Text],'"') AS QuestionTitle, 
		CASE WHEN Q.[Type] = 'CK' THEN  CASE WHEN A.[Check] = 1 THEN  @YesText ELSE @NoText END
			 WHEN Q.[Type] = 'DATE' THEN ISNULL(CONVERT(VARCHAR,FORMAT(CAST(Tzdb.FromUtc(A.[DateReply]) AS [sys].[date]),'yyyy-MM-dd'),21), 'NULL')  
			 WHEN Q.[Type] = 'FT' THEN CONCAT( '"', A.[FreeText],'"') 
			 WHEN Q.[Type] = 'NUM' THEN CONCAT( '"', A.[FreeText],'"')
			 WHEN Q.[Type] = 'YN' THEN  CASE WHEN A.[YNOption] = 1 THEN  @YesText ELSE @NoText END
			 WHEN Q.[Type] = 'MO' THEN  CONCAT( '"', QO.[Text],'"') 
			 WHEN Q.[Type] = 'CODE' THEN  CONCAT( '"', A.[FreeText],'"') 
			 WHEN Q.[Type] = 'CAM' THEN  CONCAT( '"www.geoubicacion.com/GeoV3/Services/MobileService.svc?DownloadImage?id=', A.[Id],'"') 
			 WHEN Q.[Type] = 'SIG' THEN  CONCAT( '"www.geoubicacion.com/GeoV3/Services/MobileService.svc?DownloadImage?id=', A.[Id],'"')
		END AS QuestionAnswer,
		'"1"' AS Quantity
	FROM [dbo].[CompletedForm] CF
	INNER JOIN [dbo].[Form] F ON CF.[IdForm] = F.[Id]
	INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = CF.[IdPointOfInterest]
	INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	INNER JOIN [dbo].[Question] Q ON Q.[IdForm] = F.[Id]
	INNER JOIN [dbo].[Answer] A ON A.[IdQuestion] = Q.[Id] and A.[IdCompletedForm] = CF.[Id] 
					AND ((Q.[Type] = 'FT' AND [FreeText] IS NOT NULL AND [FreeText] <> '') OR (Q.[Type] = 'CK' AND [Check] IS NOT NULL) OR 
					(Q.[Type] = 'YN' AND [YNOption] IS NOT NULL) OR (Q.[Type] = 'DATE' AND [DateReply] IS NOT NULL)
						OR (Q.[Type] = 'CAM' AND [ImageName] IS NOT NULL) OR (Q.[Type] = 'MO' AND [IdQuestionOption] IS NOT NULL)
						OR (Q.[Type] = 'NUM' AND [FreeText] IS NOT NULL AND [FreeText] <> '')
						OR (Q.[Type] = 'CODE' AND [FreeText] IS NOT NULL AND [FreeText] <> ''))
	LEFT JOIN  [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
	LEFT JOIN  [dbo].[QuestionOption] QO ON QO.[Id] = A.[IdQuestionOption]

	where CF.[ReceivedDate] > @LastReportedDate 
	  AND Q.[Type] <> 'TI' AND Q.[Type] <> 'IMG'

	order by F.Id, S.Name
END
