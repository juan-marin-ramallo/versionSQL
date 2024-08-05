/****** Object:  Procedure [dbo].[SaveProductReportAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportAttributeOption]
	 @IdAttribute int
	,@Text varchar(100)
	,@IsDefault bit
AS
BEGIN
	
	INSERT INTO ProductReportAttributeOption ([IdProductReportAttribute], [Text], [IsDefault], [Deleted])
	VALUES (@IdAttribute, @Text, @IsDefault, 0)

END
