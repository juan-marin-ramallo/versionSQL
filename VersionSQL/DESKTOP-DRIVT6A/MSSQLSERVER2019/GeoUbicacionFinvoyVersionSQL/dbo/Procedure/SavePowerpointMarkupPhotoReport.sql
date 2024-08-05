/****** Object:  Procedure [dbo].[SavePowerpointMarkupPhotoReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SavePowerpointMarkupPhotoReport] 
(
	@Name [varchar](256),
	@Elements [PowerPointMarkupElement] READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[PowerpointMarkupPhotoReport]([Name])
	VALUES (@Name)

	DECLARE @IdPowerpointMarkupPhotoReport [sys].[int] = SCOPE_IDENTITY()

	INSERT INTO [dbo].[PowerpointMarkupPhotoReportElement]
			   ([IdPowerpointMarkupPhotoReport]
			   ,[PageIndex]
			   ,[IdPowerpointMarkupElement]
			   ,[IdPhotoReportExportAttribute])
     SELECT @IdPowerpointMarkupPhotoReport, [PageIndex], [IdPowerpointMarkupElement], [IdElement]
	 FROM @Elements

	 SELECT @IdPowerpointMarkupPhotoReport
END
