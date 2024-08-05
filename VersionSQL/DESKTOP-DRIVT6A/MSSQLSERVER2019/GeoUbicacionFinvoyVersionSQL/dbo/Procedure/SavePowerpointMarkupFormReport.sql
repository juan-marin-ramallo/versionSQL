/****** Object:  Procedure [dbo].[SavePowerpointMarkupFormReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 12/06/17
-- Description:	SP para guardar un formato de powerpoint para el reporte
-- =============================================
CREATE PROCEDURE [dbo].[SavePowerpointMarkupFormReport]
(
	@IdForm [int],
	@Name [varchar](256),
	@ShowTitles [bit] = 0,
	@Elements [PowerPointMarkupElement] READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[PowerpointMarkupFormReport]([IdForm], [Name], [ShowTitles])
	VALUES (@IdForm, @Name, @ShowTitles)

	DECLARE @IdPowerpointMarkupFormReport [sys].[int] = SCOPE_IDENTITY()

	INSERT INTO [dbo].[PowerpointMarkupFormReportElement]
			   ([IdPowerpointMarkupFormReport]
			   ,[PageIndex]
			   ,[IdPowerpointMarkupElement]
			   ,[IdQuestion]
			   ,[ShowTitle])
     SELECT @IdPowerpointMarkupFormReport, [PageIndex], [IdPowerpointMarkupElement], [IdElement], 0
	 FROM @Elements

	 SELECT @IdPowerpointMarkupFormReport
END
