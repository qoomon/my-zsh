function checkdomain {
  local sld=$1
  local tdl_list=($(curl -s http://data.iana.org/TLD/tlds-alpha-by-domain.txt  | grep -v '#\|\-\-' | awk '{ print length($0) " " $0; }' | sort -n | cut -d ' ' -f 2-))
  for tld in $tdl_list; do
    local answer=$(dig @8.8.8.8 $sld.$tld +noquestion +nostat +noanswer +noauthority | grep "ANSWER: 0")
    if [ -n "$answer" ]; then
      echo "$sld.$tld"
    fi
  done
}
