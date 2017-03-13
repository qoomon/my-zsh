function checkdomain {
  local sld=$1
  local tdl_list=($(curl -s http://data.iana.org/TLD/tlds-alpha-by-domain.txt  | grep -v '#\|\-\-' | awk '{ print length($0) " " $0; }' | sort -n | cut -d ' ' -f 2-))
  for tld in $tdl_list; do
    if dig $sld.$tld +noquestion +nostat +noanswer +noauthority | grep "ANSWER: 0" >/dev/null; then
      echo $sld.$tld
    fi
    echo "done"
  done
}
