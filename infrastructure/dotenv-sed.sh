#!/bin/bash
set -eo pipefail

DOTENVFILEJS="../src/main/webapp/dotenv.js"
DOTENVFILE="../.env"

# Remove comments, quotes and invalid assignments, which should not be surrounded by any whitespace
sed -e 's/[\t ]*=[\t ]*/=/g' "$DOTENVFILE" | grep -vE "^#" | grep -vE "^[\t ]*$" | sed -e 's/="/=/' -e 's/"[\t ]*$//' > .env.corrected

cat << DOC > "$DOTENVFILEJS"
/**
 * Update this file with the script infrastructure/dotenv-sed.sh
 *
 * 1) Copy .env.example to .env (place it into the projects root folder)
 * 2) Execute "cd infrastructure && ./dotenv-sed.sh"
 */
window.env = {
DOC

while read -r pair; do
    IFS='=' read -r key val <<< "$pair"
    echo -e "\t$key: \"$val\","
done < .env.corrected >> "$DOTENVFILEJS"

echo "}" >> "$DOTENVFILEJS"

rm -rf .env.corrected

exit 0
