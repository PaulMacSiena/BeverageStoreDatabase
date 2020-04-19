/* Paul Macfarlane 
CSIS 355: Advanced Databases
Dr Vandenberg
DEMO Project
insert.sql - This is just the insert statements and select statements to display the data and check constraints
No functional dependencies. The primary key for every entity determines all other attributes of that entity
*/

insert into company1 values (1123000, 'Anheuser-Busch InBev', 'Leuven, Belgium', '1112223333','abisales@gmail.com');

insert into company1 values (3210000, 'Heineken Holding', 'Netherlands', '4445556666','hhsales@gmail.com');

insert into company1 values (4444000, 'Casella Family Brand', 'Australia', '7778889999','caselafamilybrand@gmail.com');

insert into company1 values (1111111, 'Bacardi', 'Hamilton, Bermuda', '0000000000','partywithbacardi@gmail.com');

select * from company1;

/*********************************************************/

insert into brand1 values(1123000, 'Corona','1234567890','corona@gmail.com');

insert into brand1 values(1123000, 'Budweiser','1234567891','bud@gmail.com');

insert into brand1 values(3210000, 'Heineken','4445556667','heinekenbrand@gmail.com');

insert into brand1 values(4444000, 'Yellow Tail', '7778889991','cheapestwineever@gmail.com');

insert into brand1 values(4444000, 'Peter Lehmann','7778889992','plwines@gmail.com');

insert into brand1 values(1111111, 'Bacardi','0000000001','bacardibrand@gmail.com');

insert into brand1 values(1111111, 'Grey Goose','0000000002','ggbrand@gmail.com');

select * from brand1;
/*********************************************************/

insert into beverage1 values('012345','beer','Corona Extra', 4.6, 'Corona',1123000);

insert into beverage1 values('012346','beer','Corona Light', 4.1, 'Corona',1123000);

insert into beverage1 values('123456','beer','Budweiser', 5.0, 'Budweiser',1123000);

insert into beverage1 values('123457','beer','Bud Light', 5.0, 'Budweiser',1123000);

insert into beverage1 values('234567','beer','Heineken Light', 3.3, 'Heineken',3210000);

insert into beverage1 values('345678','wine','YT Chardonay', 11.6, 'Yellow Tail',4444000);

insert into beverage1 values('456789','liquor','Bacardi Lemon', 35.0, 'Bacardi',1111111);

insert into beverage1 values('456780','liquor','Bacardi Lime', 15.0, 'Bacardi',1111111);

insert into beverage1 values('111111','liquor','Cherry Noir',40.0,'Grey Goose',1111111);

select * from beverage1;

/* Test check constraint on percentAcheck and bev_typecheck */
insert into beverage1 values('000033','liq','Cherry Noir',40.0,'Grey Goose',1111111);
insert into beverage1 values('120467','som','Cherry Noir',40.0,'Grey Goose',1111111);
insert into beverage1 values('120467','som','Cherry Noir',-1.0,'Grey Goose',1111111);
insert into beverage1 values('120467','som','Cherry Noir',101.0,'Grey Goose',1111111);

/*********************************************************/

insert into location1 values(111111,'28 Carriage Road, Delmar, NY 12054','5185185188','Pauls Liq Picks');

insert into location1 values(222222,'515 New Loudon Rd, Loudonville, NY 12211','2348930931','Siena Suppliers');

insert into location1 values(333333,'7 Airline Dr, Albany, NY 12011','8983649261','Christian Brothers Beer');

insert into location1 values(444444,'Mccloskey Square TH 3, Loudonville NY 12211', '6666666666','Wills Wine');

select * from location1;

/*********************************************************/

insert into sold_at1 values('456789',111111,21.21);

insert into sold_at1 values('456780',111111,21.21);

insert into sold_at1 values('111111',111111,26.99);

/* Siena would overcharge for everything */
insert into sold_at1 values('111111',222222,29.99);

insert into sold_at1 values('123457',222222,20.99);

insert into sold_at1 values('234567',222222,22.99);

insert into sold_at1 values('345678',222222,25.99);

insert into sold_at1 values('012345',333333,19.99);

insert into sold_at1 values('012346',333333,19.99);

insert into sold_at1 values('123456',333333,19.99);

insert into sold_at1 values('123457',333333,19.99);

