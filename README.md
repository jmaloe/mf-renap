# CONFIGURACIÓN DE DESPLIEGUE DEL MICROFRONTEND

## 1. Catálogo de Variables de Entorno

Definimos la separación entre variables utilizadas durante el proceso de construcción (build-time) y aquellas que se inyectan en tiempo de ejecución (runtime).

### a. Variables de Build (.env)

Archivo utilizado exclusivamente durante el desarrollo local y el proceso de construcción de la aplicación (por ejemplo, con Vite). Estas variables se embeben en el bundle final.

| Variable | Descripción | Ejemplo |
| :--- | :--- | :--- |
| `DOTENV_CONFIG_QUIET` | Silencia los logs de carga de variables de entorno en desarrollo. | `true` |
| `VITE_PORT` | Puerto en el que se levanta la aplicación en entorno local. | `8080` |
| `VITE_HOST_URL` | Url del Portal para el proxy de vite. | `https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt` |
| `VITE_HOST_PATH` | Endpoint del Portal para el proxy de vite. | `/` |
| `VITE_APIGATEWAY_TOKEN` | Token del gateway para pruebas locales. | `eyABC123...` |
| `VITE_BASE_NAME` | Nombre base de la aplicación. | `mf-renap` |
| `VITE_CDN_URL` | URL del CDN o Design System utilizado por la aplicación. | `https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/design-system` |

### b. Variables de Runtime (public/config/env-config.json)

Archivo cargado dinámicamente en tiempo de ejecución. Permite modificar configuraciones sin necesidad de reconstruir la aplicación.

| Variable | Descripción | Ejemplo |
| :--- | :--- | :--- |
| `transactionCode` | Código de transacción asociado al servicio. | `18108` |
| `hostBaseUrl` | URL base del Portal. | `https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/` |
| `hostJsons.runtime` | Endpoint del JSON de operaciones principales. | `/config/mf-config.json` |
| `hostJsons.remotes` | Endpoint del JSON de servicios. | `/config/mf-hub-remotes.json` |
| `apiBaseUrl` | URL base del backend o API Gateway. | `https://apigateway-dev.apps.ocp-desa.banrural.com.gt` |
| `apiRestPaths.verifyAccess` | Endpoint para validación de acceso del usuario. | `/ws_cr_gestiones_admon/v1/verificar-acceso` |
| `apiRestPaths.phoneNumber` | Endpoint para consulta de número telefónico. | `/ws_cr_claro_postpago/v1/consulta` |
| `apiRestPaths.validAmount` | Endpoint para validación de montos. | `/ws_cr_gestiones_admon/v1/validar-monto` |
| `apiRestPaths.paidData` | Endpoint para ejecución de pago. | `/ws_cr_claro_postpago/v1/pago` |
| `apiRestPaths.detailTransaction` | Endpoint para la obtención de la data en reimpresiones. | `/ws_reimprime_boletas_cr/v1/detalle_transacciones` |
| `apiRestPaths.dateTimeData` | Endpoint para la obtención del tiempo. | `https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/api-time` |

## 2. Construcción del despliegue del proyecto

- Seleccionamos nuestro proyecto **Openshift**.

>[!note] Si el **"namespace/project"** no existe, solicitar su creación a nombre de: `br-cajabr-override-template`.

```bash
oc project br-cajabr-override-template
```

- Nos logueamos en los **Registries** necesarios.

```bash
podman login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp-desa.banrural.com.gt
```

- Construimos la imagen.

>>> [!note] Nota
El comando de despliegue `podman build` posee la posibilidad de configurar 2 variables de entorno, pero que ya traen por defecto un valor destinado al proyecto en desarrollo:

- `--build-arg VITE_BASE_NAME='mf-renap'`: Nombre general del proyecto.
- `--build-arg VITE_CDN_URL='https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/design-system'`: Dirección de los estilos del proyecto.
>>>

```bash
podman build --format docker --no-cache -t default-route-openshift-image-registry.apps.ocp-desa.banrural.com.gt/br-cajabr-override-template/mf-renap:v1.0.0 .
podman push default-route-openshift-image-registry.apps.ocp-desa.banrural.com.gt/br-cajabr-override-template/mf-renap:v1.0.0
```

>>> [!important] Importante
Si existen conflictos al momento de subir la imagen, pero no se crea el **ImageStream** se puede realizar lo siguiente:

```bash
oc create imagestream mf-renap -n br-cajabr-override-template
# Y realizamos el push nuevamente

# Para eliminar el imagestream
oc delete imagestream mf-renap -n br-cajabr-override-template
```
>>>

- Desplegamos los recursos necesarios en **Openshift**.

```bash
oc apply -f .\deploy\secret.yaml
oc apply -f .\deploy\deployment.yaml
oc apply -f .\deploy\hpa.yaml
oc apply -f .\deploy\service.yaml
oc apply -f .\deploy\route.yaml
```

>>> [!note] Nota 1
Para eliminar las imagenes residuales y las configuraciones de **Openshift** se ocuparan los siguientes comandos:

```bash
podman rmi -f default-route-openshift-image-registry.apps.ocp-desa.banrural.com.gt/br-cajabr-override-template/mf-renap:v1.0.0

oc delete -f .\deploy\route.yaml
oc delete -f .\deploy\service.yaml
oc delete -f .\deploy\hpa.yaml
oc delete -f .\deploy\deployment.yaml
oc delete -f .\deploy\secret.yaml
```

>>>
>>> [!note] Nota 2
Para desarrollo local debemos utilizar:

```bash
podman run --rm -p 8080:8080 --name mf-renap default-route-openshift-image-registry.apps.ocp-desa.banrural.com.gt/br-cajabr-override-template/mf-renap:v1.0.0

# Para eliminar el contenedor
podman rm -f mf-renap
```
>>>

## 3. Configuración del portal **(Primera instalación)**

- Ubicandonos en el secret `mf-hub-remotes-config` del portal *(proyecto: `br-cajabr-portal-shell`)*, debemos agregar/modificar las siguientes lineas:

>>> [!note] Nota

| Variable | Descripción | Ejemplo |
| :--- | :--- | :--- |
| `{{id/codigoMenu}}` | Debe ser sobreescrito con el **"codigoMenu"** respectivo de la transacción. | `46` |
| `transactionCode` | Es el código (o id) de la transacción. | `18108` |
| `remoteEntryUrl` | Es el path de despliegue del servicio, apuntando a `remoteEntry.js` (En este caso al estar desplegado en el mismo ambiente, podemos obviar la url completa y solo usaremos el path especifico de la transacción). | `/mf-renap` |
| `modulePath` | Es el path el cual utiliza el portal para obtener el servicio a partir del remoteEntry (En este caso al ser el default, se puede dejar vacio, sino se puede ocupar el ejemplo). | `./mount` |
>>>

```json
"46": {
    "transactionCode": "18108",
    "remoteEntryUrl": "/mf-renap"
    "iconUrl": "/imgs/claro.png",
  },
```

- Reiniciamos el deployment del portal:

```bash
oc rollout restart deployment/cajabr-portal-shell -n br-cajabr-portal-shell
```
