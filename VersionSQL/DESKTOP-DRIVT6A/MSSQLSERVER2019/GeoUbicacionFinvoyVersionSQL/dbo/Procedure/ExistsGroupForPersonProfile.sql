/****** Object:  Procedure [dbo].[ExistsGroupForPersonProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/04/2018
-- Description:	SP para SABER SI HAY AGRUPACIONES PARA UN PERFIL O NO - SIRVE PARA DETERMINAR CREACION DE TAB FICTICIO
-- =============================================
CREATE PROCEDURE [dbo].[ExistsGroupForPersonProfile]
(
	@IdPersonOfInterest [sys].[int],
	@ResultCode [sys].[int] OUT
)
AS
BEGIN

	SET @ResultCode = 0

	DECLARE @PersonOfInterestType [sys].[CHAR](1) = (SELECT TOP 1 [Type] FROM [dbo].PersonOfInterest WITH (NOLOCK) WHERE [Id] = @IdPersonOfInterest)
	IF EXISTS (SELECT 1 FROM [dbo].[CustomAttributeGroupPersonType] WHERE [PersonOfInterestType] = @PersonOfInterestType)
	BEGIN
		SET @ResultCode = 0
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM [dbo].[CustomAttribute] WHERE [Deleted] = 0)
		BEGIN
			SET @ResultCode = 1
		END
	END

END
