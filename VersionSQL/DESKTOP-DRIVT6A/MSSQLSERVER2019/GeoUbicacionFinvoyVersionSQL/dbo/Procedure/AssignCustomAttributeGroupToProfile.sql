/****** Object:  Procedure [dbo].[AssignCustomAttributeGroupToProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AssignCustomAttributeGroupToProfile]
	 @CodeProfile [sys].[char](1)
	,@IdGroup [sys].[int]
	,@Order [sys].[int]
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM [dbo].[CustomAttributeGroupPersonType] WHERE [IdCustomAttributeGroup] = @IdGroup AND
				[PersonOfInterestType] = @CodeProfile)
	BEGIN
	
		INSERT INTO  [dbo].[CustomAttributeGroupPersonType] ([IdCustomAttributeGroup], [PersonOfInterestType], [Order])
		VALUES (@IdGroup, @CodeProfile, @Order)

	END
END
