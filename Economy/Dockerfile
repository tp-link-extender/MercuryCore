FROM golang:latest

WORKDIR /usr/src/Economy

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -o /usr/local/bin/Economy ./...

CMD ["Economy"]
