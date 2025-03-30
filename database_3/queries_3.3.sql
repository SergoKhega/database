WITH hotel_categories AS (
    SELECT 
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS average_price,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS category
    FROM 
        Hotel h
    JOIN 
        Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY 
        h.ID_hotel
),
customer_preferences AS (
    SELECT 
        c.ID_customer,
        c.name,
        CASE 
            WHEN SUM(CASE WHEN hc.category = 'Дорогой' THEN 1 ELSE 0 END) > 0 THEN 'Дорогой'
            WHEN SUM(CASE WHEN hc.category = 'Средний' THEN 1 ELSE 0 END) > 0 THEN 'Средний'
            WHEN SUM(CASE WHEN hc.category = 'Дешевый' THEN 1 ELSE 0 END) > 0 THEN 'Дешевый'
            ELSE 'Нет предпочтений'
        END AS preferred_hotel_type,
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        hotel_categories hc ON r.ID_hotel = hc.ID_hotel
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer
)
SELECT 
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM 
    customer_preferences
ORDER BY 
    CASE 
        WHEN preferred_hotel_type = 'Дешевый' THEN 1
        WHEN preferred_hotel_type = 'Средний' THEN 2
        WHEN preferred_hotel_type = 'Дорогой' THEN 3
        ELSE 4
    END;