/****** Object:  Procedure [dbo].[GetAgreementsMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 01/08/2016
-- Description:	SP para obtener los contratos y acuerdos por punto usadas en los servicios mobile
-- =============================================
CREATE PROCEDURE [dbo].[GetAgreementsMobile]
	@IdPointOfInterest [sys].[int]
AS
BEGIN
	
	SELECT		A.[Id], A.[Name],A.[StartDate], A.[EndDate], A.[Description], A.[FileName], A.[Deleted], A.MD5Checksum
	
	FROM		[dbo].[Agreement] A
				INNER JOIN [dbo].[AgreementPointOfInterest] AP ON A.[Id] = AP.[IdAgreement] 
	
	WHERE		AP.[IdPointOfInterest] = @IdPointOfInterest
	
	GROUP BY	A.[Id], A.[Name],A.[StartDate], A.[EndDate], A.[Description], A.[FileName], A.[Deleted], A.MD5Checksum
	
	ORDER BY	A.[Id] DESC
END
