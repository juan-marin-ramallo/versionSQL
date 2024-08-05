/****** Object:  Procedure [dbo].[SaveAuditLogFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 26/02/2020
-- Description:	SP para almacenar información de archivos utilizados en AuditLog
-- =============================================
CREATE PROCEDURE [dbo].[SaveAuditLogFile]
(
	@IdAuditLog [int],
	@RequestName [varchar](100) = NULL,
	@FileName [varchar](100),
	@Url [varchar](2000)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO AuditLogFile ([IdAuditLog], [RequestName], [FileName], [Url])
	VALUES (@IdAuditLog, @RequestName, @FileName, @Url)

	SELECT SCOPE_IDENTITY()
	
END
