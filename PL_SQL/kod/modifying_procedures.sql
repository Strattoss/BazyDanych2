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
