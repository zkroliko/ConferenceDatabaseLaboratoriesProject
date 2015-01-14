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
CREATE TRIGGER [dbo].[liczbaMiejscNaWarsztacie]
   ON  [dbo].[Rezerwacje warsztatow]
   AFTER INSERT,UPDATE
AS 

BEGIN
	SET NOCOUNT ON;
	DECLARE @warsztatId int = (select WarsztatID from inserted)
	DECLARE @liczbaM int = (SELECT [Liczba miejsc] FROM Warsztaty where id=@warsztatId)
    DECLARE @liczbaMiejscZajetych int = (select sum([liczba miejsc]) from [Rezerwacje warsztatow] where WarsztatID=@warsztatId)
   
    IF (@liczbaM -@liczbaMiejscZajetych < ( select [liczba miejsc] from inserted)) 
	BEGIN 
	DECLARE @message varchar(100) = 'For this workshop is only ' +CAST(@liczbaM -@liczbaMiejscZajetych as varchar(3))+'free' ;
	THROW 52000,@message,1
	 ROLLBACK TRANSACTION 
	 END

END
GO
