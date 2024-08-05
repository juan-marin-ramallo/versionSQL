/****** Object:  Procedure [dbo].[UpdatePersonOfInterestStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePersonOfInterestStatus]
	 @Id [int]
	,@Status [char]
AS
BEGIN
	
	UPDATE PersonOfInterest
	SET [Status] = @Status
	WHERE Id = @Id

END
