#!/bin/bash

if [ -z "$1" ]; then
    echo "Передайте файл с логами"
    exit 1
fi

awk '
{
	from = $1
	to = $3
	amount = $4

	expenses[from] += amount
	income[to] += amount
}
END {
	for (player in expenses) {
		if (expenses[player] > income[player]) {
			print player
		}
	}
}
' "$1"
exit 0
