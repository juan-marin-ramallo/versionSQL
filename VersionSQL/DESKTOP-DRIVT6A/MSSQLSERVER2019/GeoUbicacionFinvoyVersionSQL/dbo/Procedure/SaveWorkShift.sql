/****** Object:  Procedure [dbo].[SaveWorkShift]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveWorkShift]
(
	@Id INT,
    @Name VARCHAR(100),
    @StartTime TIME,
    @EndTime TIME,
    @IdType INT
)
AS
BEGIN
    SET NOCOUNT ON;
	 IF @Id > 0 
	BEGIN    

		 UPDATE  dbo.WorkShift 
		 SET [Name] = @Name, StartTime =@StartTime,EndTime = @EndTime, IdType = @IdType
		WHERE Id = @Id
	END
	ELSE
	INSERT INTO dbo.WorkShift ([Name], StartTime, EndTime, IdType, CreatedDate, Deleted, DeletedDate)
		VALUES (@Name, @StartTime, @EndTime, @IdType, SYSDatetime(), 0, NULL)
END;
