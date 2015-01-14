use Konferencje
go
alter view BrakujaceZgloszenia
-- Widok pokazuje zarowno brakujace zgloszenie konferencji jak i warszatow
as
--start
select 'Rezerwacja konferencji' as 'Typ', rk.id as 'Numer rezerwacji', rk.KlientID as 'Numer klienta',
 (rk.Studenci+rk.Normalne) as 'Ile miejsc zarezerwowano',
(select count(*) from [Uczestnicy Konferencji] as uk where uk.RezerwacjaKonfID = rk.id) as 'Ile uzupelniono',
 (rk.Studenci+rk.Normalne)-(select count(*) from [Uczestnicy Konferencji] as uk where uk.RezerwacjaKonfID = rk.id) as 'Ile brakuje',
 dk.Data as 'Dzien na ktory wykonano rezerwacje'
-- Laczenie tabel
from [Rezerwacje konferencji] as rk
    inner join [Dni Konferencji] as dk
	on rk.KonferencjaDzienId = dk.id
-- Warunek na date (2 tygodnie przed) oraz anulowanie
where rk.anulowano = 0 and dateadd(day, -14, GETDATE()) <= dk.Data 
group by rk.id, rk.KlientID, dk.Data, (rk.Studenci+rk.Normalne)
-- Warunek na ilosc
having (select count(*) from [Uczestnicy Konferencji] as uk where uk.RezerwacjaKonfID = rk.id) < (rk.Studenci+rk.Normalne)
-- Teraz czesc od warsztatow
union
select 'Rezerwacja warsztatu' as 'Typ', rw.id as 'Numer rezerwacji', rk.KlientID as 'Numer klienta',
 rw.[Liczba miejsc] as 'Ile miejsc zarezerwowano',
 (select count(*) from [Uczestnicy] as u where u.RezerwacjaID = rk.id) as 'Ile uzupelniono',
 rw.[Liczba miejsc] - (select count(*) from [Uczestnicy] as u where u.RezerwacjaID = rk.id) as 'Ile brakuje',
 dk.Data
from [Rezerwacje warsztatow] as rw
 inner join Warsztaty as w
 on w.id = rw.WarsztatID
 inner join [Rezerwacje konferencji] as rk
 on rk.id = rw.KonferencjaID
 inner join [Dni Konferencji] as dk
 on rk.KonferencjaDzienId = dk.id
 -- Warunek na date oraz anulowanie
where rw.anulowano = 0 and (dateadd(day, -14, GETDATE()) <= (select top 1 dk.Data
 from [Dni warsztatu] as dw
 inner join [Dni Konferencji] as dk
 on dk.id = dw.DzienID where dw.WarsztatID = w.id order by dk.Data DESC))
group by rk.id, rw.id, rk.KlientID, rw.[Liczba miejsc], dk.Data
-- Warunek na ilosc
having (select count(*) from [Uczestnicy] as u where u.RezerwacjaID = rk.id) < rw.[Liczba miejsc]
--end
go