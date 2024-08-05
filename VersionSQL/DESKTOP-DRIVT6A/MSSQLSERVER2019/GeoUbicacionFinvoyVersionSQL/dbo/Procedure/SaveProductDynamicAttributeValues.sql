/****** Object:  Procedure [dbo].[SaveProductDynamicAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveProductDynamicAttributeValues]
    @Result [sys].[int] OUTPUT,
	@Id INT,
	@Column_1 VARCHAR(100) = NULL,
	@Column_2 VARCHAR(100) = NULL,
	@Column_3 VARCHAR(100) = NULL,
	@Column_4 VARCHAR(100) = NULL,
	@Column_5 VARCHAR(100) = NULL,
	@Column_6 VARCHAR(100) = NULL,
	@Column_7 VARCHAR(100) = NULL,
	@Column_8 VARCHAR(100) = NULL,
	@Column_9 VARCHAR(100) = NULL,
	@Column_10 VARCHAR(100) = NULL,
	@Column_11 VARCHAR(100) = NULL,
	@Column_12 VARCHAR(100) = NULL,
	@Column_13 VARCHAR(100) = NULL,
	@Column_14 VARCHAR(100) = NULL,
	@Column_15 VARCHAR(100) = NULL,
	@Column_16 VARCHAR(100) = NULL,
	@Column_17 VARCHAR(100) = NULL,
	@Column_18 VARCHAR(100) = NULL,
	@Column_19 VARCHAR(100) = NULL,
	@Column_20 VARCHAR(100) = NULL,
	@Column_21 VARCHAR(100) = NULL,
	@Column_22 VARCHAR(100) = NULL,
	@Column_23 VARCHAR(100) = NULL,
	@Column_24 VARCHAR(100) = NULL,
	@Column_25 VARCHAR(100) = NULL
AS 
BEGIN

    SET NOCOUNT ON;
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	UPDATE	[dbo].[Product]			
	SET		[Column_1] = @Column_1, [Column_2] = @Column_2, [Column_3] = @Column_3,[Column_4] = @Column_4,[Column_5] = @Column_5,[Column_6] = @Column_6,[Column_7] = @Column_7,[Column_8] = @Column_8,
			[Column_9] = @Column_9, [Column_10] = @Column_10, [Column_11] = @Column_11,[Column_12] = @Column_12,[Column_13] = @Column_13,[Column_14] = @Column_14,[Column_15] = @Column_15,
			[Column_16] = @Column_16,[Column_17] = @Column_17, [Column_18] = @Column_18,[Column_19] = @Column_19,[Column_20] = @Column_20,[Column_21] = @Column_21,[Column_22] = @Column_22,
			[Column_23] = @Column_23,[Column_24] = @Column_24,[Column_25] = @Column_25
	WHERE	[Id] = @Id
	
	SET @Result = 0

			
	--Actualizo log para que se reflejen los cambios en el celular
	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now

	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], @Now
	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK)
	WHERE	POI.[Deleted] = 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi WITH (NOLOCK)
							WHERE prpoi.[IdPointOfInterest] = poi.[Id])

END
