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
RankedCars AS (
    SELECT 
        class,
        car,
        avg_position,
        race_count,
        ROW_NUMBER() OVER (PARTITION BY class ORDER BY avg_position) AS rank
    FROM 
        AveragePositions
)
SELECT 
    class,
    car,
    avg_position,
    race_count
FROM 
    RankedCars
WHERE 
    rank = 1
ORDER BY 
    avg_position;