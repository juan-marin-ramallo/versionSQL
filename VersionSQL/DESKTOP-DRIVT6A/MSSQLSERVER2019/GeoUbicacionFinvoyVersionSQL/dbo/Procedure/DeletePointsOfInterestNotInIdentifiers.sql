/****** Object:  Procedure [dbo].[DeletePointsOfInterestNotInIdentifiers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeletePointsOfInterestNotInIdentifiers]
	@ActivePointIdentifiers [sys].[varchar](MAX)
AS
BEGIN
	
	UPDATE PointOfInterest
	SET [Deleted] = 1
	WHERE [Deleted] = 0
	  AND (@ActivePointIdentifiers IS NULL OR ([dbo].CheckVarcharInList([Identifier], @ActivePointIdentifiers) = 0))

END
