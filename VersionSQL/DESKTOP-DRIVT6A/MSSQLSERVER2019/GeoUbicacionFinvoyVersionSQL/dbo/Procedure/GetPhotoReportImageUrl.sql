/****** Object:  Procedure [dbo].[GetPhotoReportImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		JP
-- Create date: 12/12/2019
-- Description:	SP para obtener las url de las imagenes de los incidentes
-- =============================================

CREATE PROCEDURE [dbo].[GetPhotoReportImageUrl] @Id [sys].[INT],
@Num [sys].[INT]
AS
BEGIN

  IF @Num = 1
  BEGIN
    SELECT
      I.[ImageUrl1] AS ImageUrl
    FROM [dbo].[PhotoReport] I
    WHERE I.[Id] = @Id
  END

  IF @Num = 2
  BEGIN
    SELECT
      I.[ImageUrl2] AS ImageUrl
    FROM [dbo].[PhotoReport] I
    WHERE I.[Id] = @Id
  END

  IF @Num = 3
  BEGIN
    SELECT
      I.[ImageUrl1After] AS ImageUrl
    FROM [dbo].[PhotoReport] I
    WHERE I.[Id] = @Id
  END

  IF @Num = 4
  BEGIN
    SELECT
      I.[ImageUrl2After] AS ImageUrl
    FROM [dbo].[PhotoReport] I
    WHERE I.[Id] = @Id
  END

END
