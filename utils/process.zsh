function limits {
  local pid=$(pid $@ | awk '{print $1}')
  local pid_count=$(echo "$pid" | wc -l | tr -d " ")
  if [ $pid_count -ne 1 ]
  then
    echo "Ambigous pid's ($pid_count)"
    echo "Use 'pid $@' for more informations"
    return 1
  fi
  cat "/proc/$pid/limits"
}
