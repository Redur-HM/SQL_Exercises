
--keine IHK-Syntax.

SELECT m.id, m.nachname, COALESCE(p.bezeichnung, m.ort, ' -k.A.- ') AS Angabe
FROM Mitarbeiter m
LEFT JOIN Arbeit a
ON a.mit_id = m.id AND a.aufgabe = 'Projektleiter'
LEFT JOIN Projekt p
ON p.id = a.pro_id;


SELECT '        Hallo World ' AS Ruf;
--TIRM entfernt die Leerzeichnen vor und nach der Zeichenkette.
SELECT TRIM('              Hallo World ' ) AS Ruf;

SELECT CONCAT (TRIM (vorname), ' ', TRIM(nachname)) AS Name
FROM Mitarbeiter;

--CONCAT_WS
SELECT CONCAT_WS ('-', TRIM (vorname), TRIM(nachname), TRIM(ort)) AS Angabe
FROM Mitarbeiter;

SELECT CONCAT_WS ('~', vorname, nachname, ort) AS Angabe
FROM Mitarbeiter;

--LEN()
SELECT CONCAT_WS ('-', TRIM (vorname), TRIM(nachname), TRIM(ort))AS Angabe,
	LEN(vorname) AS LängeVorname, LEN(vorname+ nachname ) AS 'LängeVor- Nachname'
FROM Mitarbeiter;

SELECT CONCAT_WS ('-', TRIM (vorname), TRIM(nachname), TRIM(ort))AS Angabe,
	LEN(vorname) AS LängeVorname, LEN(vorname+ nachname ) AS 'LängeVor- Nachname'
FROM Mitarbeiter;

--DATALE
SELECT CONCAT_WS ('-', TRIM (vorname), TRIM(nachname), TRIM(ort))AS Angabe,
	LEN(vorname) AS LängeVorname, 
	DATALENGth(vorname) AS LängeByteVorname,
	UPPER(vorname) AS GroßbVorname, --alle Buchstaben groß geschrieben
	LOWER(vorname) AS KleinbVorname, --alle Buchstaben klein geschrieben
	LEFT(vorname,3) AS VornameBis3, -- Von Links Bis 3. Buchstabe
	RIGHT(vorname,4) AS VornameRechts4Bust,--VornameRechts 4 Buchstaben
	SUBSTRING(vorname,2,4) AS TeilsrtingVonBis,-- Von 2. Buchstabe Bis 4. Buchstabe
	REVERSE(LOWER(vorname)) AS REVERSEname --umgekehrt
FROM Mitarbeiter;

--Datumsfunktionen
-- Aktuelle Datum
SELECT GETDATE() AS Zeitstempel,--Aktuelles Datum und Uhrzeit.
		SYSDATETIME() AS Zeitstempel_datetime2; --aktuelles Datum und Uhrzeit, jedoch mit höherer Genauigkeit.

SELECT einst_dat,
		DATENAME(dw, einst_dat) AS wochentag, --Name des Tages
		DATENAME(month,einst_dat) AS monat,
		MONTH(einst_dat) monat2,
		YEAR(einst_dat) Jahr,
		DAY(einst_dat) Tag,
		DATEPART(dw,einst_dat) wochentag_zahl --welcher Tagsnummer hat in der Woche , Beispiel Ergibnes: 2 also war Deinstag.
FROM Arbeit;

--Suchstring in einer Spalte mit Zeichenketten
SELECT DATEADD(year,1,GETDATE()) AS altDatumPlus1Jahr,
		DATEDIFF(day, '20261026',GETDATE()) AS DaurModul;

SELECT CAST(DATEADD(day, 17, '20261103') AS DATE) AS Datum;
SELECT DATEDIFF(day, '20270101',GETDATE()) AS DaurModul;

SELECT DATEDIFF(YEAR, '19951111',GETDATE()) AS DaurModul;
SELECT DATEADD(YEAR, DATEDIFF(YEAR, '19951111', GETDATE()), GETDATE()) AS HHH

--Datentypen umwandeln
SELECT CAST(GETDATE() AS DATE ) AS datum, GETDATE() AS aktDat;

SELECT GETDATE() As da
--Minten und Sekunden
SELECT CONCAT(DATENAME(MINUTE,GETDATE()), ':',DATENAME(SECOND,GETDATE())) AS Time ;