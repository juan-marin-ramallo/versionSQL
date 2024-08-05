/****** Object:  Procedure [dbo].[AssignPointOfInterestToWorkData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/08/2016
-- Description:	SP para ASIGNAR el nuevo punto de interés a todos los contratos, pormociones y planimetrias si corresponde.
-- =============================================
CREATE PROCEDURE [dbo].[AssignPointOfInterestToWorkData]
 
	 @IdPointOfInterest [sys].INT
	,@IdUser [sys].[INT] = NULL
AS
BEGIN

	--Promociones
	INSERT INTO [dbo].[PromotionPointOfInterest] (IdPointOfInterest, IdPromotion, Date)
	SELECT		@IdPointOfInterest, P.[Id], GETUTCDATE()
	FROM		[dbo].[Promotion] P
	where		P.[Deleted] = 0 AND P.[AllPointOfInterest] = 1

	--Acuerdos y contratos
	INSERT INTO [dbo].[AgreementPointOfInterest] (IdPointOfInterest, IdAgreement, Date)
	SELECT		@IdPointOfInterest, A.[Id], GETUTCDATE()
	FROM		[dbo].[Agreement] A
	where		A.[Deleted] = 0 AND A.[AllPointOfInterest] = 1

	--Acuerdos y contratos
	INSERT INTO [dbo].[PlanimetryPointOfInterest] (IdPointOfInterest, IdPlanimetry, Date)
	SELECT		@IdPointOfInterest, P.[Id], GETUTCDATE()
	FROM		[dbo].[Planimetry] P
	where		P.[Deleted] = 0 AND P.[AllPointOfInterest] = 1
	
END
