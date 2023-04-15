create table country
(
    country_name varchar(50),
    constraint country_pk primary key (country_name) enable
);

create table person
(
  person_id int generated always as identity not null,
  firstname varchar(50),
  lastname varchar(50),
  constraint person_pk primary key ( person_id ) enable
);

create table trip
(
  trip_id int generated always as identity not null,
  trip_name varchar(100),
  country varchar(50),
  trip_date date,
  max_no_places int,
  constraint trip_pk primary key ( trip_id ) enable
);

create table reservation
(
  reservation_id int generated always as identity not null,
  trip_id int,
  person_id int,
  status char(1),
  constraint reservation_pk primary key ( reservation_id ) enable
);


alter table reservation
add constraint reservation_fk1 foreign key
( person_id ) references person ( person_id ) enable;

alter table reservation
add constraint reservation_fk2 foreign key
( trip_id ) references trip ( trip_id ) enable;

alter table reservation
add constraint reservation_chk1 check
(status in ('N','P','C')) enable;

alter table trip
add constraint trip_fk1 foreign key
( country ) references country (country_name) enable;


create table log
(
	log_id int generated always as identity not null,
	reservation_id int not null,
	log_date date  not null,
	status char(1),
	constraint log_pk primary key ( log_id ) enable
);

alter table log
add constraint log_chk1 check
(status in ('N','P','C')) enable;

alter table log
add constraint log_fk1 foreign key
( reservation_id ) references reservation ( reservation_id ) enable;


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

-- country
insert into COUNTRY(COUNTRY_NAME)
values('Polska');
insert into COUNTRY(COUNTRY_NAME)
values('Francja');
insert into COUNTRY(COUNTRY_NAME)
values('Hiszpania');
insert into COUNTRY(COUNTRY_NAME)
values('Grecja');

-- trip
insert into trip(trip_name, country, trip_date, max_no_places)
values ('Wycieczka do Paryza', 'Francja', to_date('2022-09-12','YYYY-MM-DD'), 6);

insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Piękny Kraków', 'Polska', to_date('2023-07-03','YYYY-MM-DD'), 7);

insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Znów do Francji', 'Francja', to_date('2023-05-01','YYYY-MM-DD'), 5);

insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Hel', 'Polska', to_date('2023-05-01','YYYY-MM-DD'), 7);

insert into trip(trip_name, country, trip_date,  max_no_places)
values ('Czemu by nie?', 'Hiszpania', to_date('2023-02-02','YYYY-MM-DD'), 5);

-- person
insert into person(firstname, lastname)
values ('Jan', 'Nowak');

insert into person(firstname, lastname)
values ('Jan', 'Kowalski');

insert into person(firstname, lastname)
values ('Jan', 'Nowakowski');

insert into person(firstname, lastname)
values ('Adam', 'Kowalski');

insert into person(firstname, lastname)
values  ('Novak', 'Nowak');

insert into person(firstname, lastname)
values ('Piotr', 'Piotrowski');

insert into PERSON(firstname, lastname)
VALUES ('Marek', 'Adamowski');

insert into PERSON(firstname, lastname)
VALUES ('Adam', 'Markowski');

insert into PERSON(firstname, lastname)
VALUES ('Filip', 'Maciejewski');

insert into PERSON(firstname, lastname)
VALUES ('Maciej', 'Filipowski');

-- reservation
-- trip 1
insert into reservation(trip_id, person_id, status)
values (1, 1, 'P');

insert into reservation(trip_id, person_id, status)
values (1, 2, 'N');

-- trip 2
insert into reservation(trip_id, person_id, status)
values (2, 1, 'C');

insert into reservation(trip_id, person_id, status)
values (2, 4, 'C');

insert into reservation(trip_id, person_id, status)
values (2, 7, 'N');

insert into reservation(trip_id, person_id, status)
values (2, 9, 'P');

-- trip 3
insert into reservation(trip_id, person_id, status)
values (3, 4, 'P');

-- trip 4
insert into reservation(trip_id, person_id, status)
values (4, 6, 'P');

insert into reservation(trip_id, person_id, status)
values (4, 9, 'C');

insert into reservation(trip_id, person_id, status)
values (4, 3, 'N');

select *
from AVAILABLETRIPS;

/* These procedures are modified versions of previous procedures
   They work together correctly with triggers_2 */

create or replace procedure add_reservation_2(trip_id TRIP.TRIP_ID%type, person_id PERSON.PERSON_ID%type)
    is
