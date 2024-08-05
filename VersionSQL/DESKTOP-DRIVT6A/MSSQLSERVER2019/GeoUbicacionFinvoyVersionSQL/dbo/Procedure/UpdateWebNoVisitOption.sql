/****** Object:  Procedure [dbo].[UpdateWebNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 05/11/2018
-- Description:	SP para actualizar un motivo de no visita en la web
-- =============================================
CREATE PROCEDURE [dbo].[UpdateWebNoVisitOption]
(
	 @Id [sys].[int]
	,@Description [sys].[varchar](100)
)
AS
BEGIN

	--RouteNoVisitOption Description Duplicated
	IF EXISTS (SELECT 1 FROM [dbo].[RouteWebNoVisitOption] WHERE [Description] = @Description AND [Deleted] = 0 AND @Id != [Id]) SELECT -1 AS Id;

	ELSE
	BEGIN 
		UPDATE	[dbo].[RouteWebNoVisitOption]
		
		SET		 [Description] = @Description,
				 [EditedDate] = GETUTCDATE()
		
		WHERE	 [Id] = @Id

		SELECT @Id as Id;
	END

END
