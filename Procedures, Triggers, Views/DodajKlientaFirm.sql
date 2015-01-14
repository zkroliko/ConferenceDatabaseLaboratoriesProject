USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajKlientaFirm] 
@Name varchar(50),
@LastName varchar(50),
@Phone varchar(12),
@DateOfBirth Date,
@Sex bit,
@NrLeg nvarchar(10),
@NazwaFirmy varchar(25),
@TelFirm varchar(12),
@Fax varchar(12),
@Email varchar(50), 
@Login varchar(30), 
@Password varchar(20),
@IsCompany bit,
@Country varchar(50),
@Miasto varchar(50),
@KodPocztowy varchar(12),
@Ulica varchar(35),
@NrBud int, 
@NrMiesz int  
AS BEGIN
SET NOCOUNT ON; 
DECLARE @OsobaID int
DECLARE @AdresID int
DECLARE @KlientID int
Exec dbo.DodajOsobe @Name ,@LastName ,@Phone ,@DateOfBirth ,@Sex,@NrLeg,@Country,@Miasto,@KodPocztowy,@Ulica,@NrBud,@NrMiesz 
 SET @OsobaID =(Select Max(id) from Osoby)
 Insert into Klienci (Login,Password,Email,CzyFirma,OsobaID)Values(@Login,@Password,@Email,@IsCompany,@OsobaID)
 SET @AdresID =(select A.id from Adresy as A 
	inner join Miasta  as M on A.MiastoID=M.id
	inner join Kraje as K on K.id=M.KrajID
	Where  A.[Numer budynku]=@NrBud and isnull(A.[Numer mieszkania],0) = isnull(@NrMiesz,0) and A.Ulica=@Ulica and M.Miasto=@Miasto And M.[Kod Pocztowy]=@KodPocztowy and K.Nazwa=@Country)
SET @KlientID =(Select Max(id) from Klienci)
	
INSERT INTO Firmy (KlientID,[Nazwa Firmy],[Telefon Kontaktowy],Fax,AdresID)Values(@KlientID,@NazwaFirmy,@TelFirm,@Fax,@AdresID)

END
