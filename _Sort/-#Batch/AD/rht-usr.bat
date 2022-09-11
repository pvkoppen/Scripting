goto mod2

:add
dsadd user "CN=Jim O'Brien,OU=RHT,DC=TUIORA,DC=LOCAL"		 -samid jmo -fn "Jim" -ln "O'Brien"		 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Kirsten Gamby,OU=RHT,DC=TUIORA,DC=LOCAL"		 -samid kng -fn "Kirsten" -ln "Gamby"		 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Mihi Kahu,OU=RHT,DC=TUIORA,DC=LOCAL"		 -samid mik -fn "Mihi" -ln "Kahu"		 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Ngapuke Kahukuranui,OU=RHT,DC=TUIORA,DC=LOCAL"	 -samid nek -fn "Ngapuke" -ln "Kahukuranui"	 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Remy Harris,OU=RHT,DC=TUIORA,DC=LOCAL"		 -samid ryh -fn "Remy" -ln "Harris"		 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Rochelle Bertrand,OU=RHT,DC=TUIORA,DC=LOCAL"	 -samid reb -fn "Rochelle" -ln "Bertrand"	 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Trish Martin,OU=RHT,DC=TUIORA,DC=LOCAL"		 -samid thm -fn "Trish" -ln "Martin"		 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Queenie Gripp,OU=RHT,DC=TUIORA,DC=LOCAL"		 -samid qeg -fn "Queenie" -ln "Gripp"		 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsadd user "CN=Jackie Broughton,OU=RHT,DC=TUIORA,DC=LOCAL"	 -samid jbn -fn "Jackie" -ln "Broughton"	 -memberof "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" "CN=Internet Access,CN=Users,DC=TUIORA,DC=LOCAL" -pwd "password" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
goto end

:mod
dsmod user "CN=Jim O'Brien,OU=RHT,DC=TUIORA,DC=LOCAL"		 -fn "Jim" -ln "O'Brien"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Kirsten Gamby,OU=RHT,DC=TUIORA,DC=LOCAL"		 -fn "Kirsten" -ln "Gamby"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Mihi Kahu,OU=RHT,DC=TUIORA,DC=LOCAL"		 -fn "Mihi" -ln "Kahu"		 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Ngapuke Kahukuranui,OU=RHT,DC=TUIORA,DC=LOCAL"	 -fn "Ngapuke" -ln "Kahukuranui" -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Remy Harris,OU=RHT,DC=TUIORA,DC=LOCAL"		 -fn "Remy" -ln "Harris"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Rochelle Bertrand,OU=RHT,DC=TUIORA,DC=LOCAL"	 -fn "Rochelle" -ln "Bertrand"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Trish Martin,OU=RHT,DC=TUIORA,DC=LOCAL"		 -fn "Trish" -ln "Martin"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Queenie Gripp,OU=RHT,DC=TUIORA,DC=LOCAL"		 -fn "Queenie" -ln "Gripp"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
dsmod user "CN=Jackie Broughton,OU=RHT,DC=TUIORA,DC=LOCAL"	 -fn "Jackie" -ln "Broughton"	 -pwd "password" -hmdir "" -profile "\\dc12\f$username$$\fathome" -mustchpwd no -canchpwd yes -pwdneverexpires no -disabled no 
goto end

:mod2
dsmod user "CN=Jim O'Brien,OU=RHT,DC=TUIORA,DC=LOCAL"		 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Kirsten Gamby,OU=RHT,DC=TUIORA,DC=LOCAL"		 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Mihi Kahu,OU=RHT,DC=TUIORA,DC=LOCAL"		 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Ngapuke Kahukuranui,OU=RHT,DC=TUIORA,DC=LOCAL"	 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Remy Harris,OU=RHT,DC=TUIORA,DC=LOCAL"		 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Rochelle Bertrand,OU=RHT,DC=TUIORA,DC=LOCAL"	 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Trish Martin,OU=RHT,DC=TUIORA,DC=LOCAL"		 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Queenie Gripp,OU=RHT,DC=TUIORA,DC=LOCAL"		 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
dsmod user "CN=Jackie Broughton,OU=RHT,DC=TUIORA,DC=LOCAL"	 -hmdir "" -profile "\\dc12\f$username$$\fatprof" 
goto end

:end
pause
