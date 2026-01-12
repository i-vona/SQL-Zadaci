--Za sve račune izdane 01.08.2002. i plaćene American Expressom ispisati njihove ID-eve i brojeve te ime i prezime i grad kupca, 
-- ime i prezime komercijalista te broj i podatke o isteku kreditne kartice. Rezultate sortirati prema prezimenu kupca.

SELECT 
	r.IDRacun,
    r.BrojRacuna,
    k.Ime AS ImeKupca,
    k.Prezime AS PrezimeKupca,
    g.Naziv AS NazivGrada,
    ko.Ime AS ImeKomercijalista,
    ko.Prezime AS PrezimeKomercijalista,
    kk.Broj AS BrojKartice,
    kk.IstekMjesec AS MjesecIsteka,
    kk.IstekGodina AS GodinaIsteka
FROM Racun r
INNER JOIN Kupac k ON r.KupacID = k.IDKupac
INNER JOIN Grad g ON k.GradID = g.IDGrad
INNER JOIN Komercijalist ko ON r.KomercijalistID = ko.IDKomercijalist
INNER JOIN KreditnaKartica kk ON r.KreditnaKarticaID = kk.IDKreditnaKartica
WHERE r.DatumIzdavanja = '2002-08-01' AND kk.Tip = 'American Express'
ORDER BY k.Prezime

--Ispisati nazive proizvoda koji su na nekoj stavci računa prodani u više od 35 komada. Svaki proizvod navesti samo jednom.

SELECT 
    p.Naziv
FROM Proizvod p
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
WHERE s.Kolicina > 35
GROUP BY p.Naziv



--Promijenite prethodni upit tako da umjesto ID potkategorije ispišete njen naziv.


--Ispišite nazive svih kategorija i pokraj svake napišite koliko potkategorija je u njoj.

SELECT
    k.Naziv,
    COUNT(pk.IDPotkategorija) AS BrojPotkategorija
FROM Kategorija k
LEFT JOIN Potkategorija pk ON k.IDKategorija = pk.KategorijaID
GROUP BY k.IDKategorija, k.Naziv


--Ispišite nazive svih kategorija i pokraj svake napišite koliko proizvoda je u njoj.

SELECT
    k.Naziv,
    COUNT(p.IDProizvod) AS KolicinaProizvoda
FROM Kategorija k
LEFT JOIN Potkategorija pk ON k.IDKategorija = pk.KategorijaID
LEFT JOIN Proizvod p ON pk.IDPotkategorija = p.PotkategorijaID
GROUP BY k.IDKategorija, k.Naziv


--Ispišite sve različite cijene proizvoda i napišite koliko proizvoda ima svaku cijenu.

SELECT
    s.CijenaPoKomadu,
    COUNT(s.ProizvodID) AS KolicinaProizvoda
FROM Stavka s
GROUP BY s.CijenaPoKomadu;


--Ispišite koliko je računa izdano koje godine.

SELECT 
    YEAR(DatumIzdavanja) AS Godina,
    COUNT(*) AS BrojRacuna
FROM Racun
GROUP BY YEAR(DatumIzdavanja)
ORDER BY Godina


--Ispišite brojeve svih račune izdane kupcu 377 i pokraj svakog ispišite ukupnu cijenu po svim stavkama.

SELECT 
    r.BrojRacuna,
    SUM(UkupnaCijena) AS UkupnaCijena
FROM Racun r
INNER JOIN Stavka s ON r.IDRacun = s.RacunID
WHERE r.KupacID = 377
GROUP BY r.BrojRacuna


--Ispišite ukupno zarađene iznose i broj prodanih primjeraka za svaki od ikad prodanih proizvoda.

SELECT 
    p.Naziv,
    SUM(s.UkupnaCijena) AS UkupniIznos, 
    SUM(s.Kolicina) AS ProdanihPrimjeraka
FROM Stavka s
INNER JOIN Proizvod p ON s.ProizvodID = p.IDProizvod
GROUP BY p.IDProizvod, p.Naziv
ORDER BY p.Naziv


--Ispišite ukupno zarađene iznose za svaki od proizvoda koji je prodan u više od 2000 primjeraka.

SELECT 
    p.Naziv,
    SUM(s.Kolicina) AS KolicinaProizvoda,
    SUM(UkupnaCijena) AS UkupniIznos
FROM Proizvod p 
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
GROUP BY p.IDProizvod, p.Naziv
HAVING SUM(s.Kolicina) > 2000


--Ispišite ukupno zarađene iznose za svaki od proizvoda koji je prodan u više od 2.000 primjeraka ili je zaradio više od 2.000.000 dolara.

SELECT 
    p.Naziv,
    SUM(s.Kolicina) AS KolicinaProizvoda,
    SUM(UkupnaCijena) AS UkupniIznos
FROM Proizvod p 
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
GROUP BY p.IDProizvod, p.Naziv
HAVING SUM(s.Kolicina) > 2000 OR SUM(UkupnaCijena) > 2000000