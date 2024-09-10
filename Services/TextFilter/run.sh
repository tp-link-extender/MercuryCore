#!/bin/bash

echo "WARNING: This script is intended for non-dockerized hosting. Hosting this way is not intended for production. This script will NOT set up Redis for you."

# incase the working directory is else where
cd "$(dirname "$(realpath "$0")")"

pip install -r requirements.txt

uvicorn app.main:app --host 0.0.0.0 --port 3476