--Comparing the two datasets
SELECT *
FROM [Portfolio Project]..[taylorswift-Features]

SELECT *
FROM [Portfolio Project]..[taylorswift-Tracks]

--I see there are two names used for the same column. Changing to one name
EXEC sp_rename 'Portfolio Project..taylorswift-Tracks.[name]', 'track_name', 'COLUMN';


--Ranking popularity based off album

SELECT album_name, track_name, popularity
FROM [Portfolio Project]..[taylorswift-Tracks]
WHERE album_name = '1989 (Taylor''s Version) [Deluxe]'
ORDER BY popularity DESC;

--Getting top 3 most popular songs and least popular from that album

--SELECT TOP 3 album_name, name, popularity
FROM [Portfolio Project]..[taylorswift-Tracks]
WHERE album_name = '1989 (Taylor''s Version) [Deluxe]'
ORDER BY popularity DESC;

SELECT TOP 3 album_name, track_name, popularity
FROM [Portfolio Project]..[taylorswift-Tracks]
WHERE album_name = '1989 (Taylor''s Version) [Deluxe]'
ORDER BY popularity ASC;

--Top 3 names on each albumn
SELECT album_name, track_name, popularity
FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY album_name ORDER BY popularity DESC) AS rn
    FROM [Portfolio Project]..[taylorswift-Tracks]
) AS ranked_tracks
WHERE rn <= 3;


--Joining based on energy
SELECT 
    t.album_name, t.track_name, f.energy
FROM 
    [Portfolio Project]..[taylorswift-Tracks] AS t
INNER JOIN 
    [Portfolio Project]..[taylorswift-Features] AS f ON t.album_name = f.album_name AND t.track_name = f.track_name
WHERE 
    t.track_name IN (
        SELECT TOP 5 sub.track_name
        FROM [Portfolio Project]..[taylorswift-Features] AS sub
        WHERE sub.album_name = t.album_name
        ORDER BY sub.energy DESC
    )
ORDER BY 
    t.album_name, f.energy DESC;
