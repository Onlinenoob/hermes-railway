FROM nousresearch/hermes-agent:latest

COPY entrypoint.sh /railway-entrypoint.sh
RUN chmod +x /railway-entrypoint.sh

ENTRYPOINT ["/opt/hermes/docker/entrypoint.sh"]
CMD ["gateway", "run", "--replace"]
