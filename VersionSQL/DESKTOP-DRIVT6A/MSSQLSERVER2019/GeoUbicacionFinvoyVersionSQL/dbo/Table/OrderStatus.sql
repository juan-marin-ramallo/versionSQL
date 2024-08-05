/****** Object:  Table [dbo].[OrderStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Abbreviation] [varchar](3) NOT NULL,
	[IsFinal] [bit] NOT NULL,
	[IsInitial] [bit] NOT NULL,
	[CanEdit] [bit] NOT NULL,
	[CanEditPrice] [bit] NOT NULL,
	[Disabled] [bit] NOT NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderStatus] ADD  CONSTRAINT [DF__OrderStat__CanEd__04E65333]  DEFAULT ((0)) FOR [CanEditPrice]
ALTER TABLE [dbo].[OrderStatus] ADD  CONSTRAINT [DF__OrderStat__Disab__06CE9BA5]  DEFAULT ((0)) FOR [Disabled]
