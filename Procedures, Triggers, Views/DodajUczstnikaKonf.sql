USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajUczestnikaKonf] 
@KlientID int,
@RezerwacjaKonfID int,
@OsobaID int



AS BEGIN
SET NOCOUNT ON; 

insert into [Uczestnicy konferencji](KlientID,RezerwacjaKonfID,OsobaID)Values(@KlientID,@RezerwacjaKonfID,@OsobaID)
END
