#!/bin/bash

{
echo -e "### Docker version ###\n"
docker --version 

echo -e "\n### Docker info ###\n"
docker info | head -n 20 

echo -e "\n### Docker ps ###\n"
docker ps -a 

echo -e "\n### Docker network ls ###\n"
docker network ls 

echo -e "\n### Docker volume ls ###\n"
docker volume ls 
} > "docker_version.txt"

{
echo -e "### Docker system df ###\n"
docker system df 

echo -e "\n### Docker network inspect bridge ###\n"
docker network inspect bridge | head -n 30 
} > "docker_status.txt"