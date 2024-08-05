/****** Object:  Table [dbo].[OrderNextStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderNextStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdStatus] [int] NOT NULL,
	[IdNextStatus] [int] NOT NULL,
 CONSTRAINT [PK_OrderNextStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderNextStatus]  WITH CHECK ADD  CONSTRAINT [FK_OrderNextStatus_OrderStatus_Current] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[OrderStatus] ([Id])
ALTER TABLE [dbo].[OrderNextStatus] CHECK CONSTRAINT [FK_OrderNextStatus_OrderStatus_Current]
ALTER TABLE [dbo].[OrderNextStatus]  WITH CHECK ADD  CONSTRAINT [FK_OrderNextStatus_OrderStatus_Next] FOREIGN KEY([IdNextStatus])
REFERENCES [dbo].[OrderStatus] ([Id])
ALTER TABLE [dbo].[OrderNextStatus] CHECK CONSTRAINT [FK_OrderNextStatus_OrderStatus_Next]
