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
CREATE TRIGGER [dbo].[DataWygasnienciaPoDacieRozpoczencia]
   ON  [dbo].Znizki
   AFTER INSERT,UPDATE
AS 

BEGIN
	
DECLARE @date date = (SELECT [Obowiazuje do] FROM inserted)
 DECLARE @confstartdate date = (select [Data Rozpoczecia] from Konferencje where id=(select KonferencjaID from inserted))
IF ((SELECT DATEDIFF(day,@Date,@confstartdate)) < 0)
BEGIN 
	;THROW 52000, 'This price stage expires after conference has started.',1 
	ROLLBACK TRANSACTION 
END
END
GO
