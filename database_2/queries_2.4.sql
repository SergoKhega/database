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
ClassAverage AS (
    SELECT 
        class,
        AVG(avg_position) AS class_avg_position
    FROM 
        AveragePositions
    GROUP BY 
        class
)
SELECT 
    ap.car,
    ap.class,
    ap.avg_position,
    ap.race_count,
    cl.country
FROM 
    AveragePositions ap
JOIN 
    ClassAverage ca ON ap.class = ca.class
JOIN 
    Classes cl ON ap.class = cl.class
WHERE 
    ap.avg_position < ca.class_avg_position
    AND ap.race_count >= 2
ORDER BY 
    ap.class,
    ap.avg_position;