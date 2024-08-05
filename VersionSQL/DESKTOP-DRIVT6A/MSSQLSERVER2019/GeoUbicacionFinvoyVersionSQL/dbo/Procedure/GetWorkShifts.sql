/****** Object:  Procedure [dbo].[GetWorkShifts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetWorkShifts]  
  @Ids [sys].[varchar](MAX) = NULL  
 ,@IncludeDeleted [sys].[bit] = 0  
AS  
BEGIN  
    SELECT  WS.[Id], WS.[Name], WS.[StartTime], WS.[EndTime], WS.[IdType], WS.[CreatedDate], WS.[Deleted], WS.[DeletedDate], WST.[Name] TypeName
    FROM    [dbo].[WorkShift] WS WITH (NOLOCK)  
		INNER JOIN [WorkShiftType] WST 
			ON WS.IdType = WST.Id
 WHERE ((@Ids IS NULL) OR (dbo.[CheckValueInList](WS.[Id], @Ids) = 1))  
   AND (@IncludeDeleted = 1 OR [Deleted] = 0)  
END
