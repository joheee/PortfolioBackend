FROM golang:1.24 AS builder
WORKDIR /app
RUN go install github.com/swaggo/swag/cmd/swag@latest
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN swag init
RUN CGO_ENABLED=0 GOOS=linux go build -o /portfolio-backend .

FROM alpine:latest
COPY --from=builder /portfolio-backend .
EXPOSE 8080
CMD ["./portfolio-backend"]