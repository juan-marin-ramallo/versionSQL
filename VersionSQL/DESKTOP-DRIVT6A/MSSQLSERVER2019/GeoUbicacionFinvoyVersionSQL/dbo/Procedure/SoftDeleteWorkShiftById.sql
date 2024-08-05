/****** Object:  Procedure [dbo].[SoftDeleteWorkShiftById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SoftDeleteWorkShiftById]
(
    @Id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.WorkShift
    SET Deleted = 1,
        DeletedDate = GETUTCDATE()
    WHERE Id = @Id;
END;
