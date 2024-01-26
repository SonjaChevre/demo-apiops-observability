#/bin/bash

tracetest configure -e http://tracetest.tracetest.svc.cluster.local:11633
tracetest run test -f /app/tracetest/test/httpbin.func.spec.yaml --required-gates test-specs --output pretty
tracetest run test -f /app/tracetest/test/httpbin.perf.spec.yaml --required-gates test-specs --output pretty
tracetest run test -f /app/tracetest/test/graphql.func.spec.yaml --required-gates test-specs --output pretty
