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
CREATE TRIGGER [dbo].[DataKonferencjiWPrzysz³oœci]
   ON  [dbo].Konferencje
   AFTER INSERT,UPDATE
AS 

BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from 
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 DECLARE @Date date = (SELECT [Data Rozpoczecia] FROM inserted) 
	 IF((DATEDIFF(day,GETDATE(),@Date) <= 0)) 
	 BEGIN ;
		 THROW 52000,'The conference is starting today or has already started! You can only specify future conferences.',1 
		 ROLLBACK TRANSACTION 
	 END

END
GO
