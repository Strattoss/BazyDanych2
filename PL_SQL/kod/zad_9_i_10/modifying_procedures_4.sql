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
