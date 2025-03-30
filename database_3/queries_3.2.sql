WITH CustomerAnalysis AS (
    SELECT 
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
        SUM(r.price * (DATE_PART('day', b.check_out_date - b.check_in_date))) AS total_spent
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    GROUP BY 
        c.ID_customer
    HAVING 
        COUNT(b.ID_booking) > 2 
        AND COUNT(DISTINCT r.ID_hotel) > 1
),
HighSpenders AS (
    SELECT 
        c.ID_customer,
        c.name,
        SUM(r.price * (DATE_PART('day', b.check_out_date - b.check_in_date))) AS total_spent,
        COUNT(b.ID_booking) AS total_bookings
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    GROUP BY 
        c.ID_customer
    HAVING 
        SUM(r.price * (DATE_PART('day', b.check_out_date - b.check_in_date))) > 500
)
SELECT 
    ca.ID_customer,
    ca.name,
    ca.total_bookings,
    ca.total_spent,
    ca.unique_hotels
FROM 
    CustomerAnalysis ca
JOIN 
    HighSpenders hs ON ca.ID_customer = hs.ID_customer
ORDER BY 
    ca.total_spent ASC;