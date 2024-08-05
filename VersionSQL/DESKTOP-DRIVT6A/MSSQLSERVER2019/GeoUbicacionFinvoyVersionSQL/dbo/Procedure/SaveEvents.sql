/****** Object:  Procedure [dbo].[SaveEvents]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 17/05/2016
-- Description:	SP para guardar un set de eventos
-- =============================================
CREATE PROCEDURE [dbo].[SaveEvents]
(
	@Events EventTableType READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[Event]([Date], [IdPersonOfInterest], [Type])
	SELECT	[Date], [IdPersonOfInterest], [Type]
	FROM	@Events
END
