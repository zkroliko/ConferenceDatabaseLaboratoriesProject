USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajUczestnika] 
@RezerwacjaWarsztatuID int,
@UczestnikKonfID int



AS BEGIN
SET NOCOUNT ON; 

insert into Uczestnicy(RezerwacjaID,UczestnikKonfID)Values(@RezerwacjaWarsztatuID,@UczestnikKonfID)
END
