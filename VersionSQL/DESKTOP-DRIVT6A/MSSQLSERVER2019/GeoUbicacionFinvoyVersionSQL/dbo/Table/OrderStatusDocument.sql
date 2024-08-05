/****** Object:  Table [dbo].[OrderStatusDocument]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderStatusDocument](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdStatus] [int] NOT NULL,
	[IdType] [int] NOT NULL,
 CONSTRAINT [PK_OrderStatusDocument] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
