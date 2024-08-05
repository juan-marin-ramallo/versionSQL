/****** Object:  View [dbo].[PointOfInterestInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PointOfInterestInfo]
AS
SELECT        POI.Id AS PointOfInterestId, POI.Name AS PointOfInterestName, POI.Identifier AS PointOfInterestIdentifier, POI.Address AS PointOfInterestAddress, D.Id AS IdDepartment, D.Name AS DepartmentName, 
                         POIH1.Id AS POIHierarchyLevel1Id, POIH1.Name AS POIHierarchyLevel1Name, POIH1.SapId AS POIHierarchyLevel1SapId, POIH2.Id AS POIHierarchyLevel2Id, POIH2.Name AS POIHierarchyLevel2Name, 
                         POIH2.SapId AS POIHierarchyLevel2SapId, CAT.Name AS CustomAttributeName, CAT.Id AS CustomAttributeId, CAT.IdValueType AS CustomAttributeValueType, ISNULL(CAO.Text, CAV.Value) AS CustomAttributeValue, 
                         CAV.IdCustomAttributeOption AS IdCustomAttributeOption, POI.ContactName AS PointOfInterestContactName, POI.ContactPhoneNumber AS PointOfInterestContactPhoneNumber
FROM            dbo.PointOfInterest AS POI LEFT OUTER JOIN
                         dbo.Department AS D WITH (NOLOCK) ON D.Id = POI.IdDepartment LEFT OUTER JOIN
                         dbo.POIHierarchyLevel1 AS POIH1 WITH (NOLOCK) ON POIH1.Id = POI.GrandfatherId LEFT OUTER JOIN
                         dbo.POIHierarchyLevel2 AS POIH2 WITH (NOLOCK) ON POIH2.Id = POI.FatherId LEFT OUTER JOIN
                         dbo.CustomAttributeValue AS CAV WITH (NOLOCK) ON CAV.IdPointOfInterest = POI.Id LEFT OUTER JOIN
                         dbo.CustomAttributeTranslated AS CAT WITH (NOLOCK) ON CAV.IdCustomAttribute = CAT.Id AND CAT.Deleted = 0 LEFT OUTER JOIN
                         dbo.CustomAttributeOption AS CAO WITH (NOLOCK) ON CAV.IdCustomAttributeOption = CAO.Id AND CAO.Deleted = 0
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[18] 2[20] 3) )"
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
         Begin Table = "POI"
            Begin Extent = 
               Top = 6
               Left = 1109
               Bottom = 136
               Right = 1325
            End
            DisplayFlags = 280
            TopColumn = 21
         End
         Begin Table = "D"
            Begin Extent = 
               Top = 6
               Left = 472
               Bottom = 136
               Right = 642
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "POIH1"
            Begin Extent = 
               Top = 6
               Left = 680
               Bottom = 136
               Right = 850
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "POIH2"
            Begin Extent = 
               Top = 6
               Left = 888
               Bottom = 136
               Right = 1071
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAV"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "CAO"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
  ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PointOfInterestInfo'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'       End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3780
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PointOfInterestInfo'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PointOfInterestInfo'
