/****** Object:  Procedure [dbo].[GetAssetById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetById]
	@Id int
AS
BEGIN
	
	SELECT A.[Id], A.[Name], A.[Identifier], A.[BarCode], 
		   T.[Id] AS TypeId, T.[Name] AS TypeName 
	FROM Asset A
	LEFT OUTER JOIN AssetType T ON T.[Id] = A.[IdAssetType]
	WHERE A.[Id] = @Id

END
