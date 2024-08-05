/****** Object:  Procedure [dbo].[UpdateInterestLink]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 01/09/2017
-- =============================================
CREATE PROCEDURE [dbo].[UpdateInterestLink]
	 @Id int
	,@Name varchar(100)
	,@Value varchar(MAX) = ''
AS
BEGIN

	UPDATE	[dbo].[InterestLink]
	SET		[Name] = @Name, [Value] = @Value
	WHERE	[Id] = @Id

	SELECT @Id as Id;
	
END
