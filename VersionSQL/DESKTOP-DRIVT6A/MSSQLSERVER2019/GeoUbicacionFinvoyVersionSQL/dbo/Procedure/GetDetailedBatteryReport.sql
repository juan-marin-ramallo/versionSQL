/****** Object:  Procedure [dbo].[GetDetailedBatteryReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 15/05/2015
-- Description:	SP para obtener la información necesaria para el reporte de bateria.
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailedBatteryReport]
(
	 @DateSelected [sys].[datetime]
	,@IntervalTime [sys].TIME = NULL
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	DECLARE
    @Id  AS INT,
	@IdPersonOfInterest INT,
	@Date DATETIME,
	@BatteryLevel DECIMAL(5,2),
	@PersonOfInterestName VARCHAR(50),
	@PersonOfInterestLastName VARCHAR(50),
	@PersonOfInterestIdDepartment INT,
	@Type CHAR,
	@PersonOfInterestDeleted BIT,
	@CurrentRow INT,
	@CurrentPersonOfInterestId INT

	DECLARE @DateFrom [sys].[datetime] = @DateSelected,
	@DateTo [sys].[datetime] = DATEADD(DAY, 1, @DateSelected),
	@IntervalTimeLocal [sys].TIME = @IntervalTime,
	@IdDepartmentsLocal [sys].[varchar](max) = @IdDepartments,
	@TypesLocal [sys].[varchar](max) = @Types,
	@IdPersonsOfInterestLocal [sys].[varchar](max) = @IdPersonsOfInterest,
	@IdUserLocal [sys].[INT] = @IdUser

	CREATE TABLE #TempResult
    ( 
        Id  INT NOT NULL,
		IdPersonOfInterest INT,
		Date DATETIME,
		BatteryLevel DECIMAL(5,2),
		PersonOfInterestName VARCHAR(50),
		PersonOfInterestLastName VARCHAR(50),
		PersonOfInterestIdDepartment INT,
		Type CHAR,
		PersonOfInterestDeleted BIT
    );

	SET @CurrentRow = 0;
	SET @CurrentPersonOfInterestId = 0 --Para inicializarlo
	
	
	DECLARE cur CURSOR FOR SELECT Id, IdPersonOfInterest, LR.[Date], BatteryLevel,
	PersonOfInterestName, PersonOfInterestLastName,PersonOfInterestIdDepartment, Type
	, PersonOfInterestDeleted FROM LocationReport LR
	WHERE LR.[Date] BETWEEN @DateFrom AND @DateTo
	AND 
	((@IdDepartmentsLocal IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @IdDepartmentsLocal) = 1)) AND
	((@TypesLocal IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @TypesLocal) = 1)) AND
	((@IdPersonsOfInterestLocal IS NULL) OR (dbo.CheckValueInList(LR.[IdPersonOfInterest], @IdPersonsOfInterestLocal) = 1)) AND
	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @IdUserLocal) = 1)) AND				
	((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(LR.[IdPersonOfInterest], @IdUserLocal) = 1))
	ORDER BY LR.IdPersonOfInterest, LR.[Date] ASC
    
	OPEN cur

	FETCH NEXT FROM cur INTO @Id, @IdPersonOfInterest, @Date, @BatteryLevel,
	@PersonOfInterestName, @PersonOfInterestLastName,@PersonOfInterestIdDepartment, @Type, @PersonOfInterestDeleted

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF @CurrentRow = 0 OR @CurrentPersonOfInterestId <> @IdPersonOfInterest
		BEGIN
			SET @CurrentPersonOfInterestId = @IdPersonOfInterest
			INSERT INTO #TempResult
						( Id ,
							IdPersonOfInterest ,
							Date ,
							BatteryLevel ,
							PersonOfInterestName ,
							PersonOfInterestLastName ,
							PersonOfInterestIdDepartment ,
							Type,
							PersonOfInterestDeleted
						)
				VALUES(@CurrentRow, @IdPersonOfInterest, @Date, @BatteryLevel,
				@PersonOfInterestName, @PersonOfInterestLastName,@PersonOfInterestIdDepartment, @Type, @PersonOfInterestDeleted)

			SET @CurrentPersonOfInterestId = @IdPersonOfInterest
		END 
		ELSE
		BEGIN
			IF @Date >= (SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, 0, T.Date), CONVERT(VARCHAR(12),@IntervalTimeLocal,113))
						FROM #TempResult T
						WHERE t.Id = (SELECT MAX(Id) FROM #TempResult))
			BEGIN
				INSERT INTO #TempResult
						( Id ,
							IdPersonOfInterest ,
							Date ,
							BatteryLevel ,
							PersonOfInterestName ,
							PersonOfInterestLastName ,
							PersonOfInterestIdDepartment ,
							Type ,
							PersonOfInterestDeleted
						)
				VALUES(@CurrentRow, @IdPersonOfInterest, @Date, @BatteryLevel,
				@PersonOfInterestName, @PersonOfInterestLastName,@PersonOfInterestIdDepartment, @Type,@PersonOfInterestDeleted)
			END
		END		
	SET @CurrentRow = @CurrentRow + 1;
	FETCH NEXT FROM cur INTO @Id, @IdPersonOfInterest, @Date, @BatteryLevel,
	@PersonOfInterestName, @PersonOfInterestLastName,@PersonOfInterestIdDepartment, @Type,@PersonOfInterestDeleted
	END

	CLOSE cur    
	DEALLOCATE cur
	        
	SELECT TR.[Id], TR.[IdPersonOfInterest], TR.[Date], TR.[BatteryLevel],
		   TR.[PersonOfInterestName], TR.[PersonOfInterestLastName],TR.[PersonOfInterestIdDepartment], TR.[Type]
		   , TR.[PersonOfInterestDeleted]
	FROM #TempResult TR
	ORDER BY	TR.[IdPersonOfInterest], TR.[Date] ASC;

	--DROP TABLE temp;
	DROP TABLE #TempResult;
END
