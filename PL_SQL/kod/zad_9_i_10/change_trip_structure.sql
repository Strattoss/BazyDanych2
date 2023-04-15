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