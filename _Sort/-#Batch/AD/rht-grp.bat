goto add

:add
dsadd group "CN=Raumano Health Trust (RHT) Admin,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Alcohol and Drugs,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Child and Adolescent,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Consumer Advocate,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Finance,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Human Resource,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Kaumatue Whanau Ora,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Meaningful Activities,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Peer Support,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Tamariki Rangatahi,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
dsadd group "CN=Raumano Health Trust (RHT) Youth,OU=RHT,DC=TUIORA,DC=LOCAL" -secgrp yes -scope g 
goto end

:end
pause