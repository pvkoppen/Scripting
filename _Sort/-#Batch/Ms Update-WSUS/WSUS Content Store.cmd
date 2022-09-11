C:
CD \Program Files\Update Services\Tools

wsusutil movecontent D:\WSUS\ D:\WSUS\WSUSContent.log

wsusutil reset

bitsadmin /list /allusers