USE Konferencje;
GO
-- Dla podanej konferencji podaje wszystkie progi cenowe
CREATE PROCEDURE CenyNaDniKonferencji
    @param varchar(50) --id konferencji lub nazwa
AS 
	set nocount on
    SELECT dk.Data as 'Dzien', z.[Obowiazuje od], z.[Obowiazuje do], k.[Cena za dzien]*(1-z.Znizka) as 'Kwota za dzien, za osobe w podanym terminie' from [Dni Konferencji] as dk
	inner join Konferencje as k
	on dk.KonferencjaID = k.id
	inner join Znizki as z
	on z.KonferencjaID = k.id
	where k.[Nazwa Konferencji] like @param or k.id like @param
GO
