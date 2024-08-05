/****** Object:  Procedure [dbo].[SaveAnswerImageNotRelated]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/08/2018
-- Description:	SP para guardar el array de una imagen cuyo nombre no se relaciona a ninguna respuesta.
-- =============================================
CREATE PROCEDURE [dbo].[SaveAnswerImageNotRelated]

    @IdPersonOfInterest [sys].[int],
	@ImageName [sys].[varchar](100),
	@ImageArray [sys].[image],
	@ProductReport [sys].[bit] = 0,
	@TaskReport [sys].[bit] = 0,
	@OrderReport [sys].[bit] = 0,
	@ResultCode [sys].[int] OUTPUT
AS
BEGIN

	SET @ResultCode = 0
	DECLARE @IdQuestion int = NULL
	DECLARE @IdProduct int = NULL
	DECLARE @IdProductReportAttribute int = NULL
	DECLARE @IdOrderReportAttribute int = NULL
	DECLARE @IdPointOfInterest int = NULL
	DECLARE @Time_Date [sys].varchar(100) = NULL
	DECLARE @Time_Short [sys].varchar(6) = NULL
	DECLARE @DateTime [sys].varchar(100) = NULL
	DECLARE @Complete_DateTime datetime = NULL
	--imageFileName = FILE_PREFIX + questionId + "" + pointOfInterestId + "" + productId + "_" + timeStamp; productId es 0 para tareas
	IF @TaskReport = 1
	BEGIN

		CREATE TABLE #ImageName_Split(Id INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED, Text_Split [sys].[varchar](100))

		BEGIN TRY  

			INSERT INTO #ImageName_Split(Text_Split)
			SELECT value 
			FROM string_split(SUBSTRING(@ImageName, 1, LEN(@ImageName) - 4), '_')

			SET @IdQuestion = (select cast(Text_Split as int) from #ImageName_Split where Id = 2)
			SET @IdPointOfInterest = (select cast(Text_Split as int) from #ImageName_Split where Id = 3)
			SET @Time_Date = (select Text_Split from #ImageName_Split where Id = 6)
			SET @Time_Short = (SUBSTRING(@Time_Date, 1, 6)) 
			SET @DateTime = (select concat(Text_Split, @Time_Short) from #ImageName_Split where Id = 5)
			SET @Complete_DateTime = Tzdb.ToUtc(CONVERT(DATETIME, STUFF(STUFF(STUFF(@DateTime,13,0,':'),11,0,':'),9,0,' ')))

			declare @IdCompletedForm int = 0
			--REVISO SI HAY ALGUNA TAREA COMPLETADA CON LA RESPUESTA A LA PREGUNTA VACIA
			IF @IdPointOfInterest > 0
			BEGIN
				SET @IdCompletedForm = (SELECT TOP 1 [Id] FROM [dbo].[CompletedForm] CF with (nolock) 
									where CF.[IdPersonOfInterest] = @IdPersonOfInterest AND CF.[IdPointOfInterest] = @IdPointOfInterest 
									AND CF.[StartDate] <= @Complete_DateTime AND CF.[Date] >= @Complete_DateTime ORDER BY CF.[Date] desc)
			END
			ELSE
			--tAREAS GENERICAS
			BEGIN
				SET @IdCompletedForm = (SELECT TOP 1 [Id] FROM [dbo].[CompletedForm] CF with (nolock) 
									where CF.[IdPersonOfInterest] = @IdPersonOfInterest AND CF.[IdPointOfInterest] IS NULL
									AND CF.[StartDate] <= @Complete_DateTime AND CF.[Date] >= @Complete_DateTime ORDER BY CF.[Date] desc)
			END
			IF @IdCompletedForm IS NOT NULL
			BEGIN
				--Busco pregunta
				declare @IdAnswer int = 0
				--REVISO SI HAY ALGUNA TAREA COMPLETADA CON LA RESPUESTA A LA PREGUNTA VACIA
				SET @IdAnswer = (SELECT [Id] FROM [dbo].[Answer] A with (nolock) 
									where A.[IdQuestion] = @IdQuestion AND A.[IdCompletedForm] = @IdCompletedForm 
									AND (A.[ImageName] is null OR A.[ImageName] = ''))
				IF @IdAnswer IS NOT NULL
				BEGIN	
					UPDATE [dbo].[Answer]
					SET [ImageName] = @ImageName
					where [Id] = @IdAnswer
				END
				ELSE
				BEGIN
					SET @ResultCode = 1
				END
			END
			ELSE
			BEGIN
				SET @ResultCode = 1
			END

		END TRY  
		BEGIN CATCH  
			SET @ResultCode = 1
		END CATCH  
	
		IF @ResultCode = 1 --NO SE ENCONTRO RELACION EN ANSWER O COMPLETED FORM
		BEGIN
			INSERT INTO [dbo].[AnswerImageNotRelated]([IdPersonOfInterest], [ImageName], [ImageEncode], [ReceivedDate], [TaskReport], [ProductReport])
			VALUES		(@IdPersonOfInterest, @ImageName, @ImageArray, GETUTCDATE(), @TaskReport, @ProductReport)
		END

		drop table #ImageName_Split
	END
	ELSE
	BEGIN
		IF @ProductReport = 1
		BEGIN
			CREATE TABLE #ImageNamePR_Split(Id INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED, Text_Split [sys].[varchar](100))

			BEGIN TRY  

				INSERT INTO #ImageNamePR_Split(Text_Split)
				SELECT value 
				FROM string_split(SUBSTRING(@ImageName, 1, LEN(@ImageName) - 4), '_')

				SET @IdProductReportAttribute = (select cast(Text_Split as int) from #ImageNamePR_Split where Id = 2)
				SET @IdPointOfInterest = (select cast(Text_Split as int) from #ImageNamePR_Split where Id = 3)
				SET @IdProduct = (select cast(Text_Split as int) from #ImageNamePR_Split where Id = 4)
				SET @Time_Date = (select Text_Split from #ImageNamePR_Split where Id = 6)
				SET @Time_Short = (SUBSTRING(@Time_Date, 1, 6)) 
				SET @DateTime = (select concat(Text_Split, @Time_Short) from #ImageNamePR_Split where Id = 5)
				SET @Complete_DateTime = Tzdb.ToUtc(CONVERT(DATETIME, STUFF(STUFF(STUFF(@DateTime,13,0,':'),11,0,':'),9,0,' ')))

				declare @IdProductReportDynamic int = 0
				--REVISO SI HAY ALGUN reporte de sku COMPLETADO CON LA RESPUESTA A LA PREGUNTA VACIA
				SET @IdProductReportDynamic = (SELECT TOP 1 [Id] FROM [dbo].[ProductReportDynamic] PRD with (nolock) 
									where PRD.[IdPersonOfInterest] = @IdPersonOfInterest
									AND PRD.[IdProduct] = @IdProduct AND PRD.[ReportDateTime] >= DATEADD(MINUTE,-15, @Complete_DateTime)
									AND PRD.[ReportDateTime] <= DATEADD(MINUTE,15, @Complete_DateTime) ORDER BY PRD.[ReportDateTime] desc)
			
				IF @IdProductReportDynamic IS NOT NULL
				BEGIN
					--Busco pregunta
					declare @IdProductReportAttributeValue int = 0
					--REVISO SI HAY ALGUNA TAREA COMPLETADA CON LA RESPUESTA A LA PREGUNTA VACIA
					SET @IdProductReportAttributeValue = (SELECT [Id] FROM [dbo].[ProductReportAttributeValue] PRA with (nolock) 
										where PRA.[IdProductReportAttribute] = @IdProductReportAttribute AND PRA.[IdProductReport] = @IdProductReportDynamic 
										AND (PRA.[ImageName] is null OR PRA.[ImageName] = ''))
					IF @IdProductReportAttributeValue IS NOT NULL
					BEGIN	
						UPDATE [dbo].[ProductReportAttributeValue]
						SET [ImageName] = @ImageName
						where [Id] = @IdProductReportAttributeValue
					END
					ELSE
					BEGIN
						SET @ResultCode = 1
					END
				END
				ELSE
				BEGIN
					SET @ResultCode = 1
				END

			END TRY  
			BEGIN CATCH  
				SET @ResultCode = 1
			END CATCH  
	
			IF @ResultCode = 1 --NO SE ENCONTRO RELACION EN productreportdynamic O ProductReportAttirubteValue
			BEGIN
				INSERT INTO [dbo].[AnswerImageNotRelated]([IdPersonOfInterest], [ImageName], [ImageEncode], [ReceivedDate], [TaskReport], [ProductReport])
				VALUES		(@IdPersonOfInterest, @ImageName, @ImageArray, GETUTCDATE(), @TaskReport, @ProductReport)
			END

			drop table #ImageNamePR_Split
		END
		ELSE IF @OrderReport = 1
		BEGIN
			CREATE TABLE #ImageNameOR_Split(Id INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED, Text_Split [sys].[varchar](100))

			BEGIN TRY  

				INSERT INTO #ImageNameOR_Split(Text_Split)
				SELECT value 
				FROM string_split(SUBSTRING(@ImageName, 1, LEN(@ImageName) - 4), '_')

				SET @IdOrderReportAttribute = (select cast(Text_Split as int) from #ImageNameOR_Split where Id = 2)
				SET @IdPointOfInterest = (select cast(Text_Split as int) from #ImageNameOR_Split where Id = 3)
				SET @IdProduct = (select cast(Text_Split as int) from #ImageNameOR_Split where Id = 4)
				SET @Time_Date = (select Text_Split from #ImageNameOR_Split where Id = 6)
				SET @Time_Short = (SUBSTRING(@Time_Date, 1, 6)) 
				SET @DateTime = (select concat(Text_Split, @Time_Short) from #ImageNameOR_Split where Id = 5)
				SET @Complete_DateTime = Tzdb.ToUtc(CONVERT(DATETIME, STUFF(STUFF(STUFF(@DateTime,13,0,':'),11,0,':'),9,0,' ')))

				declare @IdOrderReport int = 0
				--REVISO SI HAY ALGUN reporte de pedidos COMPLETADO CON LA RESPUESTA A LA PREGUNTA VACIA
				SET @IdOrderReport = (SELECT TOP 1 [Id] FROM [dbo].[OrderReport] ORD with (nolock) 
									where ORD.[IdPersonOfInterest] = @IdPersonOfInterest AND ORD.[OrderDateTime] >= DATEADD(MINUTE,-15, @Complete_DateTime)
									AND ORD.[OrderDateTime] <= DATEADD(MINUTE,15, @Complete_DateTime) ORDER BY ORD.[OrderDateTime] desc)
			
				IF @IdOrderReport IS NOT NULL
				BEGIN
					--Busco pregunta
					declare @IdOrderReportAttributeValue int = 0
					--REVISO SI HAY ALGUN PEDIDO COMPLETADA CON LA RESPUESTA A LA PREGUNTA VACIA
					SET @IdOrderReportAttributeValue = (SELECT [Id] FROM [dbo].[OrderReportAttributeValue] ORA with (nolock) 
										where ORA.[IdOrderReportAttribute] = @IdOrderReportAttribute AND ORA.[IdOrderReport] = @IdOrderReport  
										AND ORA.[IdProduct] = @IdProduct AND (ORA.[ImageName] is null OR ORA.[ImageName] = ''))
					IF @IdOrderReportAttributeValue IS NOT NULL
					BEGIN	
						UPDATE [dbo].[OrderReportAttributeValue]
						SET [ImageName] = @ImageName
						where [Id] = @IdOrderReportAttributeValue
					END
					ELSE
					BEGIN
						SET @ResultCode = 1
					END
				END
				ELSE
				BEGIN
					SET @ResultCode = 1
				END

			END TRY  
			BEGIN CATCH  
				SET @ResultCode = 1
			END CATCH  
	
			IF @ResultCode = 1 --NO SE ENCONTRO RELACION EN orderreport O OrderAttributeValue
			BEGIN
				INSERT INTO [dbo].[AnswerImageNotRelated]([IdPersonOfInterest], [ImageName], [ImageEncode], [ReceivedDate], [TaskReport], [ProductReport], [OrderReport])
				VALUES		(@IdPersonOfInterest, @ImageName, @ImageArray, GETUTCDATE(), @TaskReport, @ProductReport, @OrderReport)
			END

			drop table #ImageNameOR_Split
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[AnswerImageNotRelated]([IdPersonOfInterest], [ImageName], [ImageEncode], [ReceivedDate], [TaskReport], [ProductReport], [OrderReport])
			VALUES		(@IdPersonOfInterest, @ImageName, @ImageArray, GETUTCDATE(), @TaskReport, @ProductReport, @OrderReport)
		END
	END
END
