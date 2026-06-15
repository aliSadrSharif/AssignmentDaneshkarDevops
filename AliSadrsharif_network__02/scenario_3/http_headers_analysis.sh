#!/bin/bash

{
echo -e "----- Headrs for academy arvancloud -----\n"
curl -I https://academy.arvancloud.ir/
echo ""

echo -e "----- Headrs for google -----\n"
curl -I https://google.com
echo ""

echo -e "----- Headrs for daneshkar -----\n"
curl -I https://daneshkar.net
echo ""

echo -e "----- Results for Daneshkar -----"
echo "
Header      	           Status 	               Info 
Content-Type            	good 	      HTML with UTF8 format
Server 	                  acceptle        expose details,it should reveal less info
Cache-Control 	            good 	      great integration with CDN, better performance
X-Frame-Options 	        good 	      prevent clickjacking
Content-Security-Policy   acceptle 	      shows vulnerability requiers upgrade
"
} > http_headers_analysis.txt