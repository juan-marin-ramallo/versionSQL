/****** Object:  Procedure [dbo].[ExistsMarksReport]    Committed by VersionSQL https://www.versionsql.com ******/

--use [GeoUbicacionGU144]


CREATE PROCEDURE [dbo].[ExistsMarksReport]        
(  
 @Id     [sys].[int]     
 ,@EntryDate   [sys].[datetime]        
 ,@ExitDate    [sys].[datetime]  = NULL      
 ,@IdPersonOfInterest [sys].[int]    
 ,@Exists    [sys].[BIT] OUTPUT    
)        
AS        
BEGIN       
   
 WITH RankedMarks AS (  
  SELECT  
   ML.IdEntry,  
   ML.EntryDate,  
   ML.ExitDate,  
   M.IdPersonOfInterest,  
   --M.,  
   ROW_NUMBER() OVER (PARTITION BY ML.IdEntry ORDER BY ML.Date DESC) AS RowNum  
  FROM  
   dbo.MarkLog ML  
  INNER JOIN dbo.Mark M   
   ON M.Id = ML.IdEntry  
   AND M.IdPersonOfInterest =  @IdPersonOfInterest  
  WHERE  
   CONVERT(DATE, ML.EntryDate) = CONVERT(DATE, @EntryDate)  
 )  
 SELECT  
  *  
  INTO #MarksLogInTheDate  
 FROM  
  RankedMarks  
 WHERE  
  RowNum = 1;  
   
 IF (@Id > 0)  
 BEGIN  
  SET @Exists= ISNULL((SELECT TOP 1 1  Exist    
       FROM  #MarksLogInTheDate ML  
       WHERE ((@EntryDate >= ML.EntryDate AND (ML.ExitDate IS NULL OR @EntryDate <= ML.ExitDate))  
         OR (@ExitDate IS NULL and @EntryDate< ML.EntryDate) 
         OR (@ExitDate >= ML.EntryDate AND (ML.ExitDate IS NULL OR @ExitDate <= ML.ExitDate )))  
         AND IdEntry != @Id),0)    
 END  
 ELSE  
 BEGIN   
  SET @Exists= ISNULL((SELECT TOP 1 1  Exist    
       FROM  #MarksLogInTheDate ML  
       WHERE ((@EntryDate >= ML.EntryDate AND (ML.ExitDate IS NULL OR @EntryDate <= ML.ExitDate))  
         OR ((@ExitDate IS NULL and @EntryDate< ML.EntryDate) 
		 OR @ExitDate >= ML.EntryDate AND (ML.ExitDate IS NULL OR @ExitDate <= ML.ExitDate )))  
         ),0)    
 END  
  
 DROP TABLE #MarksLogInTheDate  
END
