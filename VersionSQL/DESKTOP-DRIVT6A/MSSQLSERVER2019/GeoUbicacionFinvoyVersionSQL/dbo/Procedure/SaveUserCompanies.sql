/****** Object:  Procedure [dbo].[SaveUserCompanies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 23/07/2019
-- Description:	SP para guardar compañias de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserCompanies]
(
	 @IdUser [sys].[int]
	,@IdCompanies [sys].[varchar](200)
)
AS
BEGIN
	INSERT INTO [dbo].[UserCompany](IdUser, IdCompany)
	(SELECT	@IdUser, C.[Id]
	FROM	[dbo].[Company] C
	WHERE	dbo.CheckValueInList(C.[Id], @IdCompanies) = 1)
END
