USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajWarsztat] 
@nazwa varchar (80),
@liczbaMiejsc int,
@cena money



AS BEGIN
SET NOCOUNT ON; 

insert into Warsztaty([Nazwa warsztatu],[Liczba miejsc],Cena)Values(@nazwa,@liczbaMiejsc,@cena)
END
