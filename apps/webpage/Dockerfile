FROM golang:1.20-buster as builder
WORKDIR /src

COPY go.* ./
RUN go mod download

COPY ./src ./

RUN go build -o server

FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the binary to the production image from the builder stage.
COPY --from=builder /src/server /server
COPY ./layout.html layout.html
# Run the web service on container startup.
CMD ["/server"]
