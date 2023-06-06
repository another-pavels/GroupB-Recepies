### time before shutdown 
`date --date @$(head -1 /run/systemd/shutdown/scheduled |cut -c6-15)`


