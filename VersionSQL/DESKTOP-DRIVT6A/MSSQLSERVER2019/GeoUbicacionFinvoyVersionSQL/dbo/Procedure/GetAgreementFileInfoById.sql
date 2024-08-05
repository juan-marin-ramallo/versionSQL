/****** Object:  Procedure [dbo].[GetAgreementFileInfoById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/08/2016
-- Description:	SP para obtener toda la información de EL ARCHIVO DE UN contrato a partir de su id
-- =============================================

CREATE PROCEDURE [dbo].[GetAgreementFileInfoById] 
	@Id [sys].[int]
AS
BEGIN
	
	SELECT		A.[Id],A.[FileName], A.[RealFileName],A.[FileEncoded],A.[FileType]
	
	FROM		[dbo].[Agreement] A
	
	WHERE		A.[Id] = @Id
	
	GROUP BY	A.[Id],A.[FileName], A.[RealFileName],A.[FileEncoded],A.[FileType]
END
