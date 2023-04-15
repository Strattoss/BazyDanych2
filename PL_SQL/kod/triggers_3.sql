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
