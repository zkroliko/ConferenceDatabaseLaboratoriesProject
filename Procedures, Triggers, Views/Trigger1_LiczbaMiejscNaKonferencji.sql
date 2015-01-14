-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJ
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[liczbaMiejscNaKonferencji]
   ON  [dbo].[Rezerwacje konferencji]
   AFTER INSERT,UPDATE
AS 

BEGIN
	SET NOCOUNT ON;
	DECLARE @ConferenceId int = (SELECT dk.KonferencjaID FROM [Dni Konferencji] as dk where  (select KonferencjaDzienId from inserted)=dk.id )
	DECLARE @liczbaM int = (SELECT [Liczba miejsc] FROM Konferencje where id=@ConferenceId)
    DECLARE @liczbaMiejscZajetych int = (SELECT sum(Studenci+Normalne) FROM [Rezerwacje konferencji] where KonferencjaDzienId=(select KonferencjaDzienId from inserted))
   
    IF (@liczbaM -@liczbaMiejscZajetych < ( select Studenci +Normalne from inserted)) 
	BEGIN 
	DECLARE @message varchar(100) = 'For this conference is only ' +CAST(@liczbaM -@liczbaMiejscZajetych as varchar(3))+'free' ;
	THROW 52000,@message,1
	 ROLLBACK TRANSACTION 
	 END

END
GO
