CREATE OR REPLACE VIEW Reservations (trip_id, country, trip_date, trip_name, person_id, firstname, lastname, reservation_id, status) AS
select T.TRIP_ID, T.COUNTRY, T.TRIP_DATE, T.TRIP_NAME, P.PERSON_ID, P.FIRSTNAME, P.LASTNAME, R.RESERVATION_ID, R.STATUS
from RESERVATION R
         join TRIP T on R.TRIP_ID = T.TRIP_ID
         join PERSON P on P.PERSON_ID = R.PERSON_ID;


/* auxiliary view */
CREATE OR REPLACE VIEW ActiveReservationsByTrips AS
select R.TRIP_ID, count(R.RESERVATION_ID) NUM_OF_RESERVATIONS
from RESERVATION R
where R.STATUS != 'C'
group by R.TRIP_ID;

select *
from AvailableTrips;


CREATE OR REPLACE VIEW Trips (trip_id, country, trip_date, trip_name, no_places, num_of_available_places) AS
select T.TRIP_ID, T.COUNTRY, T.TRIP_DATE, T.TRIP_NAME, T.MAX_NO_PLACES, (T.MAX_NO_PLACES - NVL(MR.NUM_OF_RESERVATIONS, 0))
from TRIP T
         left join ActiveReservationsByTrips MR on T.TRIP_ID = MR.TRIP_ID;


CREATE OR REPLACE VIEW AvailableTrips (trip_id, country, trip_date, trip_name, no_places, num_of_available_places) AS
select T.trip_id,  T.COUNTRY, T.TRIP_DATE, T.TRIP_NAME, T.NO_PLACES, T.NUM_OF_AVAILABLE_PLACES
from TRIPS T
where num_of_available_places > 0
  and current_date < T.TRIP_DATE;
