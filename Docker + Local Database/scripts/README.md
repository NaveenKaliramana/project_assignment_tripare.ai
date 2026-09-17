Verification

Before backup:

SELECT COUNT(*) FROM hotel_bookings;
SELECT COUNT(*) FROM booking_events;

After restore:

Run same queries.

Counts should match.