/*
Paul Macfarlane 
CSIS 355: Advanced Databases
Dr Vandenberg
DEMO Project - Modules
*/

create or replace Function GetWeeklyPayroll
/*
Function to get weekly payroll for a given location
@param varInStoreId - Id for location
@return varweeklypayroll - Weekly payroll for the location
*/
    -- takes store address as input
    (
    varInStoreId VARCHAR
    )
    -- return the weekly payroll
    return Varchar
    is varWeeklyPayroll varchar(20);

    -- cursor to run through the employees at the location
    cursor empCursor is 
    select salary, hoursperweek 
    from works_at1 where storeId = varInStoreId;

Begin 

    varweeklypayroll :=0; 
 
 -- quick for loop, increment the weekly payroll by summing up weekly salaries for each worker  
    for emp in empCursor
    loop      
        varweeklypayroll := varweeklypayroll + (emp.salary * emp.hoursperweek);
    end loop;

    return varweeklypayroll;
End;




create or replace Function checkStoreForBev
    /*
    Function checkStoreForBev - checks a location for a particular beverage, return 1 (true) or 0 (false)
    @param varInBevID - Id for beverage
    @param varInStoreId - Id for store/location
    */
    -- takes bevId as input
    (
    varInBevId number,
    varInStoreId number
    )
    -- return a boolean of whether or not a beverage exists in the store
    return number
    is bevExistsInStore number;

    -- cursor to run through the beverages at a location
    cursor storeCursor is 
    select bevId 
    from sold_at1 
    where storeId = varInStoreId;

Begin 
  bevExistsInStore:= 0;
    -- loop through store cursor to see if there the bev is already in store, return if true
    for bev in storeCursor
    loop
      if (bev.bevId = varInBevId) then
        bevExistsInStore :=1;
        return bevExistsInStore;
      end if;
    end loop;
    
    -- if not found return false
    return  bevExistsInStore;
end;









create or replace PROCEDURE NewShipment (inStoreId number, inBrand char, inPrice number)
/*
 Procerdue NewShiptment - Adds all beverages from a particular brand to a location
 @param inStoreId - StoreId for location
 @param inBrand - Brand that will send items to location
 @param inPrice - Price that these items will be set to intially
*/
AS 
  varStoreId number;
  varBrand varchar(20);
  varPrice number;
  varBevId number;
  varInStore number; -- variable to check and see if a particular beverage is already at a location
  varBevName varchar(20);
  
  -- make cursor to grab all the beverages from a particular brand
  cursor bevCursor is 
  select bevId, bevname
  from beverage1
  where bevBrand = inBrand;

BEGIN
  varStoreId := inStoreId;
  varPrice := inPrice;
  varInStore:= 1; -- default will be true, would rather have something NOT be inserted by mistake than the other way around
  
  -- loop through all the beverages from the inputed brand
  for bev in bevCursor
  loop
    varBevId := bev.bevId;
    varBevName  := bev.bevname;
    
    
    -- check the store to see if it contains the beverage already (0 = false, 1 = true)
    -- Hindsight is 2020, but I probably could have created a trigger for this.....
    select checkstoreforbev(varBevId, varStoreId) into varInStore from location1 where storeId = varStoreId;

    if (varInStore =0) then -- if not, then insert into the locaton
      DBMS_OUTPUT.PUT_LINE('Inserting beverage ' || varBevName || ' with id ' || varBevId || ' into location ' || varStoreId
      || ' at price ' || inPrice);
      insert into sold_at1 values(bev.bevId, varStoreId, inPrice);
    else -- otherwise prevent the insertion
      DBMS_OUTPUT.PUT_LINE('The beverage ' || varBevName || ' with id ' || varBevId || ' already exists at location ' || varStoreId);
    end if;
    
  end loop;
    
      
END;



create or replace trigger UpdateRecentPrice after
update of price on sold_at1
/*
Trigger UpdateRecentPrice - fires after update of price on sold_at1 table
Enters into the recent prices table the value of a specific item.
Ensures that there is a record of when the price changed for a particular item, and what that price was
*/

