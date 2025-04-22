FROM alpine:latest
COPY shell_server.js /
CMD nodejs /shell_server.js
EXPOSE 8080