begin
    if not trip_exists(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || ' doesn''t exist');
    elsif not PERSON_EXISTS(person_id) then
        raise_application_error(-20002, 'person wit id ' || person_id || ' doesn''t exist');
    elsif not trip_is_available(trip_id) then
        raise_application_error(-20003, 'trip with id ' || trip_id || ' is not available');
    elsif person_has_trip_reservation(person_id, trip_id) then
        raise_application_error(-20004,
                                'person with id ' || person_id || ' already has a reservation for trip with id ' ||
                                trip_id);
    end if;

    insert into RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (TRIP_ID, PERSON_ID, 'N');
end;


CREATE OR REPLACE PROCEDURE modify_reservation_status_2(reservation_id RESERVATION.TRIP_ID%type,
                                                      status RESERVATION.STATUS%type)
    is
    current_status RESERVATION.STATUS%type;
    trip_id        RESERVATION.TRIP_ID%type;
begin
    if not reservation_exists(reservation_id) then
        raise_application_error(-20001, 'reservation with id ' || reservation_id || ' doesn''t exist');
    end if;

    select R.STATUS, R.TRIP_ID
    into current_status, trip_id
    from RESERVATION R
    where R.RESERVATION_ID = modify_reservation_status_2.reservation_id;

    if current_status = status then
        return;
    elsif current_status = 'N' or
          current_status = 'P' or
          (current_status = 'C' and trip_is_available(trip_id)) then
        update RESERVATION R
        set R.STATUS = modify_reservation_status_2.status
        where R.RESERVATION_ID = modify_reservation_status_2.RESERVATION_ID;
    else
        raise_application_error(-20005, 'cannot change status of reservation with id ' || reservation_id ||
                                        ' , no free places on the trip');
    end if;
end;

/* These procedures are modified versions of previous procedures_2
   They work together correctly with triggers from triggers_3 */

create or replace procedure add_reservation_3(trip_id TRIP.TRIP_ID%type, person_id PERSON.PERSON_ID%type)
    is
begin
    if not trip_exists(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || ' doesn''t exist');
    elsif not PERSON_EXISTS(person_id) then
        raise_application_error(-20002, 'person wit id ' || person_id || ' doesn''t exist');
    end if;

    insert into RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (TRIP_ID, PERSON_ID, 'N');
end;


CREATE OR REPLACE PROCEDURE modify_reservation_status_3(reservation_id RESERVATION.TRIP_ID%type,
                                                        status RESERVATION.STATUS%type)
    is
begin
    if not reservation_exists(reservation_id) then
        raise_application_error(-20001, 'reservation with id ' || reservation_id || ' doesn''t exist');
    end if;

    update RESERVATION R
    set R.STATUS = modify_reservation_status_3.status
    where R.RESERVATION_ID = modify_reservation_status_3.RESERVATION_ID;
end;

select *
from AVAILABLETRIPS;

select *
from LOG;

declare
    RESERVATION_ID RESERVATION.TRIP_ID %TYPE := 126;
    STATUS         RESERVATION.STATUS %TYPE  := 'P';
begin
    BD_409890.MODIFY_RESERVATION_STATUS_3(
            RESERVATION_ID => RESERVATION_ID,
            STATUS => STATUS
        );
end;

CREATE OR REPLACE FUNCTION trip_is_available(trip_id TRIP.trip_id%type)
    RETURN boolean
AS
    exist number;
BEGIN
    select case
               when exists(select * from AVAILABLETRIPS AvTr where AvTr.TRIP_ID = trip_is_available.trip_id)
                   then 1
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


CREATE OR REPLACE FUNCTION person_has_trip_reservation(person_id PERSON.PERSON_ID%type, trip_id TRIP.trip_id%type)
    RETURN boolean
AS
    exist number;
BEGIN
    select case
               when exists(select *
                           from RESERVATION R
                           where R.TRIP_ID = person_has_trip_reservation.trip_id
                             and R.PERSON_ID = person_has_trip_reservation.person_id)
                   then 1
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


create or replace procedure add_reservation(trip_id TRIP.TRIP_ID%type, person_id PERSON.PERSON_ID%type)
    is
    reservation_id RESERVATION.RESERVATION_ID%type;
