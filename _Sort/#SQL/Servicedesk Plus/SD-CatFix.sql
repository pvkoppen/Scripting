/*
SELECT wo.WORKORDERID "ReqID",cd.CATEGORYID "CatID",cd.CATEGORYNAME "CatName",scd.SUBCATEGORYID "SubCatID",scd.NAME "SubCatName",icd.ITEMID,icd.NAME "Item" ,cd2.CATEGORYID "CatID2",cd2.CATEGORYNAME "CatName2" FROM WorkOrder wo 
LEFT JOIN WorkOrderStates wos       ON wo.WORKORDERID=wos.WORKORDERID 
LEFT JOIN CategoryDefinition cd     ON wos.CATEGORYID=cd.CATEGORYID 
LEFT JOIN SubCategoryDefinition scd ON wos.SUBCATEGORYID=scd.SUBCATEGORYID 
LEFT JOIN ItemDefinition icd        ON wos.ITEMID=icd.ITEMID 
LEFT JOIN CategoryDefinition cd2    ON scd.CATEGORYID=cd2.CATEGORYID 
WHERE (wo.ISPARENT='1')  and Not (cd.CATEGORYID=cd2.CATEGORYID)
ORDER BY 4
*/

-- UPDATE WorkOrderStates SET SUBCATEGORYID = '601' WHERE SUBCATEGORYID = '2' -- Core,AD
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '601' WHERE SUBCATEGORYID = '319'
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '601' and CATEGORYID <> '3'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '601' WHERE SUBCATEGORYID = '1'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '601' WHERE SUBCATEGORYID = '3'
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '601' and CATEGORYID <> '3'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310' WHERE SUBCATEGORYID = '4' -- Tools,Desktop
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '5' and CATEGORYID <> '9'
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '6' and CATEGORYID <> '9'
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '7' and CATEGORYID <> '3'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '327' WHERE SUBCATEGORYID = '8' -- ?,?
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '9' and CATEGORYID <> '3'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '315' WHERE SUBCATEGORYID = '10' -- ?,?
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '615' WHERE SUBCATEGORYID = '11' -- Infra,Server
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '928' WHERE SUBCATEGORYID = '12' -- tools,desktop,Mobile
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '928' WHERE SUBCATEGORYID = '13' -- tools,desktop,Mobile
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '15' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '16' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '608' WHERE SUBCATEGORYID = '17' -- Core,Backup 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '608' WHERE SUBCATEGORYID = '18' -- Core,Backup 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '20' and CATEGORYID <> '9'
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '23' and CATEGORYID <> '3'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '313', ITEMID = '907' WHERE SUBCATEGORYID = '28' -- Infa,Lan,Cabling
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '354', ITEMID = '902' WHERE SUBCATEGORYID = '29' -- Infa,Connect,LandLine
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '30' and CATEGORYID <> '3'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '313', ITEMID = '909' WHERE SUBCATEGORYID = '32' -- Infa,Lan,Wireless
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '301' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '302' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '303' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '304' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '305' and CATEGORYID <> '1'
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '930' WHERE SUBCATEGORYID = '308' -- Tools,Desk,MFC
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '926' WHERE SUBCATEGORYID = '309' -- Tools,Desk,AV
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310' WHERE SUBCATEGORYID = '311' -- Tools,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '929' WHERE SUBCATEGORYID = '312' -- Tools,Desk,Medical
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '927' WHERE SUBCATEGORYID = '314' -- Tools,Desk,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310' WHERE SUBCATEGORYID = '317' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '927' WHERE SUBCATEGORYID = '318' -- Tools,Desk,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '313' WHERE SUBCATEGORYID = '321' -- Infra,Lan
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '322' and CATEGORYID <> '3' -- Core,DNS
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '354', ITEMID = '901' WHERE SUBCATEGORYID = '323' -- Infra,Connect,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '324' and CATEGORYID <> '9' -- Core,DNS
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '354' WHERE SUBCATEGORYID = '326' -- Infra,Lan
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '327' and CATEGORYID <> '9' -- Core,DNS
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '346' WHERE SUBCATEGORYID = '328' -- Core,Exch
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '928' WHERE SUBCATEGORYID = '329' -- Tools,Desk,Mob
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '330' and CATEGORYID <> '1' -- Tools,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '331' and CATEGORYID <> '1' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '348' WHERE SUBCATEGORYID = '335' -- Core,RDP
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '336' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '337' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '338' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '339' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '612' WHERE SUBCATEGORYID = '340' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '341' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '5', ITEMID = '936' WHERE SUBCATEGORYID = '342' -- Tools,Office,Outlook
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID = '343' and CATEGORYID <> '1' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '344' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '346' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '347' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '348' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '349' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '615' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '346' WHERE SUBCATEGORYID = '358' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '346' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '608' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '5', ITEMID = '936' WHERE SUBCATEGORYID = '613' -- Tools,Office,Outlook
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '5' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '20' WHERE SUBCATEGORYID = '356' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '20' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '931' WHERE SUBCATEGORYID = '351' -- Tools,Desk,DeskPhone
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '926' WHERE SUBCATEGORYID = '353' -- Tools,Desk,AV
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '601', ITEMID = '942' WHERE SUBCATEGORYID = '355' -- Tools,AD,GP
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '608' WHERE SUBCATEGORYID = '357' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310' WHERE SUBCATEGORYID = '359' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '310', ITEMID = '926' WHERE SUBCATEGORYID = '360' -- Tools,Desk,AV
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '310' and CATEGORYID <> '9' -- Tools,Desk
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '601' and CATEGORYID <> '3' -- Core,AD
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '601' WHERE SUBCATEGORYID = '602' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '601' and CATEGORYID <> '3' -- Core,AD
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '23' WHERE SUBCATEGORYID = '607' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '23' and CATEGORYID <> '3' -- Core,AD
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '608' and CATEGORYID <> '3' -- Core,AD
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '609' and CATEGORYID <> '9' -- Core,AD
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '327' WHERE SUBCATEGORYID = '610' -- 
-- UPDATE WorkOrderStates SET SUBCATEGORYID = '5', ITEMID = '936' WHERE SUBCATEGORYID = '611' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '5' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '327' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '612' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '616' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '901' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '9' WHERE SUBCATEGORYID = '905' and CATEGORYID <> '9' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '3' WHERE SUBCATEGORYID = '1201' and CATEGORYID <> '3' -- 
-- UPDATE WorkOrderStates SET CATEGORYID = '1' WHERE SUBCATEGORYID in ('350','362','604','605','606','614','902','903','904','906','907','1501') and CATEGORYID <> '1' -- 

