/****** Object:  Procedure [dbo].[SavePowerpointMarkupProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 12/06/17
-- Description:	SP para guardar un formato de powerpoint para el reporte
-- =============================================
CREATE PROCEDURE [dbo].[SavePowerpointMarkupProductReport]
(
	@Name [varchar](256),
	@ShowTitles [bit] = 0,
	@Elements [PowerPointMarkupElement] READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[PowerpointMarkupProductReport]([Name], [ShowTitles])
	VALUES (@Name, @ShowTitles)

	DECLARE @IdPowerpointMarkupProductReport [sys].[int] = SCOPE_IDENTITY()

	INSERT INTO [dbo].[PowerpointMarkupProductReportElement]
			   ([IdPowerpointMarkupProductReport]
			   ,[PageIndex]
			   ,[IdPowerpointMarkupElement]
			   ,[IdProductReportAttribute]
			   ,[ShowTitle])
     SELECT @IdPowerpointMarkupProductReport, [PageIndex], [IdPowerpointMarkupElement], [IdElement], 0
	 FROM @Elements

	 SELECT @IdPowerpointMarkupProductReport
END
