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
CREATE TRIGGER [dbo].[GodzinaRozpoczenciaPrzedGodzZakonczenia]
   ON  [dbo].[Dni warsztatu]
   AFTER INSERT,UPDATE
AS 

BEGIN
	
DECLARE @start time(0) = (SELECT [Godzina rozpoczecia] FROM inserted)
 DECLARE @end time(0) = (SELECT [Godzina zakonczenia] FROM inserted)
  IF((SELECT DATEDIFF(minute,@start,@end))<5) 
  BEGIN ;
	THROW 52000,'Workshop has to last at least 5 minutes.',1 
	ROLLBACK TRANSACTION
  END

END
GO
