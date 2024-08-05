/****** Object:  Procedure [dbo].[SyncDocumentByIdentifier]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SyncDocumentByIdentifier]
	 @Identifier varchar(100)
	,@Type int
	,@FileName varchar(100)
	,@Document varbinary(max)
AS
BEGIN

	DECLARE @PlanimetryType int = 0
	DECLARE @AgreementType int = 1
	DECLARE @PromotionType int = 2

	IF @Type = @PlanimetryType 
	BEGIN

		UPDATE Planimetry
		SET  [FileEncoded] = @Document
			,[FileName] = @FileName
			,[RealFileName] = @FileName
		WHERE [Identifier] = @Identifier

	END
	ELSE IF @Type = @AgreementType
	BEGIN

		UPDATE Agreement
		SET  [FileEncoded] = @Document
			,[FileName] = @FileName
			,[RealFileName] = @FileName
		WHERE [Identifier] = @Identifier

	END
	ELSE IF @Type = @PromotionType
	BEGIN
	 
		UPDATE Promotion
		SET  [FileEncoded] = @Document
			,[FileName] = @FileName
			,[RealFileName] = @FileName
		WHERE [Identifier] = @Identifier

	END
END
