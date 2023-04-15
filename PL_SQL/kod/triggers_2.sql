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
