/****** Object:  Procedure [dbo].[GetIncidentFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/08/2016
-- Description:	SP para obtener las imagenes de los incidentes
-- =============================================

CREATE PROCEDURE [dbo].[GetIncidentFile] 
	@Id [sys].[INT],
	@Num [sys].[INT]
AS
BEGIN

	IF @Num = 1 
	BEGIN
		SELECT		I.[ImageEncoded] AS FileEncoded, I.[ImageUrl] AS ImageUrl, I.[CreatedDate],
					P.[Name], P.[Identifier]
		FROM		[dbo].[Incident] I	
					JOIN [dbo].[PointOfInterest] P ON P.[Id] = I.[IdPointOfInterest]
		WHERE		I.[Id] = @Id
	END 
	
	IF @Num = 2
	BEGIN
		SELECT		I.[ImageEncoded2] AS FileEncoded, I.[ImageUrl2] AS ImageUrl, I.[CreatedDate],
					P.[Name], P.[Identifier]
					FROM		[dbo].[Incident] I	
					JOIN [dbo].[PointOfInterest] P ON P.[Id] = I.[IdPointOfInterest]
		WHERE		I.[Id] = @Id
	END 

	IF @Num = 3
	BEGIN
		SELECT		I.[ImageEncoded3] AS FileEncoded, I.[ImageUrl3] AS ImageUrl, I.[CreatedDate],
					P.[Name], P.[Identifier]
		FROM		[dbo].[Incident] I	
					JOIN [dbo].[PointOfInterest] P ON P.[Id] = I.[IdPointOfInterest]
		WHERE		I.[Id] = @Id
	END 
	
END
