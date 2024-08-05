/****** Object:  Procedure [dbo].[DeleteAllProfileGroups]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteAllProfileGroups]
	 @CodeProfile [sys].[char](1)
AS
BEGIN

	DELETE FROM [dbo].[CustomAttributeGroupPersonType]
	WHERE		[PersonOfInterestType] = @CodeProfile

END
