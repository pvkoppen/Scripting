SELECT B.* FROM PSMENUITEM A FULL OUTER JOIN PSMENUITEMLANG B
  ON (A.MENUNAME = B.MENUNAME
  AND A.BARNAME  = B.BARNAME
  AND A.ITEMNAME = B.ITEMNAME)
WHERE A.MENUNAME IS NULL


/*

MENUNAME                       BARNAME                        ITEMNAME                       LANGUAGE_CD BARLABEL   ITEMLABEL                      
------------------------------ ------------------------------ ------------------------------ ----------- ---------- ------------------------------ 
BILL_CUSTOMERS                 INQUIRE                        BILL_CANCELLATION              DUT         &Opvragen  Annulerin&g factuur           
BUDGET_TRAINING_(FRA)          USE                            TRN_DEMAND_DEPT                DUT         &Data      &Afdelingsaanvraag            
BUDGET_TRAINING_(FRA)          USE                            TRN_DEMAND_TABLE               DUT         &Data      &Algemene aanvraag            
MAINTAIN_PEOPLE_DATA           USE_A-K                        SA_BIO_DEMO_DATA               DUT         Data &1    Demografische gegevens        
SECURE_STUDENT_ADMIN           OPRID                          ES_SECURITY_TBL                DUT         Opr&ID     Beveiligingsviews             
SECURE_STUDENT_ADMIN           OPRID                          SCRTY_TBL_PLAN                 DUT         Opr&ID     Beveiliging studiep&lan       
SECURE_STUDENT_ADMIN           PROCESS                        RUNCTL_SRSECVWU                DUT         &Proces    &Beveiligingsviews bijwerken  

(7 row(s) affected)

*/
