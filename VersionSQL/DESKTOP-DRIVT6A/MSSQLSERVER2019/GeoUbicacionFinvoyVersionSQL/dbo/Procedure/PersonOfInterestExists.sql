/****** Object:  Procedure [dbo].[PersonOfInterestExists]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/09/2012
-- Description:	SP para saber si existe o no un repositor
-- =============================================
CREATE PROCEDURE [dbo].[PersonOfInterestExists]
(
	@MobileIMEI [sys].[varchar](40)
)
AS
BEGIN
	SELECT S.[Id] FROM [dbo].[AvailablePersonOfInterest] S WITH (NOLOCK) WHERE S.[MobileIMEI] LIKE '%' + @MobileIMEI + '%'
END
