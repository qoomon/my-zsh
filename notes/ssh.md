# Tunneling
```shell
  ssh <username>@<target_host> -L <tunnelport>:<remote_host>:<remote_port> -N
```
  
# Jumping
```shell
ssh -J <username>@<jump_host> <username>@<target_host>
```

# Expose Local HTTP Server
- `ssh -R 80:localhost:8080 nokey@localhost.run`
- `cloudflared tunnel --url http://localhost:8080`
