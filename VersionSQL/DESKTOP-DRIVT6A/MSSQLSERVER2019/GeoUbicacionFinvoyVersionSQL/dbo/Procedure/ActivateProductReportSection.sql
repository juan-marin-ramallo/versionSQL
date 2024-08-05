/****** Object:  Procedure [dbo].[ActivateProductReportSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ActivateProductReportSection]
	@Id int
AS
BEGIN
	
		UPDATE	[dbo].[ProductReportSection]
		SET		[Deleted] = 0
		WHERE	[Id] = @Id

		UPDATE	[dbo].[ProductReportAttribute]
		SET		[Deleted] = 0
		WHERE	[IdProductReportSection] = @Id AND [FullDeleted] = 0

		UPDATE	F
		SET		[Deleted] = 0
		FROM	[dbo].[FieldTranslated] F
		INNER JOIN [dbo].[ProductReportAttribute] PRA ON F.[IdProductReportAttribute] = PRA.[Id]
		WHERE	PRA.[IdProductReportSection] = @Id
		  AND	F.[FullDeleted] = 0

END
