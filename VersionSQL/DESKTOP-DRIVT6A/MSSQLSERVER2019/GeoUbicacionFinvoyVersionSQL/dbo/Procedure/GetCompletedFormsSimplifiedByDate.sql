/****** Object:  Procedure [dbo].[GetCompletedFormsSimplifiedByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 19/12/2020
-- Description:	SP paa obtener los ids de ftareas, punto y persona de todas las tareas completadas para usar en la api
-- =============================================
create PROCEDURE [dbo].[GetCompletedFormsSimplifiedByDate]
	@DateFrom [sys].[datetime],
	@DateTo [sys].[datetime]
AS
BEGIN

	DECLARE @DateFromLocal [sys].[datetime] = @DateFrom
	DECLARE @DateToLocal [sys].[datetime] = @DateTo

	SELECT	CF.[Id], CF.[Date], CF.[IdForm], CF.[IdPersonOfInterest], CF.[IdPointOfInterest]

	FROM	[dbo].[CompletedForm] CF WITH (NOLOCK)
				
	WHERE	(CF.[Date] BETWEEN @DateFromLocal AND @DateToLocal) 
				
END