begin
    if not trip_exists(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || ' doesn''t exist');
    elsif not PERSON_EXISTS(person_id) then
        raise_application_error(-20002, 'person wit id ' || person_id || ' doesn''t exist');
    elsif not trip_is_available(trip_id) then
        raise_application_error(-20003, 'trip with id ' || trip_id || ' is not available');
    elsif person_has_trip_reservation(person_id, trip_id) then
        raise_application_error(-20004,
                                'person with id ' || person_id || ' already has a reservation for trip with id ' ||
                                trip_id);
    end if;

    insert into RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (TRIP_ID, PERSON_ID, 'N') returning RESERVATION_ID into RESERVATION_ID;

    add_log(reservation_id, 'N');
end;


CREATE OR REPLACE FUNCTION reservation_exists(reservation_id RESERVATION.RESERVATION_ID%type)
    RETURN boolean
AS
    exist number;
BEGIN
    select case
               when exists(select *
                           from RESERVATION R
                           where R.RESERVATION_ID = reservation_exists.reservation_id) then 1
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


CREATE OR REPLACE PROCEDURE modify_reservation_status(reservation_id RESERVATION.TRIP_ID%type,
                                                      status RESERVATION.STATUS%type)
    is
    current_status RESERVATION.STATUS%type;
    trip_id        RESERVATION.TRIP_ID%type;
begin
    if not reservation_exists(reservation_id) then
        raise_application_error(-20001, 'reservation with id ' || reservation_id || ' doesn''t exist');
    end if;

    select R.STATUS, R.TRIP_ID
    into current_status, trip_id
    from RESERVATION R
    where R.RESERVATION_ID = modify_reservation_status.reservation_id;

    if current_status = status then
        return;
    elsif current_status = 'N' or
          current_status = 'P' or
          (current_status = 'C' and trip_is_available(trip_id)) then
        update RESERVATION R
        set R.STATUS = modify_reservation_status.status
        where R.RESERVATION_ID = modify_reservation_status.RESERVATION_ID;

        add_log(modify_reservation_status.reservation_id, modify_reservation_status.status);
    else
        raise_application_error(-20005, 'cannot change status of reservation with id ' || reservation_id ||
                                        ' , no free places on the trip');
    end if;
end;


create or replace procedure modify_no_places(trip_id TRIP.MAX_NO_PLACES%type, no_places number)
    is
    curr_no_places               number;
    curr_num_of_available_places number;
begin
    if not TRIP_EXISTS(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || '  doesn''t exist');
    end if;

    select T.NO_PLACES, NUM_OF_AVAILABLE_PLACES
    into curr_no_places, curr_num_of_available_places
    from TRIPS T
    where T.TRIP_ID = modify_no_places.trip_id;

    /* we can always increase number of places on a trip */
    /* we can lower number of places only by up to the number of currently available places */
    if no_places > curr_no_places or curr_no_places - no_places <= curr_num_of_available_places then
        update TRIP
        set MAX_NO_PLACES = no_places
        where TRIP_ID = modify_no_places.TRIP_ID;
    else
        raise_application_error(-20002,
                                'cannot set number of available places to ' || no_places || ' for trip with id ' ||
                                trip_id ||
                                '; otherwise there would be more reservations than places');
    end if;
end;


create or replace procedure add_log(reservation_id RESERVATION.RESERVATION_ID%type, status RESERVATION.STATUS%type)
    is
begin
    if not reservation_exists(reservation_id) then
        raise_application_error(-20006, 'reservation with id ' || reservation_id || ' doesn''t exist');
    end if;

    insert into LOG (RESERVATION_ID, LOG_DATE, STATUS)
    VALUES (add_log.reservation_id, current_date, add_log.status);
end;

create or replace trigger reservation_added
    after insert or update
    on RESERVATION
    for each row
begin
    insert into LOG (RESERVATION_ID, LOG_DATE, STATUS)
    VALUES (:NEW.reservation_id, current_date, :NEW.status);
end;


create or replace trigger reservation_removed
    before delete
    on RESERVATION
begin
    raise_application_error(-20001, 'you cannot completely remove any reservation from database;' ||
                                    'if you want to cancel a reservation, change it''s status to "C" (cancelled)');
end;

create or replace trigger about_to_add_reservation
    before insert
    on RESERVATION
    for each row
    disable
begin
    if not trip_is_available(:NEW.TRIP_ID) then
        raise_application_error(-20003, 'trip with id ' || :NEW.TRIP_ID || ' is not available');
    elsif person_has_trip_reservation(:NEW.PERSON_ID, :NEW.TRIP_ID) then
        raise_application_error(-20004,
                                'person with id ' || :NEW.PERSON_ID || ' already has a reservation for trip with id ' ||
                                :NEW.TRIP_ID);
    end if;
end;

