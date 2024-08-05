/****** Object:  Procedure [dbo].[UpdateProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 22/12/2022
-- Description:	SP para guardar cambios en un
--				reporte de SKU dado
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductReport] 
	 @Id [sys].[int]
	,@IdUser [sys].[int]
	,@EditedDate [sys].[datetime]
	,@EditedReason [sys].[varchar](4000)	
	,@Values [dbo].ProductReportAttributeValueTableType READONLY
	,@Result [sys].[int] OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE	 AV
	SET		 AV.[Value] = V.[Value]
			,AV.[IdProductReportAttributeOption] = V.[IdProductReportAttributeOption]
			,AV.[ImageName] = V.[ImageName]
			,AV.[ImageEncoded] = V.[ImageEncoded]
			,AV.[ImageUrl] = V.[ImageUrl]
	FROM	 @Values V
			 INNER JOIN [dbo].[ProductReportAttributeValue] AV ON AV.[Id] = V.[Id]

	SET @Result = @@ROWCOUNT;

	UPDATE [dbo].[ProductReportDynamic]
	SET IdEditedUser = @IdUser,
		EditedDate = @EditedDate,
		EditedReason = @EditedReason
	WHERE Id = @Id

END
