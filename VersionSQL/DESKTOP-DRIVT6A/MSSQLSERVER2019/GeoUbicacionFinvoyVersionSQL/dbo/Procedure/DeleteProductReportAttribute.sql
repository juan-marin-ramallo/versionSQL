/****** Object:  Procedure [dbo].[DeleteProductReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductReportAttribute]
	@Id int
AS
BEGIN
	DECLARE @UpdatedProductReportAttributesCount [sys].[int]

	IF EXISTS (SELECT 1 FROM ProductReportAttribute WITH (NOLOCK) WHERE [Id] = @Id AND [IsStar] = 1) BEGIN 
		EXEC [dbo].[UpdateAllProductPointOfInterestChangeLog]
	END

	UPDATE	[dbo].[ProductReportAttribute]
	SET		[Deleted] = 1, [FullDeleted] = 1, [IsStar] = 0
	WHERE	[Id] = @Id

	SET @UpdatedProductReportAttributesCount = @@ROWCOUNT

	UPDATE  [dbo].[Field]
	SET		[Deleted] = 1,
			[FullDeleted] = 1
	WHERE	[IdProductReportAttribute] = @Id

	DELETE PRL 
	FROM ProductReportLastStarAttributeValue PRL WITH (NOLOCK)
	INNER JOIN ProductReportAttribute PRA WITH (NOLOCK) ON PRA.[Id] = PRL.[IdProductReportAttribute]
	WHERE PRA.[Id] = @Id

	RETURN @UpdatedProductReportAttributesCount
END
