/****** Object:  Procedure [dbo].[DeleteProductReportSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductReportSection]
	@Id int
AS
BEGIN
	
	UPDATE	[dbo].[ProductReportSection]
	SET		[Deleted] = 1
	WHERE	[Id] = @Id

	IF EXISTS (SELECT 1 FROM ProductReportAttribute WITH (NOLOCK)
			   WHERE [IdProductReportSection] = @Id 
			     AND [Deleted] = 0 
			     AND [FullDeleted] = 0 
				 AND [IsStar] = 1) 
	BEGIN 
		EXEC [dbo].[UpdateAllProductPointOfInterestChangeLog]
	END

	UPDATE	[dbo].[ProductReportAttribute]
	SET		[Deleted] = 1, [IsStar] = 0
	WHERE	[IdProductReportSection] = @Id

	--Elimino de field
	UPDATE  F
	SET		[Deleted] = 1
	FROM	[dbo].[Field] F
	INNER JOIN [dbo].[ProductReportAttribute] PRA WITH (NOLOCK) ON PRA.[Id] = F.[IdProductReportAttribute]
	WHERE	PRA.[IdProductReportSection] = @Id
	  AND	F.[Deleted] = 0

	DELETE PRL 
	FROM ProductReportLastStarAttributeValue PRL WITH (NOLOCK)
	INNER JOIN ProductReportAttribute PRA WITH (NOLOCK) ON PRA.[Id] = PRL.[IdProductReportAttribute]
	WHERE PRA.[IdProductReportSection] = @Id

END
