/****** Object:  Procedure [dbo].[IsPersonOfInterestEmailDuplicated]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 15/08/2023
-- Description:	SP para saber si un email ya
--              está registrado con una persona
--              de interés activa
-- =============================================
CREATE PROCEDURE [dbo].[IsPersonOfInterestEmailDuplicated]
(
     @Id [sys].[int] = NULL
    ,@Email [sys].[varchar](255)
)
AS
BEGIN
    SELECT  TOP(1) 1
    FROM    [dbo].[AvailablePersonOfInterest] WITH (NOLOCK)
    WHERE   [Email] = @Email
            AND [Id] <> (CASE WHEN @Id IS NULL THEN -1 ELSE @Id END)
END
