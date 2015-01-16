USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajKlientaInd] 
@Name varchar(50),
@LastName varchar(50),
@Phone varchar(12),
@DateOfBirth Date,
@Sex bit,
@NrLeg nvarchar(10),
@Country varchar(50),
@Miasto varchar(50),
@KodPocztowy varchar(12),
@Ulica varchar(35),
@NrBud int, 
@NrMiesz int,  
@Email varchar(50), 
@Login varchar(30), 
@Password varchar(20),
@IsCompany bit
AS BEGIN
SET NOCOUNT ON; 
DECLARE @OsobaID int
Exec dbo.DodajOsobe @Name ,@LastName ,@Phone ,@DateOfBirth ,@Sex,@NrLeg,@Country,@Miasto,@KodPocztowy,@Ulica,@NrBud,@NrMiesz 
 SET @OsobaID =(Select Max(id) from Osoby)
 Insert into Klienci (Login,Password,Email,CzyFirma,OsobaID)Values(@Login,@Password,@Email,@IsCompany,@OsobaID)
END
