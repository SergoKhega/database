WITH AveragePositions AS (
    SELECT 
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM 
        Results r
    JOIN 
        Cars c ON r.car = c.name
    GROUP BY 
        c.class
),
MinAveragePosition AS (
    SELECT 
        MIN(avg_position) AS min_avg_position
    FROM 
        AveragePositions
),
SelectedClasses AS (
    SELECT 
        ap.class,
        ap.avg_position,
        ap.race_count
    FROM 
        AveragePositions ap
    JOIN 
        MinAveragePosition map ON ap.avg_position = map.min_avg_position
)
SELECT 
    c.name AS car_name,
    sa.avg_position,
    sa.race_count,
    cl.country,
    COUNT(DISTINCT r.race) AS total_races
FROM 
    SelectedClasses sa
JOIN 
    Cars c ON sa.class = c.class
JOIN 
    Classes cl ON c.class = cl.class
JOIN 
    Results r ON c.name = r.car
GROUP BY 
    c.name, sa.avg_position, sa.race_count, cl.country
ORDER BY 
    c.name;