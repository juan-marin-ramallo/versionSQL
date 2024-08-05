/****** Object:  Procedure [dbo].[DeleteWorkPlan]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[DeleteWorkPlan]
	 @Id [sys].[int]
AS
BEGIN

	--Brand Name Duplicated
	--IF EXISTS (SELECT 1 FROM [dbo].[Brand] WHERE [Name] = @Name AND [Deleted] = 0) 
	--	SELECT @Id = -1;
	--ELSE
	BEGIN 
		UPDATE [dbo].WorkPlan
		SET Deleted = 1
		WHERE Id = @Id

		UPDATE m
		SET m.Deleted = 1
		FROM [dbo].Meeting m
			inner join [dbo].WorkActivity wa on m.Id = wa.MeetingId
		WHERE wa.WorkPlanId = @Id

		UPDATE [dbo].WorkActivity
		SET Deleted = 1
		WHERE WorkPlanId = @Id
	END

END
