/****** Object:  Procedure [dbo].[SaveWebVisitComment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 04/09/2018
-- Description:	Guardar o actualizar comentario de no visita en la web
-- =============================================
CREATE PROCEDURE [dbo].[SaveWebVisitComment]
(
	 @IdRouteDetail [sys].[int]
	,@Comments [sys].[varchar](1000) = NULL
    ,@IdUser [sys].[INT] = NULL
)
AS
BEGIN

	--Actualizo comentario
	UPDATE	[dbo].[RouteDetail]
	SET		[WebNoVisitComment] = @Comments, [IdUserWebNoVisitComment] = @IdUser,
			[WebNoVisitCommentDate] = GETUTCDATE()
	WHERE	[Id] = @IdRouteDetail

END
