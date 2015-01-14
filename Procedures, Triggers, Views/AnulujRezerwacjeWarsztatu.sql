USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[DodajRezerwacjeWarsztatu]    Script Date: 2015-01-14 14:56:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[AnulujRezerwacjeWarsztatu] 
@WarsztatID int

AS BEGIN
SET NOCOUNT ON; 
update [Rezerwacje warsztatow] set anulowano=1 where id=@WarsztatID

END
