/****** Object:  View [dbo].[PointOfInterestActivityDone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PointOfInterestActivityDone]
AS
	-- Tareas
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[StartDate] as ActionDate
	FROM		dbo.[CompletedForm] CF WITH (NOLOCK)

	UNION

	-- Stock
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[ReportDateTime] as ActionDate
	FROM		dbo.[ProductReportDynamic] CF WITH (NOLOCK)

	UNION

	-- Activos
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate
	FROM		dbo.[AssetReport] CF WITH (NOLOCK)

	UNION

	-- Observaciones
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[CreatedDate] as ActionDate
	FROM		dbo.[Incident] CF WITH (NOLOCK)

	UNION

	-- Documentos
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate
	FROM		dbo.[DocumentReport] CF WITH (NOLOCK)

	UNION

	-- Devoluciones
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate
	FROM		dbo.[ProductRefund] CF WITH (NOLOCK)

	UNION

	-- Faltantes
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate
	FROM		dbo.[ProductMissingPointOfInterest] CF WITH (NOLOCK)

	UNION

	-- foto antes y despues
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[ReportDate] as ActionDate
	FROM		dbo.[PhotoReport] CF WITH (NOLOCK)

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PointOfInterestActivityDone'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PointOfInterestActivityDone'
