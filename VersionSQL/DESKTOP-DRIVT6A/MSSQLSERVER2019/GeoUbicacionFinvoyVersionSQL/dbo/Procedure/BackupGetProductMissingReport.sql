/****** Object:  Procedure [dbo].[BackupGetProductMissingReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetProductMissingReport]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[IdMissingProductPoi],a.[IdProduct]
  FROM [dbo].ProductMissingReport a WITH(NOLOCK)
	INNER JOIN [dbo].[ProductMissingPointOfInterest] b WITH(NOLOCK) ON a.IdMissingProductPoi = b.Id
  WHERE b.[Date] < @LimitDate
  GROUP BY a.[IdMissingProductPoi],a.[IdProduct]
  ORDER BY a.[IdMissingProductPoi] ASC, a.[IdProduct] ASC
END
