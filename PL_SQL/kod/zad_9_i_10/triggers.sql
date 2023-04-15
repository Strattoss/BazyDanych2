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
