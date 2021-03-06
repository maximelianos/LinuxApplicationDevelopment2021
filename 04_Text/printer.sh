delay=0.05
if [ -n $1 ]; then
  delay=$1
fi

tput clear

maxrow=0
row=0
col=0
while read -r line; do
  row=$(echo "$line" | cut -d' ' -f1)
  col=$(echo "$line" | cut -d' ' -f2)
  code=$(echo "$line" | cut -d' ' -f3)
  char=$(echo -n "$code" | xxd -r -p | xargs)
  if [ "$row" -gt "$maxrow" ]; then
    maxrow=$row
  fi
  if [ -n "$char" ]; then
    tput cup $row $col
    echo -n "$char"
    sleep $delay
  fi
done

tput cup $((maxrow+1)) 0