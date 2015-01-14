USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajAdres] 
@Country varchar(50),
@Miasto varchar(50),
@KodPocztowy varchar(12),
@Ulica varchar(35),
@NrBud int, 
@NrMiesz int 
AS BEGIN
SET NOCOUNT ON; 
DECLARE @KrajID int
DECLARE @MiastoID int
DECLARE @AdresID int
SET @KrajID=(select id from Kraje where Nazwa=@Country)
if @KrajID is null
begin
	Insert INTO Kraje (Nazwa) Values (@Country)
	SET @KrajID=@@IDENTITY
end
SET @MiastoID=(select id from Miasta where Miasto=@Miasto And [Kod Pocztowy]=@KodPocztowy and KrajID=@KrajID)
if @MiastoID is null
begin
	Insert INTO Miasta(Miasto,[Kod Pocztowy],KrajID) Values (@Miasto,@KodPocztowy,@KrajID)
	SET @MiastoID=@@IDENTITY
end
SET @AdresID=(select id from Adresy where MiastoID=@MiastoID and [Numer budynku]=@NrBud and [Numer mieszkania]=@NrMiesz and Ulica=@Ulica)
if @AdresID is null
begin
	Insert INTO Adresy(MiastoID,[Numer budynku],[Numer mieszkania],Ulica) Values (@MiastoID,@NrBud,@NrMiesz,@Ulica)
	SET @AdresID=@@IDENTITY
end
RETURN @AdresID
END
