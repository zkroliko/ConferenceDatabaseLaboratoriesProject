USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajDzienKonf] 
@KonfID int,
@date Date

AS BEGIN
SET NOCOUNT ON; 

INSERT INTO [Dni Konferencji] (KonferencjaID,Data)Values(@KonfID,@date)
END
