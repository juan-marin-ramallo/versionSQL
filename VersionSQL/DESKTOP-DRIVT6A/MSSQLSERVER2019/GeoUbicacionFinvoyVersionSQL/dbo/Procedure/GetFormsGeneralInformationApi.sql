/****** Object:  Procedure [dbo].[GetFormsGeneralInformationApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 18/12/2020
-- Description:	SP para obtener la informacion general de tareas para la api
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsGeneralInformationApi]

	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IncludeDeleted [sys].[bit] = NULL
AS
BEGIN
	
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	SELECT		F.[Id], F.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date], F.[Deleted], F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory],
				FC.[Name] AS FormCategoryName, F.[IdFormType], PT.[Name] AS FormTypeName, F.[AllPointOfInterest],
				F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[Description], F.[OneTimeAnswer],
				F.[IsWeighted], F.[AllowWebComplete], F.[CompleteMultipleTimes], F.[IdCompany], F.[EditedDate], C.[Name] AS CompanyName,
				Q.[Id] AS IdQuestion, Q.[Text] AS QuestionText, Q.[DefaultAnswerText] AS QuestionDefaultAnswerText,
				Q.[Required] AS QuestionIsRequired, Q.Hint AS QuestionHint, Q.[Weight] AS QuestionWeight, Q.[Type] AS QuestionType
	
	FROM		[dbo].[Form] F WITH (NOLOCK) 
				LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				LEFT JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]
				LEFT JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = F.[IdCompany]
				LEFT JOIN [dbo].[Question] Q WITH (NOLOCK) ON F.[Id] = Q.[IdForm]

	WHERE		((@IncludeDeleted IS NULL) OR F.[Deleted] = 0) AND
				((F.[Date] BETWEEN @DateFrom AND @DateTo) OR (F.[EditedDate] BETWEEN @DateFrom AND @DateTo))
				
	
	GROUP BY	F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[Description], F.[OneTimeAnswer],
				F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], FC.[Name], F.[IdFormType], PT.[Name],
				F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[IsWeighted], F.[AllowWebComplete],
				F.[CompleteMultipleTimes], F.[IdCompany], F.[EditedDate], C.[Name],Q.[Id], Q.[Text], Q.[DefaultAnswerText],
				Q.[Required], Q.Hint, Q.[Weight], Q.[Type]
	
	ORDER BY	F.[Id], F.[Date] desc

END
