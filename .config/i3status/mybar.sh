#!/bin/sh

# i3 config in ~/.config/i3/config :
# bar {
#   status_command exec /home/tom/.config/i3status/mybar.sh
# }

echo '{ "version": 1, "click_events":true }'
echo '['
echo '[]'

bg_bar_color="#282A36"

separator() {
  echo -n "{"
  echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border\":\"$bg_bar_color\","
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"color\":\"$1\","
  echo -n "\"background\":\"$2\""
  echo -n "}"
}

common() {
  echo -n "\"border\": \"$bg_bar_color\","
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0"
}

#myip_public() {
#  local bg="#1976D2"
#  separator $bg "#FFD180"
#  echo -n ",{"
#  echo -n "\"name\":\"ip_public\","
#  echo -n "\"full_text\":\" $(/home/tom/.config/i3status/ip.py) \","
#  echo -n "\"background\":\"$bg\","
#  common
#  echo -n "},"
#}

disk_usage() {
  local bg="#FAFFFD"
  separator $bg "#3C91E6"
  echo -n ",{"
  echo -n "\"name\":\"id_disk_usage\","
  echo -n "\"full_text\":\"  $(python3.8 /home/tom/.config/i3status/disk.py)%\","
  echo -n "\"background\":\"$bg\","
  echo -n "\"color\":\"#000000\","
  common
  echo -n "}"
}

memory() {
  echo -n ",{"
  echo -n "\"name\":\"id_memory\","
  echo -n "\"full_text\":\"  $(python3.8 /home/tom/.config/i3status/memory.py)%\","
  echo -n "\"background\":\"#FAFFFD\","
  echo -n "\"color\":\"#000000\","
  common
  echo -n "}"
}

cpu_usage() {
  echo -n ",{"
  echo -n "\"name\":\"id_cpu_usage\","
  echo -n "\"full_text\":\"  $(python3.8 /home/tom/.config/i3status/cpu.py)% \","
  echo -n "\"background\":\"#FAFFFD\","
  echo -n "\"color\":\"#000000\","
  common
  echo -n "},"
}

meteo() {
  local bg="#6a040f"
  separator $bg "#000000"
  echo -n ",{"
  echo -n "\"name\":\"id_meteo\","
  echo -n "\"full_text\":\"Brussels: $(python3.8 /home/tom/.config/i3status/meteo_bru.py) | Annecy: $(python3.8 /home/tom/.config/i3status/meteo_ann.py)\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

myip_local() {
  local bg="#457b9d" 
  separator $bg "#6a040f" 
  echo -n ",{"
  echo -n "\"name\":\"ip_local\","
  echo -n "\"full_text\":\"  $(ip route get 1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

mydate() {
  local bg="#342E37"
  separator $bg "#FAFFFD"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  echo -n "\"full_text\":\"  $(date "+%a %d/%m %H:%M") \","
  echo -n "\"color\":\"#FFFFFF\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "}"
}

logout() {
  echo -n ",{"
  echo -n "\"name\":\"id_logout\","
  echo -n "\"full_text\":\"  \""
  echo -n "}"
}

# lancé dans un processus en arrière plan
(while :;
do
  #echo ",[{\"name\":\"id_time\",\"full_text\":\"$(date)\"}]"
  echo -n ",["
  meteo
  myip_local
  disk_usage
  memory
  cpu_usage
  mydate
  logout
  echo "]"
  sleep 1
done) &

# Ecoute des évènement en STDIN
while read line;
do
  # echo $line > /tmp/tmp.txt
  # on reçoit en STDIN :
  # {"name":"id_time","button":1,"modifiers":["Mod2"],"x":2982,"y":9,"relative_x":67,"relative_y":9,"width":95,"height":22}

  # DATE click
  if [[ $line == *"name"*"id_time"* ]]; then
    urxvt -e /home/tom/.config/i3status/click_time.sh &
  # LOGOUT
  elif [[ $line == *"name"*"id_logout"* ]]; then
    i3-nagbar -t warning -m 'Log out ?' -b 'yes' 'i3-msg exit' > /dev/null &
  fi  
done
