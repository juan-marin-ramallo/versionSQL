/****** Object:  View [dbo].[ProductInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[ProductInfo]
AS
SELECT     TOP (100) PERCENT P.Id, P.Identifier AS ProductIdentifier, P.Name AS ProductName, P.Indispensable AS ProductIndispensable, P.BarCode AS ProductBarCode, PC.Id AS ProductCategoryId, PC.Name AS ProductCategoryName, PB.Id AS BrandId, 
                  PB.Identifier AS BrandIdentifier, PB.Name AS BrandName, C.Id AS CompanyId, C.Identifier AS CompanyIdentifier, C.Name AS CompanyName, P.MinSalesQuantity AS ProductMinSalesQuantity, P.MinUnitsPackage AS ProductMinUnitsPackage, 
                  P.MaxSalesQuantity AS ProductMaxSalesQuantity, P.InStock AS ProductInStock, P.Column_1, P.Column_2, P.Column_3, P.Column_4, P.Column_5, P.Column_6, P.Column_7, P.Column_8, P.Column_9, P.Column_10, P.Column_11, P.Column_12, P.Column_13, 
                  P.Column_14, P.Column_15, P.Column_16, P.Column_17, P.Column_18, P.Column_19, P.Column_20, P.Column_21, P.Column_22, P.Column_23, P.Column_24, P.Column_25, PCL.Id AS ProductCategoryListId
FROM        dbo.Product AS P WITH (NOLOCK) LEFT OUTER JOIN
                  dbo.ProductBrand AS PB WITH (NOLOCK) ON P.IdProductBrand = PB.Id LEFT OUTER JOIN
                  dbo.Company AS C WITH (NOLOCK) ON PB.IdCompany = C.Id LEFT OUTER JOIN
                  dbo.ProductCategoryList AS PCL WITH (NOLOCK) ON PCL.IdProduct = P.Id LEFT OUTER JOIN
                  dbo.ProductCategory AS PC WITH (NOLOCK) ON PCL.IdProductCategory = PC.Id

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
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 35
         End
         Begin Table = "PB"
            Begin Extent = 
               Top = 6
               Left = 456
               Bottom = 136
               Right = 626
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PCL"
            Begin Extent = 
               Top = 6
               Left = 872
               Bottom = 119
               Right = 1061
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PC"
            Begin Extent = 
               Top = 6
               Left = 664
               Bottom = 136
               Right = 834
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
         Alias = 3996
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ProductInfo'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ProductInfo'
