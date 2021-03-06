USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[DodajRezerwacjeKonf]    Script Date: 2015-01-15 11:48:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[PodliczRezerwacja] 
@rezerwacjaID int



AS BEGIN
SET NOCOUNT ON; 
DECLARE @cenaKonf money
DECLARE @cenaWarsz money
Declare @warsztatID int
Declare @liczbaOsub int

set @cenaKonf=(select Normalne+Studenci from [Rezerwacje konferencji]where id=@rezerwacjaID)*(select [Cena za dzien] from Konferencje where id=(select KonferencjaID from [Dni Konferencji] where id=(select KonferencjaDzienId from [Rezerwacje konferencji]where id=@rezerwacjaID)))
Declare cursor1 cursor for select WarsztatID,[liczba miejsc] from [Rezerwacje warsztatow] where KonferencjaID=@rezerwacjaID 

open cursor1
FETCH NEXT FROM cursor1
into @warsztatID,@liczbaOsub
WHILE @@FETCH_STATUS = 0
begin
	set @cenaWarsz=@cenaWarsz+@liczbaOsub*(select Cena from Warsztaty)
	FETCH NEXT FROM cursor1
	into @warsztatID,@liczbaOsub
end
close cursor1;
DEALLOCATE cursor1;
select @cenaKonf+@cenaWarsz
END
