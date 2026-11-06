FROM golang:latest
USER root

WORKDIR /economy

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

RUN mkdir -p /data/economy && go build .

# the compose volume mounts ./data/economy at /data/economy
# :2009 (all interfaces) is needed for the Site container to reach it over the compose network; the host port stays loopback-only
CMD ["./Economy", "-db", "/data/economy/mydb.db", "-addr", ":2009"]
