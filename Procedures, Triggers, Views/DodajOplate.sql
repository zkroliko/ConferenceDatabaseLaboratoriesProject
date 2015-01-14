USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajOplate] 
@KonfID int,
@DataWplaty Date,
@kwota money



AS BEGIN
SET NOCOUNT ON; 

insert into Oplaty([Rezerwacja konferencji],[Data wplaty],Kwota)Values(@KonfID,@DataWplaty,@kwota)
END