insert into sold_at1 values('234567',333333,19.99);

insert into sold_at1 values('345678',444444,20.99);

select * from sold_at1;
/*********************************************************/

insert into employee1 values('100000000','John','Hancock','Fake Address 1','1990990099');

insert into employee1 values('111111111','Will','Smith','Fake Address 2','1110110011');

insert into employee1 values('222222222','John','Hancock','Fake Address 3','1220220022');

insert into employee1 values('333333333','Suzy','Johnson','Fake Address 4','1330330033');

insert into employee1 values('444444444','Alexia','Martinez','Fake Address 5','1440440044');

insert into employee1 values('555555555','Carlos','Beltran','Fake Address 6','1550550055');

insert into employee1 values('666666666','Tom','Cruise','Fake Address 7','1660660066');

insert into employee1 values('777777777','Hilary','Clinton','Fake Address 8','1770770077');

insert into employee1 values('888888888','Ariana','Grande','Fake Address 9','1880880088');

insert into employee1 values('999999999','Tom','Brady','Fake Address 10','2990990099');

/*********************************************************/

/* test check constraint on noOvertime */
insert into works_at1 values('100000000',20.00,111111,45,'T');
insert into works_at1 values('100000000',20.00,111111,-1,'T');

insert into works_at1 values('100000000',20.00,111111,40,'T');

insert into works_at1 values('111111111',13.00,111111,35,'F');

insert into works_at1 values('222222222',13.00,111111,40,'F');

insert into works_at1 values('333333333',17.00,222222,40,'T');

insert into works_at1 values('444444444',11.50,222222,25,'F');

insert into works_at1 values('555555555',11.50,222222,40,'F');

insert into works_at1 values('666666666',19.00,333333,40,'T');

insert into works_at1 values('777777777',14.50,333333,30,'F');

insert into works_at1 values('888888888',14.50,333333,40,'F');

insert into works_at1 values('999999999',40.00,444444,40,'T');

select * from works_at1;

select * from storemanagers1;

insert into recent_prices1 values('456789',111111,21.21);

insert into recent_prices1 values('456780',111111,21.21);

insert into recent_prices1 values('111111',111111,26.99);

/* Siena would overcharge for everything */
insert into recent_prices1 values('111111',222222,29.99);

insert into recent_prices1 values('123457',222222,20.99);

insert into recent_prices1 values('234567',222222,22.99);

insert into recent_prices1 values('345678',222222,25.99);

insert into recent_prices1 values('012345',333333,19.99);

insert into recent_prices1 values('012346',333333,19.99);

insert into recent_prices1 values('123456',333333,19.99);

insert into recent_prices1 values('123457',333333,19.99);

insert into recent_prices1 values('234567',333333,19.99);

insert into recent_prices1 values('345678',444444,20.99);

select * from recent_prices1;
/* results from select on view storemanagers

ESSN I FNAME                          LNAME                          ADDR
---------- - ------------------------------ ------------------------------ --------------------------------------------------
100000000 T John                           Hancock                        28 Carriage Road, Delmar, NY 12054
333333333 T Suzy                           Johnson                        515 New Loudon Rd, Loudonville, NY 12211
666666666 T Tom                            Cruise                         7 Airline Dr, Albany, NY 12011
999999999 T Tom                            Brady                          Mccloskey Square TH 3, Loudonville NY 12211

*/

select * from ViewAllInStock1;

/* results from select on view ViewAllInStock
BEVNAME                   PRICE LOCNAME
-------------------- ---------- ------------------------------
Corona Light              19.99 Christian Brothers Beer
Budweiser                 19.99 Christian Brothers Beer
Bud Light                 19.99 Christian Brothers Beer
Corona Extra              19.99 Christian Brothers Beer
Heineken Light            19.99 Christian Brothers Beer
Bacardi Lemon             21.21 Pauls Liq Picks
Cherry Noir               26.99 Pauls Liq Picks
Bacardi Lime              21.21 Pauls Liq Picks
YT Chardonay              25.99 Siena Suppliers
Bud Light                 20.99 Siena Suppliers
Heineken Light            22.99 Siena Suppliers

BEVNAME                   PRICE LOCNAME
-------------------- ---------- ------------------------------
Cherry Noir               29.99 Siena Suppliers
YT Chardonay              20.99 Wills Wine
*/