/*
Select * from WorkOrderStates wos
WHERE  wos.WORKORDERID in (Select WORKORDERID from WORKORDER wo where title = 'Check - ICT Alert Emails')
and CATEGORYID <> 3 and SUBCATEGORYID <> 23
--
update WorkOrderStates
set CATEGORYID = '3', SUBCATEGORYID = '23'
WHERE  WORKORDERID in (Select WORKORDERID from WORKORDER wo where title = 'Check - ICT Alert Emails')
and CATEGORYID <> 3 and SUBCATEGORYID <> 23

Select * 
from WorkOrderStates wos
WHERE  WORKORDERID in (Select WORKORDERID from WORKORDER wo where title like '%Mobile Data Alert%')
and CATEGORYID <> 9 and SUBCATEGORYID <> 310
--
update WorkOrderStates
set CATEGORYID = '9', SUBCATEGORYID = '310', ITEMID = '928'
WHERE  WORKORDERID in (Select WORKORDERID from WORKORDER wo where title like '%Mobile Data Alert%')
and CATEGORYID <> 9 and SUBCATEGORYID <> 310

Select * 
from WorkOrderStates wos
WHERE  WORKORDERID in (Select WORKORDERID from WORKORDER wo where title like '%Broadband Usage Alert%')
and CATEGORYID <> 2 and SUBCATEGORYID <> 354
--
update WorkOrderStates
set CATEGORYID = '2', SUBCATEGORYID = '354'
WHERE  WORKORDERID in (Select WORKORDERID from WORKORDER wo where title like '%Broadband Usage Alert%')
and CATEGORYID <> 2 and SUBCATEGORYID <> 354

*/

/*
SELECT wo.WORKORDERID "ReqID",cd.CATEGORYID "CatID",cd.CATEGORYNAME "CatName",scd.SUBCATEGORYID "SubCatID",scd.NAME "SubCatName",icd.ITEMID,icd.NAME "Item" ,cd2.CATEGORYID "CatID2",cd2.CATEGORYNAME "CatName2" FROM WorkOrder wo 
LEFT JOIN WorkOrderStates wos       ON wo.WORKORDERID=wos.WORKORDERID 
LEFT JOIN CategoryDefinition cd     ON wos.CATEGORYID=cd.CATEGORYID 
LEFT JOIN SubCategoryDefinition scd ON wos.SUBCATEGORYID=scd.SUBCATEGORYID 
LEFT JOIN ItemDefinition icd        ON wos.ITEMID=icd.ITEMID 
LEFT JOIN CategoryDefinition cd2    ON scd.CATEGORYID=cd2.CATEGORYID 
WHERE (wo.ISPARENT='1')  and  cd2.CATEGORYID = '1'
ORDER BY 4
*/


