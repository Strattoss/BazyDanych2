create or replace type trip_participant as OBJECT
(
    reservation_id int,
    firstname      varchar2(50),
    Lastname       varchar2(50),
    status         char
);


create or replace type trip_participant_table is table of trip_participant;


CREATE OR REPLACE FUNCTION trip_exists(trip_id in TRIP.trip_id%type)
    RETURN boolean
AS
    exist number;
BEGIN
    select case
               when exists(select * from TRIP T where T.TRIP_ID = trip_exists.trip_id) then 1
               else 0
               end
    into exist
    from dual;
    if exist = 1 then
        return true;
    else
        return false;
    end if;
END;


CREATE OR REPLACE FUNCTION trip_participants(trip_id TRIP.TRIP_ID%type)
    RETURN trip_participant_table
AS
    result trip_participant_table;
BEGIN
    if not trip_exists(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || ' not found');
    end if;

    select trip_participant(RESERVATION_ID, FIRSTNAME, LASTNAME, STATUS) bulk collect
    into result
    from RESERVATIONS R
    where R.TRIP_ID = trip_participants.trip_id
      and R.STATUS != 'C';
    return result;
END;

/* ######################### */

create or replace type person_reservation as OBJECT
(
    reservation_id int,
    trip_name      varchar2(100),
    country        varchar2(50),
    trip_date      date,
    status         char
);


create or replace type person_reservation_table is table of person_reservation;

drop function person_exists;
CREATE OR REPLACE FUNCTION person_exists(person_id in PERSON.PERSON_ID%type)
    RETURN boolean
AS
    exist number;
BEGIN
    select case
               when exists(select * from PERSON P where P.PERSON_ID = person_exists.person_id) then 1
               else 0
               end
    into exist
    from dual;
    if exist = 1 then
        return true;
    else
        return false;
    end if;
END;


CREATE OR REPLACE FUNCTION person_reservations(person_id number)
    RETURN person_reservation_table
AS
    result person_reservation_table;
BEGIN
    if not person_exists(person_reservations.person_id) then
        raise_application_error(-20001, 'person with id ' || person_id || ' not found');
    end if;

    select person_reservation(R.RESERVATION_ID, R.TRIP_NAME, R.COUNTRY, R.TRIP_DATE, R.STATUS) bulk collect
    into result
    from RESERVATIONS R
    where R.PERSON_ID = person_reservations.person_id;
    return result;
END;

/************************************/

create or replace type available_trips as OBJECT
(
    country             varchar2(50),
    trip_date           date,
    trip_name           varchar2(100),
    no_places           number,
    no_available_places number
);


create or replace type available_trips_table is table of available_trips;

/* named with f_... because there already exists a view with the same name */

CREATE OR REPLACE FUNCTION f_available_trips(country COUNTRY.COUNTRY_NAME%type, date_from date, date_to date)
    RETURN available_trips_table
AS
    result available_trips_table;
BEGIN
    if not date_from < date_to then
        raise_application_error(-20001, 'ending date cannot be before starting date');
    end if;

    select available_trips(AvTr.country,
                           AvTr.trip_date,
                           AvTr.trip_name,
                           AvTr.no_places,
                           AvTr.num_of_available_places) bulk collect
    into result
    from AVAILABLETRIPS AvTr
    where date_from < TRIP_DATE
      and TRIP_DATE < date_to
      and AvTr.COUNTRY = f_available_trips.country;
    return result;
END;

select *
from TRIPS;
