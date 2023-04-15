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