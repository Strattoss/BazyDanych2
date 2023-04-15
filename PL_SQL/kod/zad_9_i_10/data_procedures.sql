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
