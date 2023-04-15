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
