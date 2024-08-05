/****** Object:  Procedure [dbo].[SaveWsMethodCallLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 17/11/2015
-- Description:	SP para guardar un log de las llamadas a los WS
-- =============================================
CREATE     PROCEDURE [dbo].[SaveWsMethodCallLog]
(
	 @Date [sys].[datetime]
	,@MethodName [sys].[varchar](200)
	,@MethodParameters [sys].[varchar](MAX) = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[WsMethodCallLog]([Date], [MethodName], [MethodParameters])
	VALUES (@Date, @MethodName, @MethodParameters)
END
