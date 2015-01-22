USE [Konferencje]
GO

/****** Object:  View [dbo].[NieZapłaconeRezerwacjeInd]    Script Date: 2015-01-21 18:11:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[NieZapłaconeRezerwacjeInd]

as
	select o.Nazwisko,o.Imie,kraje.Nazwa,m.Miasto,m.[Kod Pocztowy],a.Ulica,a.[Numer budynku],a.[Numer mieszkania],
	(select  dbo.PodliczRezerwacjafun(rk.id))as [do zapłacenia],isnull((select sum(Kwota) from Oplaty where [Rezerwacja konferencji]=rk.id),0) as Zapłacono,
	isnull((select sum(Kwota) from Oplaty where [Rezerwacja konferencji]=rk.id),0)-(select  dbo.PodliczRezerwacjafun(rk.id))as saldo,rk.[Data rezerwacji]
	 from [Rezerwacje konferencji] as rk inner join Klienci as k on k.id=rk.KlientID
	inner join Osoby as o on k.OsobaID=o.id inner join Adresy as a on a.id=o.AdresID inner join
	Miasta as m on m.id=a.MiastoID inner join Kraje on Kraje.id=m.KrajID
	where isnull((select sum(Kwota) from Oplaty where [Rezerwacja konferencji]=rk.id),0)-(select  dbo.PodliczRezerwacjafun(rk.id))<0 and k.CzyFirma=0



GO

