USE [Konferencje]
GO
/****** Object:  UserDefinedFunction [dbo].[PodliczRezerwacjafun]    Script Date: 2015-01-18 10:26:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[PodliczRezerwacjafun]
(
@rezerwacjaID int

)
RETURNS money
AS
BEGIN
	DECLARE @cenaKonf money
DECLARE @cenaWarsz money
Declare @warsztatID int
Declare @liczbaOsub int

set @cenaKonf=(1-isnull((select Znizka from znizki where 
[Obowiazuje od]<(select [Data rezerwacji] from [Rezerwacje konferencji] where id=@rezerwacjaID) 
and [Obowiazuje do]>(select [Data rezerwacji] from [Rezerwacje konferencji] where id=@rezerwacjaID) and KonferencjaID=(select KonferencjaID from [Dni Konferencji] where id=
(select KonferencjaDzienId from [Rezerwacje konferencji]where id=@rezerwacjaID))),0))
*(select Normalne+Studenci from [Rezerwacje konferencji]where id=@rezerwacjaID)*
(select [Cena za dzien] from Konferencje where id=(select KonferencjaID from [Dni Konferencji] where id=
(select KonferencjaDzienId from [Rezerwacje konferencji]where id=@rezerwacjaID)))

Declare cursor1 cursor for select WarsztatID,[liczba miejsc] from [Rezerwacje warsztatow] where KonferencjaID=@rezerwacjaID 

open cursor1
FETCH NEXT FROM cursor1
into @warsztatID,@liczbaOsub
WHILE @@FETCH_STATUS = 0
begin
	set @cenaWarsz=isnull(@cenaWarsz,0)+isnull(@liczbaOsub,0)*isnull((select Cena from Warsztaty where id=@warsztatID),0)
	FETCH NEXT FROM cursor1
	into @warsztatID,@liczbaOsub
end
close cursor1;
DEALLOCATE cursor1;
RETURN @cenaKonf+isnull(@cenaWarsz,0)
	
	
END
