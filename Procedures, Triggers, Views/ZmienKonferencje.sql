USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[ZmienKonferencje]    Script Date: 1/12/2015 8:25:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Zmienamy dane konferencji, nie mozna dac w ten sposob mniej miejsc
ALTER PROCEDURE [dbo].[ZmienKonferencje] 
@id int, --id procedury
@Nazwa varchar(80),
@Opis varchar(150),
@Startdate Date,
@EndDate Date,
@liczbaMiejsc int, 
@Cena money 
AS BEGIN
SET NOCOUNT ON; 
if (@liczbaMiejsc < (select [Liczba miejsc] from Konferencje where @id = id))
begin
update Konferencje
set [Nazwa Konferencji] = @Nazwa,
	[Opis konferencji] = @Opis,
	[Data Rozpoczecia]= @Startdate,
	[Data Zakonczenia] = @EndDate,
	[Liczba miejsc] = @liczbaMiejsc,
	[Cena za dzien] = @Cena
where @id = id
end
END
