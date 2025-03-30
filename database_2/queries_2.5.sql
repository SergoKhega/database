WITH AveragePositions AS (
    SELECT 
        c.class,
        r.car,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM 
        Results r
    JOIN 
        Cars c ON r.car = c.name
    GROUP BY 
        c.class, r.car
),
LowAvgPositionCars AS (
    SELECT 
        class,
        car,
        avg_position,
        race_count
    FROM 
        AveragePositions
    WHERE 
        avg_position > 3.0
),
ClassCounts AS (
    SELECT 
        class,
        COUNT(car) AS low_avg_count
    FROM 
        LowAvgPositionCars
    GROUP BY 
        class
)
SELECT 
    c.name AS car_name,
    c.class,
    ap.avg_position,
    ap.race_count,
    cl.country,
    COUNT(r.name) OVER (PARTITION BY c.class) AS total_races
FROM 
    LowAvgPositionCars ap
JOIN 
    Cars c ON ap.car = c.name
JOIN 
    Classes cl ON c.class = cl.class
JOIN 
    Races r ON r.name IN (SELECT race FROM Results WHERE car = c.name)
ORDER BY 
    (SELECT low_avg_count FROM ClassCounts WHERE class = c.class) DESC;