#!/bin/bash

FILE="banlist.txt"

format() {
	if [ -f "$1" ]; then
		sed '/11_Steve_11/d' "$1" | sort -u > "$1"
	fi
}

add() {
	local nickname=""
	local ban_time=""
	local reason=""
	if [ $# -eq 1 ]; then
		nickname=$(echo "$1" | awk '{print $1}')
		ban_time=$(echo "$1" | awk '{print $2}')
		reason=$(echo "$1" | awk '{print $3}')
	elif [ $# -eq 3 ]; then
		nickname="$1"
		ban_time="$2"
		reason="$3"
	else
		echo "Ошибка: неверный ввод" >&2
		return 1
	fi

	if [ -z "$nickname" ] || [ -z "$ban_time" ] || [ -z "$reason" ]; then
		echo "Ошибка: неверный формат данных" >&2
		return 1
	fi

	if grep -q "^${nickname} " "$FILE"; then
		sed -i "s/^${nickname} .*/${nickname} ${ban_time} ${reason}/" "$FILE"
	else
		echo "${nickname} ${ban_time} ${reason}" >> "$FILE"
	fi
}

info() {
	if [ -z "$1" ]; then
		echo "Ошибка: укажите никнейм" >&2
		return 1
	fi

	if [ -f "$FILE" ]; then
		sed -n "/^$1/p" "$FILE"
	fi
}

remove() {
	if [ -z "$1" ]; then
		echo "Ошибка: укажите никнейм" >&2
		return 1
	fi

	if [ -f "$FILE" ]; then
		sed -i "/^$1 /d" "$FILE"
	fi
}

sort_list() {
	local key="$1"
	local output="$2"
	local file="$FILE"

	if [ ! -f "$file" ]; then
		echo "Ошибка: Исходного файла нет" >&2
		return 1
	fi

	if [ -z "$output" ]; then
		echo "Ошибка: Укажите новый файл" >&2
		return 1
	fi

	case "$key" in
		--name)
			sort -k1,1 "$file" -o "$output"
			;;
		--time)
			sort -k2,2 "$file" -o "$output"
			;;
		*)
			echo "Ошибка: неверный ключ" >&2
			return 1
			;;
	esac
}

COMMAND="$1"
shift

case "$COMMAND" in
	format)
		format "$1"
		;;
	add)
		add "$@"
		;;
	info)
		info "$1"
		;;
	remove)
		remove "$1"
		;;
	sort)
		sort_list "$1" "$2"
		;;
esac

