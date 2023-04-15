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
