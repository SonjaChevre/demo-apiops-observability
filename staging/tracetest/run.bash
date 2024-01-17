#/bin/bash

tracetest configure -e http://tracetest.tracetest.svc.cluster.local:11633
tracetest run test -f /app/tracetest/test/httpbin.spec.yaml --required-gates test-specs --output pretty