create or replace trigger about_to_modify_reservation
    before update
    on RESERVATION
    for each row
    disable
begin
    /* cannot change reservation id, trip id nor person id */
    if :OLD.RESERVATION_ID != :NEW.RESERVATION_ID or
       :OLD.TRIP_ID != :NEW.TRIP_ID or
       :OLD.PERSON_ID != :NEW.PERSON_ID then
        raise_application_error(-20002, 'you cannot change reservation id, trip id nor person id of any reservation');
    end if;

    if :OLD.STATUS = 'C' and not trip_is_available(:OLD.TRIP_ID) then
        raise_application_error(-20005, 'cannot change status of reservation with id ' || :NEW.RESERVATION_ID ||
                                        ' , no free places on the trip');
    end if;
end;

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

alter table trip
    add no_available_places int;

alter table trip
    add constraint no_available_places_check1 check
        ( no_available_places >= 0 ) enable;


/* this procedure calculates number of available places and write it into the no_available_places column */
create procedure calculate_no_available_places
    is
begin
    update TRIP T
    set T.no_available_places = NVL((select NUM_OF_AVAILABLE_PLACES
                                 from AVAILABLETRIPS AvTr
                                 where AvTr.TRIP_ID = T.TRIP_ID), T.MAX_NO_PLACES);
end;

select *
from TRIP;

/* named with f_... because there already exists a view with the same name */
CREATE OR REPLACE FUNCTION f_available_trips_4(country COUNTRY.COUNTRY_NAME%type, date_from date, date_to date)
    RETURN available_trips_table
AS
    result available_trips_table;
BEGIN
    if not date_from < date_to then
        raise_application_error(-20001, 'ending date cannot be before starting date');
    end if;

    select available_trips(T.country,
                           T.trip_date,
                           T.trip_name,
                           T.max_no_places,
                           T.no_available_places) bulk collect
    into result
    from TRIP T
    where date_from < TRIP_DATE
      and TRIP_DATE < date_to
      and T.COUNTRY = f_available_trips_4.country;
    return result;
END;

create or replace procedure add_reservation_4(trip_id TRIP.TRIP_ID%type, person_id PERSON.PERSON_ID%type)
    is
begin
    if not trip_exists(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || ' doesn''t exist');
    elsif not PERSON_EXISTS(person_id) then
        raise_application_error(-20002, 'person wit id ' || person_id || ' doesn''t exist');
    elsif not trip_is_available(trip_id) then
        raise_application_error(-20003, 'trip with id ' || trip_id || ' is not available');
    elsif person_has_trip_reservation(person_id, trip_id) then
        raise_application_error(-20004,
                                'person with id ' || person_id || ' already has a reservation for trip with id ' ||
                                trip_id);
    end if;

    insert into RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (TRIP_ID, PERSON_ID, 'N');

    update TRIP
    set NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
    where TRIP_ID = add_reservation_4.TRIP_ID;
end;


CREATE OR REPLACE PROCEDURE modify_reservation_status_4(reservation_id RESERVATION.TRIP_ID%type,
                                                        status RESERVATION.STATUS%type)
    is
    current_status RESERVATION.STATUS%type;
    trip_id        RESERVATION.TRIP_ID%type;
begin
    if not reservation_exists(reservation_id) then
        raise_application_error(-20001, 'reservation with id ' || reservation_id || ' doesn''t exist');
    end if;

    select R.STATUS, R.TRIP_ID
    into current_status, trip_id
    from RESERVATION R
    where R.RESERVATION_ID = modify_reservation_status_4.reservation_id;

    if current_status = status then
        return;

    elsif (current_status = 'N' or current_status = 'P')  and status = 'C' then
        update RESERVATION R
        set R.STATUS = modify_reservation_status_4.status
        where R.RESERVATION_ID = modify_reservation_status_4.RESERVATION_ID;

        update TRIP
        set NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + 1
        where TRIP_ID = modify_reservation_status_4.trip_id;

    elsif (current_status = 'N' or current_status = 'P') and (status = 'N' or status = 'P') then
        update RESERVATION R
        set R.STATUS = modify_reservation_status_4.status
        where R.RESERVATION_ID = modify_reservation_status_4.RESERVATION_ID;

    elsif current_status = 'C' and TRIP_IS_AVAILABLE(trip_id) then
        update RESERVATION R
        set R.STATUS = modify_reservation_status_4.status
        where R.RESERVATION_ID = modify_reservation_status_4.RESERVATION_ID;

        update TRIP
        set NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
        where TRIP_ID = modify_reservation_status_4.trip_id;

    else
        raise_application_error(-20005, 'cannot change status of reservation with id ' || reservation_id ||
                                        ' , no free places on the trip');
    end if;
