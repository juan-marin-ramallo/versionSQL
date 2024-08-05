/****** Object:  Procedure [dbo].[IsPersonOfInterestEnabled]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/09/2012
-- Description:	SP para saber si está o no habilitado un repositor
-- =============================================
CREATE PROCEDURE [dbo].[IsPersonOfInterestEnabled]
(
	 @IdPersonOfInterest [sys].[int] = NULL
	,@MobileIMEI [sys].[varchar](40) = NULL
)
AS
BEGIN
	SELECT	S.[Id]
	FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
	WHERE	S.[Deleted] = 0 AND
			S.[Status] = 'H' AND
			S.[Pending] = 0 AND
			((@IdPersonOfInterest IS NULL) OR (S.[Id] = @IdPersonOfInterest)) AND
			((@MobileIMEI IS NULL) OR (S.[MobileIMEI] LIKE '%' + @MobileIMEI + '%')) 
			AND NOT EXISTS (SELECT 1 FROM [dbo].[CustomerValidation] WHERE [BlockedMobile] = 1)			
END
