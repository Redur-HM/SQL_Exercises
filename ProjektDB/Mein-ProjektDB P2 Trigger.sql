--was ich vom Dozenten gedchrieben habe
-- VIEW: sind Sichten aus der Datenbank. Hier können Sie Tabellen, Tabellenspalten aus ihrer Datenbank hinterlegen
GO
CREATE OR ALTER VIEW  v_MitarbeiterDeluxe AS 
SELECT m.vorname, m.nachname, m.ort, ab.bezeichnung AS abteilung,
		ab.ort AS abt_stadt, g.gehalt AS gehalt
FROM Mitarbeiter m
	INNER JOIN Abteilung ab ON ab.id= m.abt_id
		  JOIN Gehalt g ON g.mit_id=m.id
GO
-- View anzeigen
SELECT * FROM v_MitarbeiterDeluxe;

GO
-- Trigger erstellen: INSERT auf dem View abfangen
CREATE OR ALTER TRIGGER tr_InsertMitarbeiter ON v_MitarbeiterDeluxe
INSTEAD OF INSERT 
AS 
BEGIN 
    -- Es darf nur ein Datensatz gleichzeitig eingefügt werden
	IF(SELECT COUNT(*) FROM inserted) != 1
		PRINT 'ES kann nur ein Datensatz eingefügt werden.'
	ELSE
	BEGIN 
		--Testen, ob Mitarbeiter bereit existiert
		DECLARE @mit_id INT = (
				SELECT id FROM Mitarbeiter m, inserted i
				WHERE m.nachname = i.nachname AND m.vorname = i.vorname
				)
		IF (@mit_id IS NOT NULL)
				--Mitarbeiter bereits da --> ENDE
				PRINT 'Der Mitarbeiter existiert bereits'
		ELSE
			BEGIN
				--Mitarbeiter noch nicht da --> Neue ID generieren
				SET @mit_id = (SELECT MAX(id) FROM Mitarbeiter)+ 1 

				--INSERT-WERte AUS DER INSERTED-TABELLE holen
				DECLARE @vorname VARCHAR(30) = (SELECT vorname FROM inserted);
				DECLARE @nachname VARCHAR(30) = (SELECT nachname FROM inserted);
				DECLARE @ort VARCHAR(25) = (SELECT ort FROM inserted);
				DECLARE @abt_stadt VARCHAR(30) = (SELECT abt_stadt FROM inserted);
				DECLARE @bezeichnung VARCHAR(30) = (SELECT abteilung FROM inserted);
				DECLARE @gehalt MONEY = (SELECT gehalt FROM inserted);

				--Testen, ob Abteilung bereits da
				DECLARE @abt_id INT = (SELECT id FROM Abteilung ab, inserted i
										WHERE ab.bezeichnung = i.abteilung)
				IF (@abt_id IS NULL)
				BEGIN
					--Abteilung noch nicht da --> anlegen mit neuer ID
					SET @abt_id = (SELECT ISNULL(MAX(id), 0) FROM Abteilung) + 1

					INSERT INTO Abteilung (id,bezeichnung, ort)
					VALUES (@abt_id,@bezeichnung, @abt_stadt);
				END
					--Mitarbieter anelgen
					INSERT INTO Mitarbeiter (id,vorname, nachname, ort, abt_id)
					VALUES (@mit_id,@vorname,@nachname,@ort, @abt_id);
					--Gehalt anlegen
					INSERT INTO Gehalt(mit_id,gehalt)
					VALUES (@mit_id, @gehalt);
			END;
		END;
END;







GO

-- View erstellen: Daten aus drei Tabellen zusammenführen
CREATE OR ALTER VIEW v_MitarbeiterDeluxe AS

SELECT
    m.vorname,
    m.nachname,
    m.ort,
    ab.bezeichnung AS abteilung,
    ab.ort AS abt_stadt,
    g.gehalt AS gehalt
FROM Mitarbeiter m
    INNER JOIN Abteilung ab ON ab.id = m.abt_id
    JOIN Gehalt g ON g.mit_id = m.id;
GO

-- View anzeigen
SELECT * FROM v_MitarbeiterDeluxe;

GO

-- Trigger erstellen: INSERT auf dem View abfangen
CREATE OR ALTER TRIGGER tr_InsertMitarbeiter
ON v_MitarbeiterDeluxe
INSTEAD OF INSERT
AS
BEGIN

    -- Es darf nur ein Datensatz gleichzeitig eingefügt werden
    IF (SELECT COUNT(*) FROM inserted) != 1
        PRINT 'Es kann nur ein Datensatz eingefügt werden.'

    ELSE
    BEGIN

        -- Prüfen, ob der Mitarbeiter bereits existiert
        DECLARE @mit_id INT = (
            SELECT id
            FROM Mitarbeiter m, inserted i
            WHERE m.nachname = i.nachname
              AND m.vorname = i.vorname
        );

        IF (@mit_id IS NOT NULL)

            -- Mitarbeiter existiert bereits
            PRINT 'Der Mitarbeiter existiert bereits';

        ELSE
        BEGIN

            -- Neue Mitarbeiter-ID generieren
            SET @mit_id = (
                SELECT MAX(id) FROM Mitarbeiter
            ) + 1;

            -- Neue Mitarbeiterdaten aus inserted übernehmen
            DECLARE @vorname VARCHAR(30) =
                (SELECT vorname FROM inserted);

            DECLARE @nachname VARCHAR(30) =
                (SELECT nachname FROM inserted);

            DECLARE @ort VARCHAR(25) =
                (SELECT ort FROM inserted);

            DECLARE @abt_stadt VARCHAR(30) =
                (SELECT abt_stadt FROM inserted);

            DECLARE @bezeichnung VARCHAR(30) =
                (SELECT abteilung FROM inserted);

            DECLARE @gehalt MONEY =
                (SELECT gehalt FROM inserted);


            -- Prüfen, ob die Abteilung bereits existiert
            DECLARE @abt_id INT = (
                SELECT id
                FROM Abteilung ab, inserted i
                WHERE ab.bezeichnung = i.abteilung
            );

            IF (@abt_id IS NULL)
            BEGIN

                -- Neue Abteilung-ID generieren
                SET @abt_id = (
                    SELECT ISNULL(MAX(id), 0)
                    FROM Abteilung
                ) + 1;

                -- Neue Abteilung anlegen
                INSERT INTO Abteilung (id, bezeichnung, ort)
                VALUES (@abt_id, @bezeichnung, @abt_stadt);

            END

            -- Mitarbeiter in der Tabelle anlegen
            INSERT INTO Mitarbeiter
                (id, vorname, nachname, ort, abt_id)
            VALUES
                (@mit_id, @vorname, @nachname, @ort, @abt_id);

            -- Gehalt des Mitarbeiters speichern
            INSERT INTO Gehalt (mit_id, gehalt)
            VALUES (@mit_id, @gehalt);

        END;
    END;
END;
