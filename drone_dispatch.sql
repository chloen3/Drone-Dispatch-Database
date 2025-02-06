-- CS4400: Introduction to Database Systems (Spring 2024)

-- Team
-- Chloe Nicola
-- Emma Blazejewski
-- Blake Rodgers
-- Charlie Hamilton


/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
    if not exists (select uname from users where uname = ip_uname) then
        insert into users (uname, first_name, last_name, address, birthdate) 
        values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    end if;
    if not exists (select uname from customers where uname = ip_uname) then
        insert into customers (uname, rating, credit) 
        values (ip_uname, ip_rating, ip_credit);
    else
        update customers
        set rating = ip_rating, credit = ip_credit 
        where uname = ip_uname;
    end if;
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	if not exists (select uname from users where uname = ip_uname) then
        insert into users (uname, first_name, last_name, address, birthdate) 
        values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    end if;
    if not exists (select uname from employees where uname = ip_uname) then
        insert into employees (uname, taxID, service, salary) 
        values (ip_uname, ip_taxID, ip_service, ip_salary);
    else
        update employees 
        set taxID = ip_taxID, service = ip_service, salary = ip_salary 
        where uname = ip_uname;
    end if;
    if not exists (select uname from drone_pilots where uname = ip_uname) then
        insert into drone_pilots (uname, licenseID, experience) 
        values (ip_uname, ip_licenseID, ip_experience);
    else
        update drone_pilots 
        set licenseID = ip_licenseID, experience = ip_experience 
        where uname = ip_uname;
    end if;
end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	if not exists (select barcode from products where barcode = ip_barcode) then
        insert into products (barcode, pname, weight) 
        values (ip_barcode, ip_pname, ip_weight);
    else
        update products 
        set pname = ip_pname, weight = ip_weight 
        where barcode = ip_barcode;
    end if;
end //
delimiter ;

-- add drone
delimiter //
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
	if not exists (select 1 from drones where storeID = ip_storeID and droneTag = ip_droneTag) then
        insert into drones (storeID, droneTag, capacity, remaining_trips, pilot) 
        values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
    else
        update drones 
        set capacity = ip_capacity, remaining_trips = ip_remaining_trips, pilot = ip_pilot 
        where storeID = ip_storeID and droneTag = ip_droneTag;
    end if;
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	if exists (select uname from customers where uname = ip_uname) then
        -- Increase the customer's credits
        update customers
        set credit = credit + ip_money
        where uname = ip_uname;
    end if;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
	if exists (select uname from drone_pilots where uname = ip_incoming_pilot) then
        update drones
        set pilot = ip_incoming_pilot
        where pilot = ip_outgoing_pilot;
    end if;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	if exists (select 1 from drones where storeID = ip_drone_store and droneTag = ip_drone_tag) then
        update drones
        set remaining_trips = remaining_trips + ip_refueled_trips
        where storeID = ip_drone_store and droneTag = ip_drone_tag;
    end if;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	insert into orders (orderID, sold_on, purchased_by, carrier_store, carrier_tag)
    values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
    insert into order_lines (orderID, barcode, price, quantity)
    values (ip_orderID, ip_barcode, ip_price, ip_quantity);
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution as
select 'users' as category, count(distinct uname) as total from users
union 
select 'customers', count(distinct uname) from customers
union
select 'employees', count(distinct uname) from employees
union
select 'customer_employer_overlap', count(distinct customers.uname) 
    from customers inner join employees on customers.uname = employees.uname 
union 
select 'drone_pilots', count(distinct uname) from drone_pilots
union 
select 'store_workers', count(distinct uname) from store_workers
union
select 'other_employee_roles', count(distinct e.uname) from employees e 
    where not exists (select uname from drone_pilots where uname = e.uname) 
    and not exists (select uname from store_workers where uname = e.uname);

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
select 
c.uname as customer_name, 
c.rating, 
c.credit as current_credit, 
sum(ol.price*ol.quantity) as credit_already_allocated
from customers c  join orders o on c.uname = o.purchased_by
join order_lines ol on o.orderID = ol.orderID group by o.purchased_by
union 
select uname, rating, credit as current_creditas, 0 from customers where customers.uname not in (select purchased_by from orders);

-- display drone status and current activity
create or replace view drone_traffic_control as
select 
    d.storeID as drone_serves_store,
    d.droneTag as drone_tag,
    dp.uname as pilot,
    d.capacity as total_weight_allowed,
    COALESCE(sum(p.weight * ol.quantity), 0) as current_weight,
    d.remaining_trips as deliveries_allowed,
    COALESCE(count(distinct o.orderID), 0) as deliveries_in_progress
from drones d
left join drone_pilots dp on d.pilot = dp.uname
left join orders o on (d.storeID = o.carrier_store and d.droneTag = o.carrier_tag)
left join order_lines ol on o.orderID = ol.orderID
left join products p on ol.barcode = p.barcode
group by d.storeID, d.droneTag, dp.uname, d.capacity, d.remaining_trips;


-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
select 
products.barcode,
products.pname as prodcut_name, 
products.weight,
min(ol.price) as lowest_price,
max(ol.price) as highest_price,
if(min(ol.quantity) is not null, min(ol.quantity), 0) as lowest_quantity, 
if(max(ol.quantity) is not null, max(ol.quantity), 0) as highest_quantity, 
if(sum(ol.quantity) is not null, sum(ol.quantity), 0) as total_quantity
from products 
left join order_lines ol 
on products.barcode = ol.barcode 
group by products.barcode;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
select 
drone_pilots.uname as pilot, 
drone_pilots.licenseID,
drones.storeID as drone_serves_store, 
drones.droneTag,
drone_pilots.experience as successful_deliveries , 
0 as pending_deliveries
from drone_pilots
left join drones on drone_pilots.uname = drones.pilot
where drone_pilots.uname not in (select pilot as remaining_deliveries from orders o join drones dr on (o.carrier_store, o.carrier_tag) = (dr.storeID, dr.droneTag))
union 
select 
dr.pilot, drone_pilots.licenseID, dr.storeID, dr.droneTag, drone_pilots.experience, count(*) AS order_count
from orders o join drones dr on (o.carrier_store = dr.storeID and o.carrier_tag = dr.droneTag)
join drone_pilots on dr.pilot = drone_pilots.uname group by dr.pilot, drone_pilots.licenseID, dr.storeID, dr.droneTag, drone_pilots.experience;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
select 
stores.storeID as store_id,
stores.sname,
stores.manager,
stores.revenue, 
sum(ol.price*ol.quantity) as incoming_revenue,
count(distinct o.orderID) as incoming_orders
from order_lines ol join orders o on ol.orderID = o.orderID 
join stores on o.carrier_store = stores.storeID
group by o.carrier_store;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
select 
orders.orderID, 
sum(ol.price * ol.quantity) as cost, 
count(ol.orderID) as num_products, 
sum(products.weight * ol.quantity) as payload, 
group_concat(products.pname) as contents
from orders
join drones 
on (orders.carrier_store, orders.carrier_tag) = (drones.storeID, drones.droneTag) 
join order_lines ol 
on orders.orderID = ol.orderID 
join products on  products.barcode = ol.barcode
group by ol.orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	-- place your solution here
end //
delimiter ;
