/****** Object:  Table [dbo].[PowerBIConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerBIConfiguration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [varchar](100) NOT NULL,
	[WorkspaceId] [varchar](100) NOT NULL,
	[AuthenticationType] [varchar](50) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[ApplicationSecret] [varchar](100) NULL,
	[Tenant] [varchar](100) NULL,
 CONSTRAINT [PK_PowerBIConfiguration_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
