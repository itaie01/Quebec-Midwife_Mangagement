-- (a)
create view midwifeinfo (practID, mwname, phoneNum, email, hciname, addr) as
select m.practID, m.mwname, m.phoneNum, m.email, hci.hciname, hci.addr from
midwives m inner join healthcareInstitution hci on m.workplace = hci.phoneNum
;

-- (b)
select * from midwifeinfo
;

-- (c)
select * from midwifeinfo limit 5
;

-- (d)
select * from midwifeinfo 
where hciname = 'Lac-Saint-Louis'
limit 5
;

-- (e)
insert into midwifeinfo (practID, mwname, phoneNum, email, hciname, addr) VALUES
(100, 'Shelly Greene', '2012182142', 'shelly.greene@lacstlouis.ca', 'Lac-Saint-Louis', '72 Rue St. Louis')
;
/*
What happens is that DB2 gives an error SQLSTATE=42807. We are told that we are not allowed to insert values into a view — it is not permitted.
This occurss because the view is not a "hardwired" table. It doesn't know where to send what values you're trying to insert.
Since the database doesn't really "see" specific columns, the information, if we were allowed to insert it, could be inserted
into columns where it wasn't intended on going. Inserting into views is not permitted as a safety precaution to attempt to ensure
that the database does not break.
*/