end;


create or replace procedure modify_no_places_4(trip_id TRIP.MAX_NO_PLACES%type, no_places number)
    is
    curr_no_places               number;
    curr_num_of_available_places number;
begin
    if not TRIP_EXISTS(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || '  doesn''t exist');
    end if;

    select T.MAX_NO_PLACES, NO_AVAILABLE_PLACES
    into curr_no_places, curr_num_of_available_places
    from TRIP T
    where T.TRIP_ID = modify_no_places_4.trip_id;

    /* we can always increase number of places on a trip */
    /* we can lower number of places only by up to the number of currently available places */
    if no_places > curr_no_places or curr_no_places - no_places <= curr_num_of_available_places then
        update TRIP
        set MAX_NO_PLACES = no_places, NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + no_places - curr_no_places
        where TRIP_ID = modify_no_places_4.TRIP_ID;
    else
        raise_application_error(-20002,
                                'cannot set number of available places to ' || no_places || ' for trip with id ' ||
                                trip_id ||
                                '; otherwise there would be more reservations than places');
    end if;
end;

create or replace procedure add_reservation_5(trip_id TRIP.TRIP_ID%type, person_id PERSON.PERSON_ID%type)
    is
begin
    if not trip_exists(trip_id) then
        raise_application_error(-20001, 'trip with id ' || trip_id || ' doesn''t exist');
    elsif not PERSON_EXISTS(person_id) then
        raise_application_error(-20002, 'person wit id ' || person_id || ' doesn''t exist');
    end if;

    insert into RESERVATION (TRIP_ID, PERSON_ID, STATUS)
    VALUES (TRIP_ID, PERSON_ID, 'N');
end;


CREATE OR REPLACE PROCEDURE modify_reservation_status_5(reservation_id RESERVATION.TRIP_ID%type,
                                                        status RESERVATION.STATUS%type)
    is
begin
    if not reservation_exists(reservation_id) then
        raise_application_error(-20001, 'reservation with id ' || reservation_id || ' doesn''t exist');
    end if;

    update RESERVATION R
    set R.STATUS = modify_reservation_status_5.status
    where R.RESERVATION_ID = modify_reservation_status_5.RESERVATION_ID;
end;

create or replace trigger about_to_add_reservation_5
    before insert
    on RESERVATION
    for each row
begin
    if not trip_is_available(:NEW.TRIP_ID) then
        raise_application_error(-20003, 'trip with id ' || :NEW.TRIP_ID || ' is not available');
    elsif person_has_trip_reservation(:NEW.PERSON_ID, :NEW.TRIP_ID) then
        raise_application_error(-20004,
                                'person with id ' || :NEW.PERSON_ID || ' already has a reservation for trip with id ' ||
                                :NEW.TRIP_ID);
    end if;

    update TRIP
    set NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
    where TRIP_ID = :NEW.TRIP_ID;
end;


create or replace trigger about_to_modify_reservation_5
    before update
    on RESERVATION
    for each row
begin
    /* cannot change reservation id, trip id nor person id */
    if :OLD.RESERVATION_ID != :NEW.RESERVATION_ID or
       :OLD.TRIP_ID != :NEW.TRIP_ID or
       :OLD.PERSON_ID != :NEW.PERSON_ID then
        raise_application_error(-20002, 'you cannot change reservation id, trip id nor person id of any reservation');
    end if;


    if :OLD.STATUS = :NEW.STATUS then
        return;

    elsif (:OLD.STATUS = 'N' or :OLD.STATUS = 'P')  and :NEW.STATUS = 'C' then
        update TRIP
        set NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES + 1
        where TRIP_ID = :OLD.TRIP_ID;

    elsif :OLD.STATUS = 'C' and TRIP_IS_AVAILABLE(:OLD.TRIP_ID) then
        update TRIP
        set NO_AVAILABLE_PLACES = NO_AVAILABLE_PLACES - 1
        where TRIP_ID = :OLD.TRIP_ID;

    elsif :OLD.STATUS = 'C' and not trip_is_available(:OLD.TRIP_ID) then
        raise_application_error(-20005, 'cannot change status of reservation with id ' || :NEW.RESERVATION_ID ||
                                        ' , no free places on the trip');
    else
        raise_application_error(-20006, 'unknown error');
    end if;
end;

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
