FROM jeedom/jeedom:4.4-http-bookworm

COPY root/init-wrapper.sh /root/init-wrapper.sh
RUN ls -la /root
RUN chmod +x /root/init-wrapper.sh

COPY init-scripts/ /init-scripts/
RUN chmod +x /init-scripts/*.sh

ENTRYPOINT ["/root/init-wrapper.sh"]