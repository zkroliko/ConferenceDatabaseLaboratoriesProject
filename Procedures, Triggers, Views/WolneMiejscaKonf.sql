USE [Konferencje]
GO

/****** Object:  View [dbo].[BrakujaceZgloszenia]    Script Date: 1/19/2015 8:13:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[WolneMiejscaKonf]
-- Widok pokazuje wolne miejsca na dniach konferencji
as
select 'Dzien konferencji' as 'Typ',  k.[Nazwa Konferencji] as 'Nazwa konferencji', dk.id as 'Numer dnia', dk.Data as 'Dzien',
 (k.[Liczba miejsc]) as 'Liczba miejsc',
 (sum(rk.normalne) + sum(rk.Studenci)) as 'Liczba zajetych miejsc',
 (k.[Liczba miejsc])-(sum(rk.normalne) + sum(rk.Studenci)) as 'Ile miejsc zostalo'
-- Laczenie tabel
from [Dni Konferencji] as dk
	inner join [Rezerwacje konferencji] as rk
	on rk.KonferencjaDzienId = dk.id
	inner join Konferencje as k
	on k.id = dk.KonferencjaID
where rk.anulowano = 0
group by k.[Nazwa Konferencji], dk.id, dk.Data, k.[Liczba miejsc]
GO


