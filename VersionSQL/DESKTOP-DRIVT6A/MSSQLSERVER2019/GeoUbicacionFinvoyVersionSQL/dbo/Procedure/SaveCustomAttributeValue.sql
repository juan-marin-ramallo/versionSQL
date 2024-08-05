/****** Object:  Procedure [dbo].[SaveCustomAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomAttributeValue]
	 @IdCustomAttribute int
	,@IdPointOfInterest int
	,@Value varchar(MAX)
	,@IdCustomAttributeOption int = null
AS
BEGIN
	INSERT INTO CustomAttributeValue ([IdCustomAttribute], [IdPointOfInterest], [Value], [IdCustomAttributeOption])
	VALUES (@IdCustomAttribute, @IdPointOfInterest, IIF(@IdCustomAttributeOption IS NULL, @Value, NULL), @IdCustomAttributeOption)
END
