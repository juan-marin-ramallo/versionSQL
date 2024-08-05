/****** Object:  Procedure [dbo].[GetChileanRegulationConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/08/2023
-- Description:	Obtiene la info de las
--				configuraciones para la
--				normativa de Chile
-- =============================================
CREATE PROCEDURE [dbo].[GetChileanRegulationConfiguration]
AS
BEGIN
	SELECT
		MAX(CASE
			WHEN Id = 4089 THEN [Value]
		END) AS IsEnabled
	   ,MAX(CASE
			WHEN Id = 4090 THEN [Value]
		END) AS DtIpRange
		,MAX(CASE
			WHEN Id = 4091 THEN [Value]
		END) AS DtEmailDomain
	FROM [dbo].[Configuration] WITH (NOLOCK)
	WHERE [Id] IN (4089, 4090, 4091);
END
