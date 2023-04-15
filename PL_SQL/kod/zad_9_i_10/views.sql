CREATE OR REPLACE VIEW Reservations_4 (trip_id, country, trip_date, trip_name, person_id, firstname, lastname, reservation_id, status) AS
select T.TRIP_ID, T.COUNTRY, T.TRIP_DATE, T.TRIP_NAME, P.PERSON_ID, P.FIRSTNAME, P.LASTNAME, R.RESERVATION_ID, R.STATUS
from RESERVATION R
         join TRIP T on R.TRIP_ID = T.TRIP_ID
         join PERSON P on P.PERSON_ID = R.PERSON_ID;

CREATE OR REPLACE VIEW AvailableTrips_4 (trip_id, country, trip_date, trip_name, no_places, num_of_available_places) AS
select TRIP_ID,  COUNTRY, TRIP_DATE, TRIP_NAME, MAX_NO_PLACES, NO_AVAILABLE_PLACES
from Trip
where NO_AVAILABLE_PLACES > 0
  and current_date < TRIP_DATE;
