#!/bin/bash
# Build + deploy de sample app als Docker-container.
# Aangepast t.o.v. de starter: het script is nu idempotent (2x na elkaar draaien lukt).
set -euo pipefail

# FIX 1: tempdir van een vorige build opruimen, anders faalt "mkdir tempdir"
rm -rf tempdir
mkdir -p tempdir/templates tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit
docker build -t sampleapp .

# FIX 2: oude container weg, anders "name samplerunning already in use"
# (|| true: geen fout als hij nog niet bestaat)
docker rm -f samplerunning 2>/dev/null || true

docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a
