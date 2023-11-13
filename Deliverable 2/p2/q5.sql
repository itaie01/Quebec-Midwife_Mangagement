-- (a)
select distinct appointmentTimes.heldDate, appointmentTimes.heldTime, motherInfo.hCardID, motherInfo.pname, motherInfo.phoneNum from
(select heldDate, heldTime, pregID from appointments a 
where a.practID = (select practID from midwives where mwname = 'Marion Girard')
and heldDate <= '2022-03-25' and heldDate >= '2022-03-21')appointmentTimes
inner join
(select p.hCardID, p.pname, p.phoneNum, identifyMothers.pregID from (
    select hCardID, mGirdardCouples.pregID from (
        select coupleID, mGirardPregIDs.pregID from (
            select pregID from 
            appointments where practID = (
                select practID from midwives where mwname = 'Marion Girard')
            )mGirardPregIDs
        inner join pregnancy pg on pg.pregID = mGirardPregIDs.pregID)mGirdardCouples
    inner join couples c on c.coupleID = mGirdardCouples.coupleID)identifyMothers
inner join parent p on p.hCardID = identifyMothers.hCardID)motherInfo
on appointmentTimes.pregID = motherInfo.pregID
order by appointmentTimes.heldDate
;

-- (b)
select t.labWorkDate, t.result from (
    select td.testID from (
        select pg.pregID from (
            select c.coupleID from (
                select m.hCardID from
                parent p inner join mother m
                on p.hCardID = m.hCardID
                where p.pname = 'Victoria Gutierrez'
                )victoria
            inner join couples c on c.hCardID = victoria.hCardID)victoriaCouple
        inner join pregnancy pg on pg.coupleId = victoriaCouple.coupleID
        where pg.pregNum = 2)victoriaSecondPreg
    inner join testsTakenDuring td on td.pregID = victoriaSecondPreg.pregID)victoriaSecondPregTests
inner join tests t on t.testID = victoriaSecondPregTests.testID
;

-- (c)
select distinct hciname, count (hciname) as numPreg from (
    select workplace from (
        select ppractID from pregnancy pg
        where case when fnlDueDate=NULL then extract (month from origDueDate)=07 
                else extract (month from fnlDueDate)=07
            end)julyMidwives
    inner join midwives m on m.practID = julyMidwives.ppractID)workplaceIDs
inner join healthcareInstitution hci on hci.phoneNum = workplaceIDs.workplace
group by hci.hciname
;

-- (d)
select distinct lacLouisPregMothers.hCardID, p.pname, p.phoneNum from (
    select m.hCardID, lacLouisPregCouples.pregID from (
        select c.hCardID, coupleAndPregIDs.pregID from (
            select pg.coupleID, pg.pregID from (
                select practID from midwives
                where workplace = (select bc.phoneNum from birthingCenter bc inner join healthcareInstitution hci on bc.phoneNum = hci.phoneNum where hci.hciname='Lac-Saint-Louis')
            )lacStLouisMidwives
            inner join pregnancy pg on pg.ppractID = lacStLouisMidwives.practID)coupleAndPregIDs
        inner join couples c on c.coupleID = coupleAndPregIDs.coupleID)lacLouisPregCouples
    inner join mother m on m.hCardID=lacLouisPregCouples.hCardID)lacLouisPregMothers
inner join parent p on p.hCardID = lacLouisPregMothers.hCardID
where lacLouisPregMothers.pregID not in (
    select pregID from babies
)
;

-- (e)
select distinct mothersMoreThanOnePregnancy2.hCardID, p.pname from (
    select mothersMoreThanOnePregnancy.hCardID from (
        select c.hCardID from (
            select coupleID from pregnancy where numBabies > 1
        )moreThanOnePregnancy
        inner join couples c on c.coupleID = moreThanOnePregnancy.coupleID
    )mothersMoreThanOnePregnancy
    inner join mother m on m.hCardID = mothersMoreThanOnePregnancy.hCardID
)mothersMoreThanOnePregnancy2
inner join parent p on p.hCardID = mothersMoreThanOnePregnancy2.hCardID
;