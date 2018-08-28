FROM golang:1.11 as builder
MAINTAINER Ivan Sim
WORKDIR /go/src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -o server ./...

FROM alpine
WORKDIR /root/
COPY --from=builder /go/src/server .
ENTRYPOINT ["./server"]
