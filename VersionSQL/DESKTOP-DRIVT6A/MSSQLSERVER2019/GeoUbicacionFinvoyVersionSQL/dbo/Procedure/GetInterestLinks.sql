/****** Object:  Procedure [dbo].[GetInterestLinks]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetInterestLinks]
AS
BEGIN

	SELECT	i.[Id], i.[Name], i.[Value]	
	FROM	dbo.[InterestLink] i	
	WHERE	i.[Deleted] = 0

END
