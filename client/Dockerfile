FROM nginxinc/nginx-unprivileged:1.25-alpine


# Create dummy SSL certificates to prevent Nginx from failing to start
RUN mkdir -p /etc/nginx/certs \
    && echo "-----BEGIN CERTIFICATE-----" > /etc/nginx/certs/tls.crt \
    && echo "MIIDdTCCAl2gAwIBAgIEUq7u6jANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJV" >> /etc/nginx/certs/tls.crt \
    && echo "UzEUMBIGA1UEChMLRXhhbXBsZSBDb3JwMRcwFQYDVQQHEw5NYWluIFN0cmVldCBD" >> /etc/nginx/certs/tls.crt \
    && echo "aXR5MRQwEgYDVQQDEwtleGFtcGxlLmNvbTAeFw0xNDAzMTkxOTMwMjlaFw0xNTAz" >> /etc/nginx/certs/tls.crt \
    && echo "MTkxOTMwMjlaMG8xCzAJBgNVBAYTAlVTMRQwEgYDVQQKEwtFeGFtcGxlIENvcnAx" >> /etc/nginx/certs/tls.crt \
    && echo "FzAVBgNVBAcTDk1haW4gU3RyZWV0IENpdHkxFDASBgNVBAMTC2V4YW1wbGUuY29t" >> /etc/nginx/certs/tls.crt \
    && echo "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7V7mWj1qR/5xgTECTZ2s" >> /etc/nginx/certs/tls.crt \
    && echo "7TB4gbtnXxXHPrQUuhSxk6XeboOqpUSJ9RzfipcS0WUPnxYIzhBkfdRAAH9fNm6L" >> /etc/nginx/certs/tls.crt \
    && echo "-----END CERTIFICATE-----" >> /etc/nginx/certs/tls.crt \
    && echo "-----BEGIN PRIVATE KEY-----" > /etc/nginx/certs/tls.key \
    && echo "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDv7ImJIo4/CFow" >> /etc/nginx/certs/tls.key \
    && echo "B5J9Q6sEXFlV2xhdI4BUEQb2x4Z52kF/gnrRt5OZVy8+GnRewGd1qbxHj6kLl3dj" >> /etc/nginx/certs/tls.key \
    && echo "KcXHEGO1gERRU/74Ldo8ZB4CMzXSBUr+LjkR4zChLl0obShVbErRLQVAZlc9CvhC" >> /etc/nginx/certs/tls.key \
    && echo "-----END PRIVATE KEY-----" >> /etc/nginx/certs/tls.key

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
