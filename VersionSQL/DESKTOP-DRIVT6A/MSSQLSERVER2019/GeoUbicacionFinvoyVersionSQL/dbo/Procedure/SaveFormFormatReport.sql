/****** Object:  Procedure [dbo].[SaveFormFormatReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/07/17
-- Description:	SP para guardar un formato de excel para el reporte
-- =============================================
CREATE PROCEDURE [dbo].[SaveFormFormatReport]
(
	@Name [varchar](250),
	@Options [ExcelFormatElement] READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[FormReportFormatElement]([Name], [CreatedDate])
	VALUES (@Name, GETUTCDATE())

	DECLARE @IdFormatFormReport [sys].[int] = SCOPE_IDENTITY()

	INSERT INTO [dbo].[FormReportFormatElementOptions]
			   ([IdFormatElement]
			   ,[IdFormatOptions])
     SELECT @IdFormatFormReport, [IdOption]
	 FROM @Options

	 SELECT @IdFormatFormReport
END
