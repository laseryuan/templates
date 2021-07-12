#!/bin/bash
# vim: set noswapfile :

main() {
  case "$1" in
    run)
      # setup handlers
      trap 'term_handler' SIGTERM SIGINT

      app-config

      shift
      long_run "$@"

      tail -f /dev/null & wait
      ;;
    help)
      cat /README.md
      ;;
    test)
      package -h
      ;;
    *)
      exec "$@"
      ;;
  esac
}

long_run(){
  sleep "$@" &
}

app-config() {
  [ -z "${VAR}" ] && variable='default' || variable="${VAR}"
  [[ "${DEBUG}" == "true" ]] && loglevel='debug' || loglevel="warning"
  [ -z "${DOMAIN}" ] && { echo "Need to defaine DOMAIN !"; return 1; } || domain="${DOMAIN}"

  sed \
    -e "s/\${loglevel}/${loglevel}/" \
      /app/tmpl/config.tmpl >> /etc/app/config.conf

  cat /etc/app/config.conf
}

term_handler() {
  echo "Term signal catched. Shutdown ..."
  kill -9 $(pidof sleep) || true
  exit 143; # 128 + 15 -- SIGTERM
}

main "$@"


