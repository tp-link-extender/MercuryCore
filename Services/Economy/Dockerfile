FROM golang:latest
USER root

WORKDIR /services/economy

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

# create and give permissions to use ../data/ledger file
RUN mkdir /services/economy/data

RUN go build .
CMD ["./Economy"]
