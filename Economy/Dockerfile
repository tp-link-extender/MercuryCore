FROM golang:latest
USER root

WORKDIR /economy

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

# create and give permissions to use ../data/ledger file
RUN mkdir /economy/data
RUN touch /economy/data/ledger
RUN chmod 777 /economy/data/ledger

RUN go build .
CMD ["./Economy"]
