FROM alpine
WORKDIR /app
RUN apk --update add bash jq curl
RUN curl -L https://raw.githubusercontent.com/kubeshop/tracetest/main/install-cli.sh | bash
WORKDIR /app/tracetest/
COPY . .
ENTRYPOINT ["/bin/bash", "/app/tracetest/run.bash"]
