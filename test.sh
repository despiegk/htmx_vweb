curl -sLO https://unpkg.com/htmx.org/dist/htmx.min.js

# TODO: Check if current version is latest to avoid redundant installation
if [[ -f "tailwindcss" ]]
then
    rm tailwindcss
fi