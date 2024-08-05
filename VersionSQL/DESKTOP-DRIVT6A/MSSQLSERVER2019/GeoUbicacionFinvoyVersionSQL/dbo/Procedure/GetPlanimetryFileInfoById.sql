/****** Object:  Procedure [dbo].[GetPlanimetryFileInfoById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 08/08/2016
-- Description:	SP para obtener toda la información de EL ARCHIVO DE UNa planimetria a partir de su id
-- =============================================

CREATE PROCEDURE [dbo].[GetPlanimetryFileInfoById] 
	@Id [sys].[int]
AS
BEGIN
	
	SELECT		P.[Id], P.[FileName], P.[RealFileName], P.[FileEncoded], P.[FileType]
	
	FROM		[dbo].[Planimetry] P
	
	WHERE		P.[Id] = @Id
	
	GROUP BY	P.[Id], P.[FileName], P.[RealFileName], P.[FileEncoded], P.[FileType]
END
