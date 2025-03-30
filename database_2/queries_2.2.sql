WITH AveragePositions AS (
    SELECT 
        c.name AS car,
        cl.class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM 
        Cars c
    JOIN 
        Classes cl ON c.class = cl.class
    JOIN 
        Results r ON c.name = r.car
    GROUP BY 
        c.name, cl.class, cl.country
),
MinAvgPosition AS (
    SELECT 
        car,
        class,
        country,
        avg_position,
        race_count,
        ROW_NUMBER() OVER (ORDER BY avg_position, car) AS rank
    FROM 
        AveragePositions
)
SELECT 
    car,
    class,
    avg_position,
    race_count,
    country
FROM 
    MinAvgPosition
WHERE 
    rank = 1;