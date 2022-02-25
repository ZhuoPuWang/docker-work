#!/bin/bash
set -e

# 替换www的UID
if [[ -n "$NGINX_UID" ]]; then
    sed -i "s|www:x:1000:1000:Linux User|www:x:${NGINX_UID}:${NGINX_UID}:Linux User|" /etc/passwd && \
    sed -i "s|www:x:1000:|www:x:${NGINX_UID}:|" /etc/group
fi

WWW_CONF=/etc/nginx/conf.d/www.conf
# 替换nginx conf server_name
if [ -f "$WWW_CONF" ] && [ -n "$DOMAIN_NAME" ]; then
    echo "$(sed "s/example.com/${DOMAIN_NAME}/g" ${WWW_CONF})" > ${WWW_CONF}
fi

# 如果/extra.sh脚本存在 执行/extra.sh
if [ -f "/extra.sh" ]; then
    chmod +x /extra.sh && /extra.sh
fi

chown -R www:www /var/log/nginx && chown -R www:www /var/tmp/nginx && chown -R www:www /var/lib/nginx

#/usr/sbin/crond
/usr/sbin/nginx
#/usr/local/sbin/php-fpm
/usr/sbin/php-fpm8
#/usr/bin/supervisord -c /etc/supervisord.conf

LOGFILE=/tmp/start.log
touch ${LOGFILE} && echo `date` >> ${LOGFILE} && tail -f ${LOGFILE}
