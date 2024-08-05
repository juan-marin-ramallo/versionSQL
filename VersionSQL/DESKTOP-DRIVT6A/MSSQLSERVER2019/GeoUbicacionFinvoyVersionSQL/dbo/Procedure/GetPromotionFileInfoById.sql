/****** Object:  Procedure [dbo].[GetPromotionFileInfoById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/08/2016
-- Description:	SP para obtener toda la información de EL ARCHIVO DE UNa promocion a partir de su id
-- =============================================

CREATE PROCEDURE [dbo].[GetPromotionFileInfoById] 
	@Id [sys].[int]
AS
BEGIN
	
	SELECT		P.[Id],P.[FileName],P.[RealFileName],P.[FileEncoded]
	
	FROM		[dbo].[Promotion] P
	
	WHERE		P.[Id] = @Id
	
	GROUP BY	P.[Id],P.[FileName],P.[RealFileName],P.[FileEncoded]
END
