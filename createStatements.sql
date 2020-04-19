/* Paul Macfarlane and (partially from CSIS  350) Will Skelly
CSIS 355: Advanced Databases
Dr Vandenberg
DEMO Project
create.sql - This is just the create statements and the constraints for the database. Includes, check, trigger, view, and secondary indices.
*/

drop table company1 cascade constraints;
drop table brand1 cascade constraints;
drop table beverage1 cascade constraints;
drop table location1 cascade constraints;
drop table employee1 cascade constraints;
drop table works_at1 cascade constraints;
drop table sold_at1 cascade constraints;
drop table recent_prices1 cascade constraints;
drop view StoreManagers1;
drop view ViewAllInStock1;

create table company1 (
	taxID number(7) primary key,
	cname varchar(30) unique not null,
  hq varchar(30),
	cphone char(10),
	email varchar(30));

create table brand1 (
	taxID number(7) references company1 (taxID) on delete cascade,
	bname varchar(20) unique not null,
	bphone char(10),
	email varchar(30),
	primary key (taxID,bname));

create table beverage1 (
		bevID number(6) primary key,
		bevtype varchar(6), /*only 'beer', 'wine', 'liquor' */
		bevname varchar(20),
	  percentA decimal(5,2), /* 0 - 100 */
	  bevbrand varchar(20),
	  bevTaxID number(7),
		foreign key (bevbrand,bevTaxID) references brand1(bname,taxID) on delete cascade
);
alter table beverage1 add constraint bev_typecheck1 check ((bevtype = 'beer') or (bevtype = 'liquor') or (bevtype = 'wine'));

alter table beverage1 add constraint percentAcheck1 check ((percentA >= 0.0) and (percentA <= 100.0));

create table location1 (
	storeId number(6) primary key,
	addr varchar(50),
	lphone char(10),
	locname varchar(30)
);

create table sold_at1 (
	bevID references beverage1(bevID),
	storeId references location1(storeId),
	price decimal(5,2),
	primary key (bevID, storeId)
);

create index price_index1
on sold_at1 (price);

create table employee1 (
	ssn number(9) primary key,
	fname varchar(30),
	lname varchar(30),
	addr varchar(50),
	ephone char(10)
);

create index lname_index1
on employee1 (lname);

create index fname_index1
on employee1 (fname);

create table works_at1 (
	essn references employee1(ssn),
	salary decimal(10,2),
    storeId references location1(storeId),
	hoursperweek number, /* >=0 <=40 We don't pay overtime */
	isMgr char(1) not NULL,
	primary key (essn, storeId)
);

-- stores the most recent prices for all beverages sold at each store
create table recent_prices1
(
	bevID references beverage1(bevID),
	storeId references location1(storeId),
	price decimal(5,2),
	timeSet TIMESTAMP,
	primary key (bevID, storeId,timeSet)
);

alter table works_at1 add constraint noOvertime check ((hoursperweek >= 0) and (hoursperweek <= 40));

/* create a view for our database, see information about managers */
CREATE VIEW StoreManagers1 AS
SELECT W.essn, W.isMgr, E.fname, E.lname, W.storeId
FROM works_at1 W, employee1 E
WHERE W.essn = E.ssn and W.isMgr = 'T';

/* create a view to see the name and price of all the beverages at all locations */
create view ViewAllInStock1 AS
select B.bevname, S.price, L.locname
from beverage1 B, sold_at1 S, location1 L
where B.bevID = S.BevID and S.storeId = L.StoreId
order by L.locname;
