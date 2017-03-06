autoload +X -U colors && colors

function zlog {
  local level="$1"
  shift
  case "$level" in
    'error')
      echo "${fg_bold[red]}[zgem]${reset_color}" $@ >&2
      ;;
    'info')
      echo "${fg_bold[blue]}[zgem]${reset_color}" $@
      ;;
    'debug')
      $ZGEM_VERBOSE && echo "${fg_bold[yellow]}[zgem]${reset_color}" $@
      ;;
    *)
      zlog error "Unknown log level '$protocol'"
      zlog error "Log Level: {error|info|debug}"
      ;;
  esac
}