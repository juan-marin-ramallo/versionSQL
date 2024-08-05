/****** Object:  Table [dbo].[DepartmentLocation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DepartmentLocation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[IdDepartment] [int] NULL,
 CONSTRAINT [PK_DepartmentLocation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DepartmentLocation]  WITH CHECK ADD  CONSTRAINT [FK_DepartmentLocation_Department] FOREIGN KEY([IdDepartment])
REFERENCES [dbo].[Department] ([Id])
ALTER TABLE [dbo].[DepartmentLocation] CHECK CONSTRAINT [FK_DepartmentLocation_Department]
