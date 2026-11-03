#!/bin/bash

PLAYERS_FILE="players.txt"
BAN_FILE="banlist.txt"
TRANSACTIONS_FILE="transactions.log"

LOCK_FILE="report.lock"
REPORT_FILE="report.txt"

show_help() {
    echo "Использование: $0 [ПАРАМЕТРЫ]"
    echo "Скрипт генерации финального отчета по серверу StarCraft."
    echo ""
    echo "Параметры:"
    echo "  -p, --players FILE       Путь к файлу с игроками (по умолчанию: players.txt)"
    echo "  -b, --banlist FILE       Путь к файлу бан-листа (по умолчанию: banlist.txt)"
    echo "  -t, --transactions FILE  Путь к файлу транзакций (по умолчанию: transactions.txt)"
    echo "  --help                   Показать эту справку"
    exit 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        -p|--players)
            if [ -z "$2" ]; then
		echo "Ошибка: Не указан файл" >&2
                exit 1
            fi
            PLAYERS_FILE="$2"
            shift 2
            ;;
        -b|--banlist)
            if [ -z "$2" ]; then
                echo "Ошибка: Не указан файл" >&2
                exit 1
            fi
            BAN_FILE="$2"
            shift 2
            ;;
        -t|--transactions)
            if [ -z "$2" ]; then
                echo "Ошибка: Не указан файл" >&2
                exit 1
            fi
            TRANSACTIONS_FILE="$2"
            shift 2
            ;;
        --help)
            show_help
            ;;
        *)
            echo "Ошибка: Неизвестный ключ" >&2
            exit 1
            ;;
    esac
done

if [ -e "$LOCK_FILE" ]; then
    echo "Report in progress" >&2
    exit 1
fi

touch "$LOCK_FILE"

cleanup_interrupted() {
    rm -f "$REPORT_FILE"
    rm -f "$LOCK_FILE"
    echo "Reporting was interrupted" >&2
    exit 1
}

trap cleanup_interrupted SIGINT SIGTERM

for file in "$PLAYERS_FILE" "$BAN_FILE" "$TRANSACTIONS_FILE"; do
    if [ ! -f "$file" ]; then
        echo "Ошибка: Файл $file не найден." >&2
        rm -f "$LOCK_FILE"
        exit 1
    fi
done

PLAYERS=$(grep -c '^.' "$PLAYERS_FILE")
BANS=$(grep -c '^.' "$BAN_FILE")
TRANSACTIONS=$(grep -c '^.' "$TRANSACTIONS_FILE")

TOP_ITEM=$(awk '{print $5}' "$TRANSACTIONS_FILE" | sort | uniq -c | sort -rn | head -n 1 | awk '{print $2}')
if [ -z "$TOP_ITEM" ]; then
    TOP_ITEM="None"
fi

{
    echo "StarCraft server report"
    echo ""
    echo "Players: $PLAYERS"
    echo "Bans: $BANS"
    echo "Transactions: $TRANSACTIONS"
    echo "Top item: $TOP_ITEM"
} > "$REPORT_FILE"

rm -f "$LOCK_FILE"
exit 0
