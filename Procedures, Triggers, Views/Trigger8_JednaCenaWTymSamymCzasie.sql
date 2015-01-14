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
CREATE TRIGGER [dbo].[JednaCenaWTymSamymCzasie]
   ON  [dbo].Znizki
   AFTER INSERT,UPDATE
AS 

BEGIN
Declare @id int = (select id from inserted)	
DECLARE @date date = (SELECT [Obowiazuje od] FROM inserted)
 DECLARE @confID int = (select KonferencjaID from inserted)
IF exists(SELECT id FROM Znizki WHERE ((id <> @Id)AND(@Date <[Obowiazuje do]) )AND(KonferencjaID=@confID)) 
BEGIN 
	;THROW 52000, 'There is already a price named for this conference day that expires at the same time.',1 
	ROLLBACK TRANSACTION 
END
END
GO
