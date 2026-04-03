#!/bin/bash
set -e

cd /
sudo rm -rf todo_storage
sudo mkdir todo_storage
cd todo_storage/
sudo mkdir logs
sudo mkdir backend
cd logs/
sudo mkdir backend
sudo mkdir frontend
cd ../backend/
sudo mkdir staticfiles