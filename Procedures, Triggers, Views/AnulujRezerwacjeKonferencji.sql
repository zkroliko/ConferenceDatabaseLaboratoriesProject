USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[AnulujRezerwacjeKonferencji] 
@KonfID int

AS BEGIN
SET NOCOUNT ON; 
update [Rezerwacje konferencji] set anulowano=1 where id=@KonfID

END
