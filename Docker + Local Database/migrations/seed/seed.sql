INSERT INTO hotel_bookings (
id,
org_id,
hotel_id,
city,
checkin_date,
checkout_date,
amount,
status,
created_at
)
SELECT
uuid_generate_v4(),
uuid_generate_v4(),
'HTL-' || gs,
ARRAY['delhi','mumbai','bangalore','hyderabad']
[(random()*3+1)::int],
CURRENT_DATE,
CURRENT_DATE + ((random()*5)::int),
(round((1000 + random()*9000)::numeric,2)),
ARRAY['confirmed','cancelled','pending']
[(random()*2+1)::int],
NOW() - ((random()*60)::int || ' days')::interval
FROM generate_series(1,100) gs;

INSERT INTO booking_events(
booking_id,
event_type,
payload,
created_at
)
SELECT
id,
'BOOKING_CREATED',
jsonb_build_object('source','web'),
created_at
FROM hotel_bookings
LIMIT 50;

