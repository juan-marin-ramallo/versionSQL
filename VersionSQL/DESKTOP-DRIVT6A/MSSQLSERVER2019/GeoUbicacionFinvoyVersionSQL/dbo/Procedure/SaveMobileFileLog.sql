/****** Object:  Procedure [dbo].[SaveMobileFileLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 26/11/2020
-- Description:	SP para guardar un archivo de log de la app
-- =============================================
CREATE PROCEDURE [dbo].[SaveMobileFileLog]
(
	 @IdPersonOfInterest [sys].[int]
	,@IdMobileFileLogType [sys].[smallint]
	,@Name [sys].[varchar](200)
	,@Url [sys].[varchar](5000)
)
AS
BEGIN
	INSERT INTO [dbo].[MobileFileLog]([Date], [IdPersonOfInterest], [IdMobileFileLogType], [Name], [Url])
	VALUES (GETUTCDATE(), @IdPersonOfInterest, @IdMobileFileLogType, @Name, @Url)
END
