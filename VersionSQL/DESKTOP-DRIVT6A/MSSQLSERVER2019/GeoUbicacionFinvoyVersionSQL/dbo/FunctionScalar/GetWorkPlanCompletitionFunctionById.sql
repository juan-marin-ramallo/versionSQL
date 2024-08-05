/****** Object:  ScalarFunction [dbo].[GetWorkPlanCompletitionFunctionById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 23/08/2016
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetWorkPlanCompletitionFunctionById]
    (
      @IdPlan [sys].[int]
    )

	returns [sys].numeric

AS
    BEGIN
		DECLARE @Result [sys].numeric
		DECLARE @Comp [sys].numeric
		DECLARE @Total [sys].numeric
		SET @Result = 0
       
	   (select @Comp = sum(cast(ap.Completed AS INT)), @Total = count(1) 
	   from dbo.WorkActivityPlanned ap
	   inner join dbo.WorkPlan wp on wp.Id = ap.WorkPlanId 
	   where wp.Id = @IdPlan)
	    
		if(@Total>0)
		begin
			SET @Result = round(((@Comp/@Total)*100),0)
		end

        return @Result
    END;
