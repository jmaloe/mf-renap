# - Variables de entorno -
# VITE_BASE_NAME: Ruta base de la aplicación
# VITE_CDN_URL: URL del CDN

# - Variables internas -
# HOME: /opt/app-root/src
# NGINX_CONF_PATH: /etc/nginx/nginx.conf

FROM registry.redhat.io/rhel10/nodejs-24:10.1 AS builder

ARG VITE_BASE_NAME=mf-renap
ARG VITE_BASE_ID=renap
ARG VITE_CDN_URL=https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/design-system

ENV VITE_BASE_NAME=${VITE_BASE_NAME}
ENV VITE_BASE_ID=${VITE_BASE_ID}
ENV VITE_CDN_URL=${VITE_CDN_URL}

WORKDIR ${HOME}

COPY . .
COPY ./public/config/env-config.json.example ./public/config/env-config.json

USER 0
RUN rm -f ./public/config/*.json.example

USER 1001
RUN envsubst '${VITE_BASE_NAME}' < nginx/nginx.conf.template > nginx.conf
RUN npm ci && npm run build

FROM registry.redhat.io/rhel10/nginx-126:10.1 AS runtime

ARG VITE_BASE_NAME=mf-renap

ENV TZ=America/Guatemala

COPY --from=builder ${HOME}/dist ${HOME}/${VITE_BASE_NAME}
COPY --from=builder ${HOME}/nginx.conf ${NGINX_CONF_PATH}

USER 1001

HEALTHCHECK --interval=20s --timeout=5s --start-period=10s --retries=3 CMD curl -f http://localhost:8080/healthz || exit 1

CMD ["nginx", "-e", "/dev/stderr", "-g", "daemon off;"]
