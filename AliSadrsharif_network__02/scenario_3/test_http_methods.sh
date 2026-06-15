#!/bin/bash

# i used diffrent mock API service and it doesn't provid PUT and DELETE methods

{
URL="https://moviesapi.ir/api/v1/movies"

echo -e "----- GET Request test for mock API -----\n"
curl -X GET $URL/1
echo ""

echo -e "\n----- POST Request test -----\n"
curl -X POST $URL \
-H "Content-Type: application/json" \
-d '{"title": "Arrival", "imdb_id": "tt2543164", "country": "USA", "year": 2016}'
echo ""


echo -e "\n----- Headers included GET Request -----\n"
curl -i $URL/1
echo ""

echo -e "\n----- Status code result -----\n"
curl -o /dev/null -s -w "%{http_code}\n" $URL/1

} > http_methods_report.txt