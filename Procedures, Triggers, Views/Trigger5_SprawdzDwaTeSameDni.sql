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
CREATE TRIGGER [dbo].[SprawdzDwaTeSmeDni]
   ON  [dbo].[Dni Konferencji]
   AFTER INSERT,UPDATE
AS 

BEGIN
	
DECLARE @confID int = (select KonferencjaID from inserted)
DECLARE @date date = (select Data from inserted)
IF ((SELECT COUNT(id) FROM [Dni Konferencji] WHERE (Data = @date) AND (KonferencjaID = @confID) ) > 1) 
BEGIN 
	DECLARE @message varchar(100) = 'Day has already been added for this conference' ;
	THROW 52000,@message,1 
	ROLLBACK TRANSACTION
 END

END
GO
