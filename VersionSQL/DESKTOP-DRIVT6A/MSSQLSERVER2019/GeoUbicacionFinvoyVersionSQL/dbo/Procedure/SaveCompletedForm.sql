/****** Object:  Procedure [dbo].[SaveCompletedForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  Diego Cáceres    
-- Create date: 06/10/2014    
-- Description: SP para guardar una formulario completo    
-- =============================================    
CREATE PROCEDURE  [dbo].[SaveCompletedForm]    
 @Id [sys].[int] OUTPUT,    
 @IdForm [sys].[int],    
 @IdPointOfInterest [sys].[int] = NULL,    
 @Latitude [sys].[decimal](25,20) = NULL,    
 @Longitude [sys].[decimal](25,20) = NULL,    
 @InitLatitude [sys].[decimal](25,20) = NULL,    
 @InitLongitude [sys].[decimal](25,20) = NULL,    
 @IdPersonOfInterest [sys].[int],    
 @ReceivedDate [sys].[datetime],    
 @CreatedDate [sys].[datetime],    
 @CompletedDate [sys].[datetime],    
 @IdProduct [sys].[int] = NULL,    
 @Result [sys].[int] OUTPUT,    
 @IdDynamic [sys].[int] = 0  
    
AS    
BEGIN    
    
 --Verifico que el formulario si es de "Unica vez" ya no esté completado     
 SET @Result = 0    
 IF EXISTS (SELECT 1     
    FROM [dbo].[CompletedForm] CF WITH (NOLOCK)    
    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = CF.[IdForm]    
    WHERE CF.[IdForm] = @IdForm AND F.[OneTimeAnswer] = 1 AND CF.[IdPointOfInterest] = @IdPointOfInterest)    
 BEGIN     
  SET @Result = 6     
 END      
 ELSE    
 BEGIN      
  DECLARE @LatLong [sys].[GEOGRAPHY] = IIF(@Latitude IS NULL OR @Longitude IS NULL, NULL, GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326))    
      
  IF @IdPointOfInterest IS NOT NULL AND EXISTS (SELECT 1 FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 43 AND [Value] = 0)    
  BEGIN    
    
   --Tomo las coordenadas del punto como inicio para evitar errores. Esto porque si o si tiene que haber empezado la tarea en el punto    
   SELECT @InitLatitude = [Latitude],    
     @InitLongitude = [Longitude]    
   FROM [dbo].[PointOfInterest] WITH (NOLOCK)    
   WHERE [Id] = @IdPointOfInterest    
    
   -- Las coordenadas de fin puede que sean otras diferentes al punto ya que quizás se envio desde borradores en cualquier otra ubicación. Por eso solo tomo las del punto si llegaran NULL    
   -- para que no queden vacias    
   IF @Latitude IS NULL AND @Longitude IS NULL    
   BEGIN    
    SELECT @Latitude = [Latitude],    
      @Longitude = [Longitude]    
    FROM [dbo].[PointOfInterest] WITH (NOLOCK)    
    WHERE [Id] = @IdPointOfInterest    
   END    
    
   --SET @Latitude = NULL    
   --SET @Longitude = NULL    
   --SET @InitLatitude = NULL    
   --SET @InitLongitude = NULL    
   SET @LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)    
  END    
    
  IF NOT EXISTS (SELECT 1 FROM [dbo].[CompletedForm] WITH (NOLOCK) WHERE [IdForm] = @IdForm     
      AND (([IdPointOfInterest] IS NULL AND @IdPointOfInterest IS NULL) OR ([IdPointOfInterest] = @IdPointOfInterest))    
      AND [IdPersonOfInterest] = @IdPersonOfInterest    
      --AND [Date] = @CompletedDate     
      AND [StartDate] = @CreatedDate)    
  BEGIN    
    
   INSERT INTO [dbo].[CompletedForm]([IdForm], [IdPointOfInterest], [Latitude],     
      [Longitude], [LatLong], [IdPersonOfInterest], [Date], [ReceivedDate], [StartDate],     
      [InitLatitude], [InitLongitude], [IdProduct])    
   VALUES  (@IdForm, @IdPointOfInterest, @Latitude, @Longitude, @LatLong, @IdPersonOfInterest,     
      @CompletedDate, @ReceivedDate, @CreatedDate, @InitLatitude, @InitLongitude, @IdProduct)    
     
   SELECT @Id = SCOPE_IDENTITY()    
       
   IF @IdPointOfInterest IS NOT NULL    
   BEGIN    
    EXEC [dbo].[SavePointsOfInterestActivity]    
      @IdPersonOfInterest = @IdPersonOfInterest    
      ,@IdPointOfInterest = @IdPointOfInterest    
      ,@DateIn = @CompletedDate    
      ,@AutomaticValue = 3    
   END    
  
   IF @IdDynamic > 0    
   BEGIN    
    DECLARE @IdDynamicCompletedForm INT;    
    INSERT INTO [dbo].[DynamicCompletedForm] VALUES(@Id, @IdDynamic)    
    SELECT @IdDynamicCompletedForm = SCOPE_IDENTITY()    
  
    INSERT INTO [dbo].[DynamicReferenceCompletedForm]    
    SELECT @IdDynamicCompletedForm, drv.[IdDynamicReference], drv.[Id]    
    FROM [dbo].[DynamicReference] dr (NOLOCK)    
    INNER JOIN [dbo].[DynamicProductPointOfInterest] dppi on dr.IdDynamic = dppi.IdDynamic    
    INNER JOIN [dbo].[DynamicReferenceValue] drv (NOLOCK) ON drv.[IdDynamicReference] = dr.[Id] AND drv.[IdDynamicProductPointOfInterest] = dppi.[Id]    
    WHERE dppi.[IdDynamic] = @IdDynamic AND dppi.[IdPointOfInterest] = @IdPointOfInterest AND dppi.[IdProduct] = @IdProduct    
   END    
    
  END    
  ELSE    
  BEGIN    
   SET @Result = 300 --YA EXISTE EL FORM, SE ESTA GUARDANDO REPETIDO Y NO LO QUIERO DUPLICAR    
  END    
 END    
END
