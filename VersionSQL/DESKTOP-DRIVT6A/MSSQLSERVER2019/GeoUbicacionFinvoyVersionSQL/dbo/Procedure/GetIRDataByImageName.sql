/****** Object:  Procedure [dbo].[GetIRDataByImageName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 08/06/2022
-- Description: SP para obtener información general de RI por nombre de imagen
-- =============================================
CREATE PROCEDURE [dbo].[GetIRDataByImageName]
	@ImageUniqueName VARCHAR(256)
AS
BEGIN
	SELECT TOP (1) idi.Id,
		idi.IdIRData,
		id.IdShareOfShelf,
		id.IdMissingProduct,
		id.IdCategory,
		id.[Date]
	FROM IRDataImage idi WITH (NOLOCK)
	LEFT JOIN IRData id WITH (NOLOCK) ON idi.IdIRData = id.Id
	WHERE ImageName = @ImageUniqueName
END;
