CREATE MATERIALIZED VIEW trip_between_zones AS 
SELECT  
        pu_zone.zone as pickup_zone , du_zone.zone as dropOff_zone,
        MAX(trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime),
        MIN(trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime),
        AVG(trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime)
FROM
    trip_data
JOIN 
    taxi_zone pu_zone ON trip_data.PULocationID = pu_zone.location_id
JOIN 
    taxi_zone du_zone ON trip_data.DOLocationID = du_zone.location_id
GROUP BY pu_zone.zone, du_zone.zone
ORDER BY AVG(trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime) DESC
;

CREATE MATERIALIZED VIEW question_2 AS 
SELECT  
        pu_zone.zone as pickup_zone , du_zone.zone as dropOff_zone,
        AVG(trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime),
        COUNT(*)
FROM
    trip_data
JOIN 
    taxi_zone pu_zone ON trip_data.PULocationID = pu_zone.location_id
JOIN 
    taxi_zone du_zone ON trip_data.DOLocationID = du_zone.location_id
GROUP BY pu_zone.zone, du_zone.zone
ORDER BY AVG(trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime) DESC
;


CREATE MATERIALIZED VIEW latest_trip as 
SELECT MAX(trip_data.tpep_pickup_datetime) as latest_time FROM trip_data;

CREATE MATERIALIZED VIEW trip_data_zone as 
SELECT 
    pu_zone.zone as pickup_zone,
    trip_data.tpep_pickup_datetime
FROM 
    trip_data
JOIN taxi_zone pu_zone ON trip_data.PULocationID = pu_zone.location_id;


SELECT pickup_zone, Count(*) as trips 
FROM trip_data_zone
JOIN 
    latest_trip ON trip_data_zone.tpep_pickup_datetime > latest_time - interval '17 hours'
GROUP BY pickup_zone
ORDER BY COUNT(*) DESC; 
