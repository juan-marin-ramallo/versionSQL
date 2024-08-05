/****** Object:  Procedure [dbo].[SaveProductRefund]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 27/10/2015
-- Description:	SP para guardar una devolución de producto
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductRefund]
(	
	 @Id [sys].[int] OUT
	,@IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@IdProduct [sys].[int]
	,@Date [sys].[datetime]
	,@Quantity [sys].[INT] = NULL
	,@IdRefundOption [sys].[INT] = NULL
	,@Description [sys].[VARCHAR] (230) = NULL
)
AS
BEGIN

	SET @Id = 0

	IF NOT EXISTS ( SELECT 1 
					FROM [dbo].[ProductRefund] PR WITH (NOLOCK)
					WHERE PR.[IdPersonOfInterest] = @IdPersonOfInterest AND
						  PR.[IdPointOfInterest] = @IdPointOfInterest AND 
						  PR.[Date] = @Date AND PR.[IdProduct] = @IdProduct AND PR.[Quantity] = @Quantity)
	BEGIN

		INSERT INTO [dbo].[ProductRefund]
				( [Date] ,
				  [IdPointOfInterest] ,
				  [IdPersonOfInterest] ,
				  [IdProduct] ,
				  [Quantity] ,
				  [Description],
				  [IdRefundOption]
				)
		VALUES  ( @Date , -- Date - datetime
				  @IdPointOfInterest , -- IdPointOfInterest - int
				  @IdPersonOfInterest , -- IdPersonOfInterest - int
				  @IdProduct , -- IdProduct - int
				  @Quantity , -- Quantity - int
				  @Description , -- Description - varchar(230)
				  @IdRefundOption
				)

		SELECT @Id = SCOPE_IDENTITY()    

		EXEC [dbo].[SavePointsOfInterestActivity]
					@IdPersonOfInterest = @IdPersonOfInterest
				,@IdPointOfInterest = @IdPointOfInterest
				,@DateIn = @Date
				,@AutomaticValue = 7

	END
END
