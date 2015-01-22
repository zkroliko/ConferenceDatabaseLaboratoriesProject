USE [Konferencje]
GO

/****** Object:  View [dbo].[BrakujaceZgloszenia]    Script Date: 1/19/2015 8:27:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[WolneMiejscaWarsztatow]
-- Widok pokazuje wolne miejsca na warsztacie
as
--start
select 'Warsztat' as 'Typ',  w.[Nazwa warsztatu] as 'Nazwa warsztatu', w.id as 'Numer warsztatu',
 (w.[Liczba miejsc]) as 'Liczba miejsc',
 sum(rw.[liczba miejsc]) as 'Liczba zajetych miejsc',
 (w.[Liczba miejsc])-(sum(rw.[liczba miejsc])) as 'Ile miejsc zostalo'
from [Rezerwacje warsztatow] as rw
 inner join Warsztaty as w
 on w.id = rw.WarsztatID
where rw.anulowano = 0
group by w.id, w.[Nazwa warsztatu], (w.[Liczba miejsc])
GO


