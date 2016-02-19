# Return a list of repeated shuffles of the input list by building and
# running a python script. The length of the result is the first argument
# to the fn. This funcion is only used to build the list of emoji at the
# start of a new terminal, when this file is sourced. From then on, emoji
# are simply chosen from those pre-shuffled lists.
SHUFFLE_LIST() {
    local num=$(( 0 + $1 ))  # error here, not python
    shift

    local things=($@)
    if (( ${#things[@]} == 0 )); then
        echo ''
    else
        local PY
        read -d '' PY <<EOF
# -*- coding: UTF-8 -*-
import random
e='${things[@]}'.strip().split()
all=[]
while len(all) < $num:
    random.shuffle(e)
    all += e
print ' '.join(all[:$num])
EOF
        echo $(echo "$PY" | python)
    fi
}

# Pick an element based on time & pid of current shell ($$). It changes every
# hour, and is different for each shell.
RAND_ELEMENT_BY_TIME () {
    # Put the args into a named list, so we can use it as an array
    local things=($@)

    local len=${#things[@]}
    if (( $len == 0 )); then
        echo ''
    else
        # Index by hour, day, month, to avoid loops. But that's best if list is
        # long or the repeat-sequence is jittered.
        local hour_of_year=$(date '+ ( %H + 24*(%d-1) + 24*31*(%m-1) )' | bc)
        local index=$(( $hour_of_year % $len ))
        echo "${things[$index]}"
    fi
}

# NOTE: it's important that emojis are separated by space, and the last one
# isn't followed by a space.
HOURS_IN_MONTH=$(( 24 * 31 ))
MORNING_EMOJI=$(SHUFFLE_LIST $HOURS_IN_MONTH 🌄 ☀️ ☕️ 🍳 🍞 🐓 🐔)
DAY_EMOJI=$(SHUFFLE_LIST $HOURS_IN_MONTH 🌲 🌳 🌴 🌵 🌷 🌺 🌸 🌹 🌻 🌼 💐 🌾 🌿 🍀 🍁 🍂 🍃 🍄 ☀️ ⛅️ ☁️ ☔️ 🌈 🌊 🗻 🌍 🌞 💻 🚽 📚 ✂️ 🔪)
FOOD_EMOJI=$(SHUFFLE_LIST $HOURS_IN_MONTH 🍔 🍕 🍖 🍗 🍘 🍙 🍚 🍛 🍜 🍝 🍞 🍟 🍣 🍤 🍥 🍱 🍲 🍳 🍴)
SNACK_EMOJI=$(SHUFFLE_LIST $HOURS_IN_MONTH 🍏 🍇 🍉 🍊 🍌 🍍 🍑 🍒 🍓 🍡 🍢 🍦 🍧 🍨 🍩 🍪 🍫 🍬 🍭 🍮 🍰)
DRINK_EMOJI=$(SHUFFLE_LIST $HOURS_IN_MONTH 🍷 🍸 🍶 🍹 🍺 🍻)
NIGHT_EMOJI=$(SHUFFLE_LIST $HOURS_IN_MONTH 😴 🌠 🌑 🌒 🌔 🌖 🌘 🌚 🌝 🌛 🌜 ⛺️ 🌃 🌉 🌌)

EMOJI_SUFFIX='\[\033[0;30m\]¸\[\033[0m\]'

# This is the function to use if you only want the emoji itself
CURRENT_EMOJI_RAW() {
    local now=$(date +%k%M)
    local TE="$NIGHT_EMOJI"

    if [ $now -lt 600 ]; then
        TE="$NIGHT_EMOJI"
    elif [ $now -lt 1000 ]; then
        TE="$MORNING_EMOJI"
    elif [ $now -lt 1200 ]; then
        TE="$DAY_EMOJI"
    elif [ $now -lt 1330 ]; then
        TE="$FOOD_EMOJI"
    elif [ $now -lt 1700 ]; then
        TE="$DAY_EMOJI"
    elif [ $now -lt 1900 ]; then
        TE="$SNACK_EMOJI"
    elif [ $now -lt 2200 ]; then
        TE="$DRINK_EMOJI"
    fi

    echo "$(RAND_ELEMENT_BY_TIME $TE)"
}

# This is probbaly the function a prompt should use to get the current emoji,
# including a smal black character, to help with width alignment.
CURRENT_EMOJI() {
    echo -e "$(CURRENT_EMOJI_RAW)$EMOJI_SUFFIX"
}
