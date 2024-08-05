/****** Object:  Procedure [dbo].[FullDeleteProductReportSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FullDeleteProductReportSection]
	@Id int
AS
BEGIN
	DECLARE @UpdatedProductReportSectionCount [sys].[int]

	UPDATE	[dbo].[ProductReportSection]
	SET		[FullDeleted] = 1, [Deleted] = 1
	WHERE	[Id] = @Id

	SET @UpdatedProductReportSectionCount = @@ROWCOUNT

	IF EXISTS (SELECT 1 FROM ProductReportAttribute WITH (NOLOCK)
			   WHERE [IdProductReportSection] = @Id 
			     AND [Deleted] = 0 
				 AND [IsStar] = 1) 
	BEGIN 
		EXEC [dbo].[UpdateAllProductPointOfInterestChangeLog]
	END

	UPDATE	[dbo].[ProductReportAttribute]
	SET		[FullDeleted] = 1, [Deleted] = 1, [IsStar] = 0
	WHERE	[IdProductReportSection] = @Id

	--Elimino de field
	UPDATE  F
	SET		[Deleted] = 1,
			[FullDeleted] = 1
	FROM	[dbo].[Field] F
	INNER JOIN [dbo].[ProductReportAttribute] PRA WITH (NOLOCK) ON PRA.[Id] = F.[IdProductReportAttribute]
	WHERE	PRA.[IdProductReportSection] = @Id

	DELETE PRL 
	FROM ProductReportLastStarAttributeValue PRL WITH (NOLOCK)
	INNER JOIN ProductReportAttribute PRA WITH (NOLOCK) ON PRA.[Id] = PRL.[IdProductReportAttribute]
	WHERE PRA.[IdProductReportSection] = @Id

	RETURN @UpdatedProductReportSectionCount
END
