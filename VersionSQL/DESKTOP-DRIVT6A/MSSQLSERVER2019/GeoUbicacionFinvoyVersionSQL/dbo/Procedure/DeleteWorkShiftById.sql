/****** Object:  Procedure [dbo].[DeleteWorkShiftById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteWorkShiftById]  
(  
    @Id INT  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    IF NOT EXISTS (SELECT 1 FROM PersonOfInterestWorkShift WHERE IdWorkShift = @Id OR IdRestShift = @Id)  
    BEGIN  
      UPDATE dbo.WorkShift  
      SET Deleted = 1,  
          DeletedDate = GETUTCDATE()  
      WHERE Id = @Id;  
    END  
    ELSE BEGIN  
      SELECT DISTINCT CONCAT(PEOI.[Name], ' ' ,PEOI.[LastName]) AS FullName
      FROM PersonOfInterestWorkShift PEOIWS WITH (NOLOCK)
      LEFT JOIN PersonOfInterest PEOI WITH (NOLOCK) ON PEOIWS.IdPersonOfInterest = PEOI.Id
      WHERE PEOIWS.IdWorkShift = @Id OR PEOIWS.IdRestShift = @Id
    END  
END;
