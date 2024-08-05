/****** Object:  Table [dbo].[CustomerValidation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomerValidation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlockedWeb] [bit] NULL,
	[BlockedMobile] [bit] NULL,
 CONSTRAINT [PK_CustomerValidation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
