#!/bin/bash

case $1 in
    "deploy")
    hugo
	rsync -auv public/ ubuntu@rain.com.au:/var/www/blog/
    ;;
    *)
    echo "Usage $0 [command]"
     echo ""
     echo "Commands"
     echo ""
     echo "  deploy        Deploy to Production"
     echo ""
    ;;
esac
