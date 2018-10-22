function jvm {
  if [ "$1" = "-h" ]; then
    echo "jenv sets \$JAVA_HOME to a specific version"
    echo "usage:"
    echo "    jenv \t\tlist available versions"
    echo "    jenv <version>\tsets \$JAVA_HOME accordingly to version"
    return 0;
  fi
  
  local java_home='/usr/libexec/java_home'

  if [ $# = 0 ]; then 
    echo 'Installed Versions'
    java_home -V 2>&1 | command grep "^    "
    echo 
    echo 'Current Version'
    if [ $JAVA_HOME ]; then
      java_home -V 2>&1 | command grep "\t${JAVA_HOME}"
    else
      java_home -V 2>&1 | command grep "\t$(java_home)"
    fi 
  else
    local java_home=$(/usr/libexec/java_home -v $1);
    if [ $? = 0 ]; then
      export JAVA_HOME=$java_home; 
    fi 
  fi
}