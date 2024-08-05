/****** Object:  Procedure [dbo].[ActivateAgreement]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 01/08/2016
-- Description:	SP para activar un acuerdo o contrato
-- =============================================
CREATE PROCEDURE [dbo].[ActivateAgreement] 
	@Id [sys].[int]
AS
BEGIN
	UPDATE	[dbo].[Agreement]
	SET		[Deleted] = 0, [DeletedDate] = NULL
	WHERE	[Id] = @Id
END