--grab the old price and associated data for a beverage 
for each row
    declare 
    oldPrice number;
    newStoreId number;
    newBevId number;

begin
OldPrice:= :old.Price;
newStoreId:= :new.StoreId;
newBevId:= :new.BevId;

-- insert into the recent prices tables the most recent price before the price change
insert into RECENT_PRICES1 values (newBevId, newStoreId, OldPrice, CURRENT_TIMESTAMP);

DBMS_OUTPUT.PUT_LINE('Inserted into table recent_Prices1 ' || newBevId
|| ' ' ||newStoreId || ' ' || OldPrice || ' ' || CURRENT_TIMESTAMP);

RETURN;

END;

----------------------------------------------

create or replace trigger InsertIntoRecentPrice after
insert on sold_at1
/*
Trigger InsertIntoRecentPrice - fires after insertion of value on sold_at1 table
Enters into the recent prices table the value of a specific item.
Ensures that there is a record of when the price changed for a particular item
*/

-- Grab the data from the new sold_at1 row
for each row
    declare 
    newPrice number;
    newBevId number;
    newStoreId number;

begin
NewPrice:= :new.Price;
newStoreId:= :new.StoreId;
newBevId:= :new.BevId;

-- insert data from new sold_at1 row into recent_prices1
insert into RECENT_PRICES1 values (newBevId, newStoreId, NewPrice, CURRENT_TIMESTAMP);

DBMS_OUTPUT.PUT_LINE('Inserted into table recent_Prices1 ' || newBevId
|| ' ' ||newStoreId || ' ' || NewPrice || ' ' || CURRENT_TIMESTAMP);

RETURN;

END;

-----------------------------------------------------

create or replace trigger LimitRecentPrices before
insert on recent_prices1
/*
Trigger - LimitRecentPrices - fires before insertion of row on recent_prices1 table
Fires where there are 3 records in the recent_prices table and an insert is attempted
Ensures that there are no more than 3 records of recent prices for a given location and beverage combo
by deleting the oldest row and inserting the new update
*/

-- Grab the data from the new sold_at1 row
for each row
    declare 
    varBevId number;
    varStoreId number;
    rowCount number;
    oldestTimeStamp timestamp;
    
begin

  varBevId:= :new.bevId;
  varStoreId:= :new.storeId;
  
  -- count the number of records with the same beverage and store
  select count(*) into rowcount
    from recent_prices1 
    where bevId = varBevId and storeId = varStoreId;
  
  -- if there are more than 3, delete the oldest one
  if (rowcount >=3) then
    select min(timeSet) into oldestTimeStamp
    from recent_prices1 
    where bevId = varBevId and storeId = varStoreId;
    
    delete from recent_prices1 where
    bevId = varBevId and storeId = varStoreId and timeSet = oldestTimeStamp;
    
    DBMS_output.put_line('Removed record ' || varBevId || ' ' || varStoreId || ' ' || oldestTimeStamp);
  end if;

RETURN;

END;

------------------------------------------------
create or replace trigger maxHighlyPaidEmployees before
insert or update on works_at1
/*
Trigger - maxHighlyPaidEmployees - Makes sure that there are not more than 1 employees who make more than $30 an hour
fire when there is an attempt to add more than 1 employee with salary of $30/hour
*/

-- Grab the data from the new  row
for each row
    declare 
    pragma autonomous_transaction;
    varRowCount number;
    varStoreId number;
    varSalary number;
    
begin
  varStoreId := :new.StoreId;
  varSalary := :new.salary;
  
  -- the salary of the update or insert is greater than 30, see if we can still update
  if (varSalary >30) then
    -- count employees at location
    select count(*) into varRowCount 
    from works_at1 
    where storeId = varStoreId and salary >30; 
  
    -- if >= 1 employee is paid more than $30, prevent the insertion of another one
    if (varRowCount >= 1)then
      RAISE_APPLICATION_ERROR(-20007, 'You cannot pay two employees more than $30/hour at locationId: ' || varStoreId || ' we cannot afford that!');
    end if;
  
  end if;
  
RETURN;

END;
