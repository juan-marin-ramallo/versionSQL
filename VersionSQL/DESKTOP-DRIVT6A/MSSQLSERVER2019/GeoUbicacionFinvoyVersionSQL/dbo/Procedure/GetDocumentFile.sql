/****** Object:  Procedure [dbo].[GetDocumentFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/05/2017
-- Description:	SP para obtener las imagenes de los reportes de documentos
-- =============================================

CREATE PROCEDURE [dbo].[GetDocumentFile] 
	@Id [sys].[INT],
	@Type [sys].[INT],
	@Num [sys].[INT]
AS
BEGIN

	IF @Num = 1 
	BEGIN
		SELECT		D.[ImageEncoded] AS FileEncoded, D.[ImageUrl] AS ImageUrl, D.[Date],
					P.[Name], P.[Identifier]
		FROM		[dbo].[DocumentReport] D
					JOIN [dbo].[PointOfInterest] P ON P.[Id] = D.[IdPointOfInterest]	
		WHERE		D.[Id] = @Id
	END 
	
	IF @Num = 2
	BEGIN
		SELECT		D.[ImageEncoded2] AS FileEncoded, D.[ImageUrl2] AS ImageUrl, D.[Date],
					P.[Name], P.[Identifier]
		FROM		[dbo].[DocumentReport] D	
					JOIN [dbo].[PointOfInterest] P ON P.[Id] = D.[IdPointOfInterest]	
		WHERE		D.[Id] = @Id
	END 

	IF @Num = 3
	BEGIN
		SELECT		D.[ImageEncoded3] AS FileEncoded, D.[ImageUrl3] AS ImageUrl, D.[Date],
					P.[Name], P.[Identifier]
		FROM		[dbo].[DocumentReport] D	
					JOIN [dbo].[PointOfInterest] P ON P.[Id] = D.[IdPointOfInterest]	
		WHERE		D.[Id] = @Id
	END 
	
END
