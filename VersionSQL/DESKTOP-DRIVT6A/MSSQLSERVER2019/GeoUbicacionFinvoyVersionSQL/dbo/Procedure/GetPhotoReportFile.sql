/****** Object:  Procedure [dbo].[GetPhotoReportFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/08/2016
-- Description:	SP para obtener las imagenes de los incidentes
-- =============================================

CREATE PROCEDURE [dbo].[GetPhotoReportFile] 
	@Id [sys].[INT],
	@Num [sys].[INT]
AS
BEGIN

	IF @Num = 1 
	BEGIN
		SELECT		I.[ImageEncoded1] AS FileEncoded
		FROM		[dbo].[PhotoReport] I	
		WHERE		I.[Id] = @Id
	END 
	
	IF @Num = 2
	BEGIN
		SELECT		I.[ImageEncoded2] AS FileEncoded
		FROM		[dbo].[PhotoReport] I	
		WHERE		I.[Id] = @Id
	END 

	IF @Num = 3
	BEGIN
		SELECT		I.[ImageEncoded1After] AS FileEncoded
		FROM		[dbo].[PhotoReport] I	
		WHERE		I.[Id] = @Id
	END 

	IF @Num = 4
	BEGIN
		SELECT		I.[ImageEncoded2After] AS FileEncoded
		FROM		[dbo].[PhotoReport] I	
		WHERE		I.[Id] = @Id
	END 
	
END
