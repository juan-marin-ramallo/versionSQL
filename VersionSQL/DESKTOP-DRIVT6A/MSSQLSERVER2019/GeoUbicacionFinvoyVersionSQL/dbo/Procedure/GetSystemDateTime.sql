/****** Object:  Procedure [dbo].[GetSystemDateTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/09/2012
-- Description:	SP para obtener la fecha/hora del sistema
-- =============================================
CREATE PROCEDURE [dbo].[GetSystemDateTime]
AS
BEGIN
	SELECT GETUTCDATE() AS SystemDateTime
END
