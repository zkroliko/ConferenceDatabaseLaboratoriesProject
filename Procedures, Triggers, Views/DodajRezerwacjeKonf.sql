USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajRezerwacjeKonf] 
@KlientID int,
@KonfID int,
@DataRezerwacji Date,
@Studenci int,
@Normalne int


AS BEGIN
SET NOCOUNT ON; 

insert into [Rezerwacje konferencji] (KlientID,KonferencjaDzienId,[Data rezerwacji],Studenci,Normalne)Values(@KlientID,@KonfID,@DataRezerwacji,@Studenci,@Normalne)
END
