# 📘 Guía Técnica del Microfrontend

## 🔧 Configuración Inicial del Proyecto

### Cambio de nombre de la transacción

Reemplazar todas las ocurrencias del nombre base del template *(Se puede hacer uso de la función sobreescribir todo del IDE)*:

```bash
override-template → nombre-transaccion
```

**Ejemplo:**

```bash
override-template → claro-postpago
```

---

## 🌐 Manejo de Variables de Entorno

### Tipos de configuración

#### 1. `.env` (Build time)

- Ubicación: raíz del proyecto
- Uso: desarrollo local (`npm run dev`)
- Contiene variables obligatorias para compilación

---

#### 2. `env-config.json` (Runtime)

- Ubicación: `public/config/env-config.json`
- Uso: configuración dinámica (modificable en despliegue)

**Consumo:**

```ts
const config = await loadEnvConfig()
const transactionCode = config?.transactionCode ?? ""
```

---

## 🔗 Consumo de APIs vía Gateway

### Configuración (env-config.json)

```json
{
  "apiBaseUrl": "https://apigateway-dev.apps.ocp-desa.banrural.com.gt",
  "apiPaths": {
    "phoneNumber": "/ws_cr_claro_postpago/v1/consulta"
  }
}
```

---

### Consumo en código

```ts
const config = await loadEnvConfig()
const token = authContext?.token ?? ""
const apiPath = config?.apiPaths.phoneNumber ?? ""

let userData: IClientRes

try {
  userData = await http.post<IClientRes>(apiPath, token, client)
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error))
  throw new Error(t("msg.descriptions.default", { ns: "error" }))
}
```

---

### ⚠️ Consideraciones

- En desarrollo inicial usar APIs sin gateway
- Requiere token del host → evitar error `401`
- **Obligatorio migrar a gateway en QA**

---

## 🌐 Convención de Idioma

### Objetivo

Mantener consistencia en el desarrollo y una correcta experiencia para el usuario final.

---

### Lineamientos

- **Código fuente (desarrollo):**
  - Utilizar **inglés** en la medida de lo posible.
  - Aplica para:
    - Nombres de variables
    - Funciones
    - Interfaces
    - Tipos
    - Archivos
    - Etc...

---

- **Interfaz de usuario (UI):**
  - Todos los textos visibles para el usuario deben estar en **español**.
  - Aplica para:
    - Labels
    - Mensajes de error
    - Botones
    - Títulos
    - Descripciones
    - Etc...

---

### ⚠️ Consideraciones

- Centralizar los textos de UI en `i18n` (`lang/es`).

---

### Ejemplo

```ts
// Correcto
const userAccountNumber = '123456'

// Incorrecto
const numeroCuentaUsuario = '123456'
```

---

## 🌍 Internacionalización (i18n)

### Regla general

No utilizar valores hardcodeados.

---

### Ubicación

```bash
src/lang/es/
```

---

### Uso

```ts
import { useTranslation } from "react-i18next";

const { t } = useTranslation();
t("buttons.cancel")
t("msg.descriptions.default", { ns: "error" })
```

---

## 🎨 Uso del CDN de Design System

### Objetivo

Asegurar la reutilización de componentes visuales y mantener consistencia en la interfaz de usuario mediante el uso del **Design System centralizado**.

---

### Lineamientos

- Se debe utilizar el CDN oficial del proyecto para consumir estilos, assets y recursos visuales.
- Este CDN contiene componentes y diseños previamente definidos que deben ser reutilizados en lugar de crear nuevos desde cero.
- Su uso garantiza:
  - Consistencia visual entre microfrontends
  - Reducción de esfuerzo de desarrollo
  - Cumplimiento de lineamientos de diseño
- Utilizando la misma dirección presentada más adelante se puede ingresar desde el navegador para tener una pequeña documentación centralizada con lo ya mencionado.

---

### Configuración

El CDN debe configurarse en el archivo `.env`:

```env
VITE_CDN_URL=https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/design-system
```

---

## 🎨 Componentes UI (SHADCN)

### Ubicación

```bash
src/lib
src/components/ui
```

---

### Instalación de nuevos componentes

```bash
npx shadcn@4.1.0 add radio-group
```

---

### ⚠️ Regla

No modificar componentes directamente.

---

## 🔘 Estándares de Navegación y Botones

### Botones de navegación

| Escenario | Acción |
| --- | --- |
| Volver una pantalla | Regresar |
| Reiniciar flujo | Cancelar |
| Modal o finalización | Regresar |

---

### Ejemplo

```tsx
<CancelButton 
  isBack={true} 
  isModal={true} 
  onClick={() => onSelectPage("home")} 
/>
```

---

### Botones de acción

| Escenario | Acción |
| --- | --- |
| Flujo normal | Transmitir |
| Impresión | Imprimir |

```tsx
<TransmitButton isPrint={true} onClick={onSubmit} />
```

---

## 🖼️ Manejo de Iconos SVG

### Reglas

- Descargar desde Figma
- No usar CDN

---

### Uso

```tsx
import IconSVG from "@/components/icons/IconSVG";
import warningIcon from "@/assets/icons/warning.svg";

<IconSVG
    id="alertWarning"
    src={warningIcon}
    isFill={false}
    currentColor={false}
/>
```

---

## ⚠️ Manejo de Modales y Alertas

### Modal de advertencia

Uso exclusivo para errores de APIs:

```tsx
<WarningModal
  title={modalData?.title}
  description={modalData?.description}
  onChangeModal={onChangeModal}
  setOnChangeModal={setOnChangeModal}
  onConfirm={() => onSelectPage("home")}
/>
```

---

### Reglas

- No usar modal de aprobación
- Usar `Alert` para mensajes generales
- Fondo estándar:

```css
bg-black/10
```

---

### Alertas

```tsx
<WarningAlert 
  title={t("alerts.warning")}
  description=""
/>
```

---

## 🔄 Navegación entre Pantallas

### Configuración

- Interfaz: `src/interfaces/navigation/INavigation.ts`
- Implementación: `MainView.tsx`

---

### Nota

Existen pantallas base reutilizables:

- Home
- Recibos / boletas

---

## 📄 Componentes de Visualización

### Campos de solo lectura

Ubicación:

```bash
src/components/fields/ReadOnlyField.tsx
```

---

### Uso

```tsx
<ReadOnlyField 
  label={t("fields.service.label")}
  description={t("fields.service.description")}
/>
```

---

## 👤 Datos de Usuario para Desarrollo

### Ubicación

```bash
src/App.tsx (authProps)
```

### Ejemplo

```tsx
authProps = {
  isAuthenticated: true,
  isLoading: false,
  user: {
    id: "2ef4bd18-bf43-427a-8e86-d75aa123ed76",
    name: "User BanruralTest",
    username: "226513100721",
    email: "test@test.com",
    roles: [
      "default-roles-br-cajabr-realm",
      "offline_access",
      "uma_authorization"
    ],
    profile: {
      cuenta: "3268040966",
      oficina: "50201",
      nombre: "PRUEBA 2",
      descripcion: "LUIS ORLANDO ARREDONDO AREVALO",
      rol: "55",
      id: "42",
      rest: "1",
      renap: "",
      latitud: "0.0",
      longitud: "0.0",
      rolData: {
        descripcionRol: "Administrador"
      },
      departmentData: {
        departamento: "Guatemala",
        municipio: "Fraijanes"
      }
    },
    printType: {
      codigo: "0",
      descripcion: "Hibrida"
    }
  },
  transactInfo: null,
  login: (() => (true)),
  logout: (() => (true)),
  token: import.meta.env.VITE_APIGATEWAY_TOKEN ?? "mf-root",
  tokenParsed: 'ABCDEFGHIJKLMNOPQRSTUVWX',
  loginWithAcr: (() => (true))
}
```

Para realizar el flujo de pruebas para el apartado de re-impresiones *(En **Ultimas transacciones**)*, debemos hacer uso del siguiente endpoint:

```bash
/ws_cr_monitor/v1/consultar-transaccion
```

---

### Body

```json
{
    "login": "226513100721",
    "cantidadTransacciones": 15
}
```

Luego obtenemos los datos de nuestra transacción y los agregamos al campo de **"transactInfo"** en el *.json* anterior:

```tsx
// ...
// user: ...,
transactInfo: {
    horaTransaccion: "7/7/2026 8:21:47 AM",
    fechaTransaccion: "07/07/2026",
    nombreTransaccion: "Claro - Post Pago",
    monto: "1,500.00",
    codigoTransaccion: "18108",
    secuencial: "94007158",
    cuenta: "45454545",
    estado: null
},
// login: (() => (true)),
// ...
```

Y por ultimo, para activar la reimpresión en nuestra transacción debemos dirigirnos al Host/Portal en [https://caja-banrural-dev.apps.ocp-desa.banrural.com.gt/inicio/], y en la sección de ultimas transacciones darle al boton respectivo de nuestro proceso, para que lo habilite, luego nos diriguimos a nuestro desarrollo y realizamos las pruebas respectivas.

>>>[!note] Nota
Tambien podemos hacer uso de la siguiente api, con los datos obtenidos en la api anterior de monitoreo *(`/ws_cr_monitor/v1/consultar-transaccion`)*:

```bash
/ws_reimprime_boletas_cr/v1/ingresa_solicitudab
```

---

```json
{
    "secuencial": "94007158",
    "usuario": "226513100721",
    "oficina": "50201",
    "rol": "55",
    "ip": "192.168.64.1"
}
```

Tomar en consideración, que la activación del proceso de reimpresión, solo funciona una vez, luego de ingresar a nuestro desarrollo si todo esta correcto, se deshabilitara *(Mientras haya sido una solicitud exitosa)*, y tendremos que darle al boton en el host nuevamente (Esto se puede realizar tantas veces necesitemos).
>>>

---

### Propósito

Simular autenticación sin conexión al host.

---

### ⚠️ Importante

Eliminar antes de pasar a QA.

---

## 🧹 Calidad de Código

### Comandos

```bash
npm run lint
npm run lint:fix
npm run lint:css
npm run lint:css:fix
```

---

### Consideraciones

- `console.log` permitido (warning)
- Errores bloquean build (Docker)

---

## 🚀 Despliegue en Host

### Opción 1: Navegador

1. Abrir DevTools (F12) en Host
2. Ir a `Network`
3. Buscar request:

```bash
obtener-nivel
```

4. Actualizar secret del host *(Namespace: br-cajabr-portal-shell)*:

```bash
mf-hub-remotes-config
```

---

### Opción 2: Postman

Endpoint:

```bash
/ws_cr_gestiones_admon/v1/obtener-nivel
```

---

### Body

```json
{
  "operacion": "CST",
  "codigoNivel": 2,
  "codigoRol": 55,
  "codigoPadre": 18100,
  "codigoOficina": 50201
}
```

---

### Parámetros

- `codigoNivel`: profundidad del menú
- `codigoPadre`: depende del nivel

---

## 🖨️ Reimpresiones

Este apartado es diferente para cada servicio, pero las bases de la logica ya se encuentran en el template, entonces utilizando: [*CA_reimpresion.asp*](./reprint/CA_reimpresion.asp), debemos modificar los arhivos involucrados:

> [!note] El archivo **CA_reimpresion.asp** fue extraido del codigo fuente, por cualquier necesidad nos podemos ubicar en **"caja_rural > comercial > Reimpresion > CA_reimpresion.asp"**.

- src > views > MainView.tsx
- src > views > pages > ReceiptView.tsx
- src > views > pages > receipts
- src > services > getReprintData.ts

---

## 📁 Estructura del Proyecto

La estructura esperada en terminos generales debe ser la siguiente:

```bash
proyect
├─ .dockerignore
├─ .stylelintrc.json
├─ components.json
├─ deploy
│  ├─ deployment.yaml
│  ├─ route.yaml
│  ├─ secret.yaml
│  └─ service.yaml
├─ Containerfile
├─ eslint.config.js
├─ index.html
├─ nginx
├─ package-lock.json
├─ package.json
├─ postcss.config.js
├─ public
│  ├─ config
│  └─ favicon.ico
├─ README.md
├─ src
│  ├─ App.tsx
│  ├─ assets
│  │  ├─ icons
│  │  │  ├─ cancel.svg
│  │  │  ├─ cancel_modal.svg
│  │  │  ├─ chevron_left.svg
│  │  │  ├─ error.svg
│  │  │  ├─ print.svg
│  │  │  ├─ success.svg
│  │  │  ├─ transmit.svg
│  │  │  ├─ warning.svg
│  │  │  └─ warning_modal.svg
│  │  └─ img
│  │     ├─ claro.png
│  │     ├─ placeholder.png
│  │     └─ receipt-logo.png
│  ├─ components
│  │  ├─ alerts
│  │  │  └─ WarningAlert.tsx
│  │  ├─ buttons
│  │  │  ├─ CancelButton.tsx
│  │  │  └─ TransmitButton.tsx
│  │  ├─ fields
│  │  │  ├─ DisabledInput.tsx
│  │  │  ├─ MainInput.tsx
│  │  │  └─ ReadOnlyField.tsx
│  │  ├─ headers
│  │  │  └─ MainHeader.tsx
│  │  ├─ icons
│  │  │  ├─ IconSVG.tsx
│  │  │  └─ ModalAlertIcon.tsx
│  │  ├─ loader
│  │  │  └─ MainLoader.tsx
│  │  ├─ modals
│  │  │  └─ WarningModal.tsx
│  │  ├─ radios
│  │  │  └─ PrintTypeRadioButton.tsx
│  │  ├─ separators
│  │  │  ├─ MainSeparator.tsx
│  │  │  └─ SignSeparator.tsx
│  │  ├─ tables
│  │  │  ├─ letter
│  │  │  │  ├─ LetterDataTable.tsx
│  │  │  │  └─ LetterDataTrField.tsx
│  │  │  ├─ receipt
│  │  │  │  ├─ ReceiptUserTable.tsx
│  │  │  │  └─ ReceiptUserTdField.tsx
│  │  │  └─ voucher
│  │  │     ├─ VoucherDataTable.tsx
│  │  │     └─ VoucherDataTrField.tsx
│  │  ├─ titles
│  │  │  ├─ MainTitle.tsx
│  │  │  └─ ModalTitle.tsx
│  │  └─ ui
│  │     ├─ button.tsx
│  │     ├─ card.tsx
│  │     ├─ field.tsx
│  │     ├─ input.tsx
│  │     ├─ label.tsx
│  │     └─ separator.tsx
│  ├─ i18n.tsx
│  ├─ index.css
│  ├─ interfaces
│  │  ├─ auth
│  │  │  ├─ IAuthContext.ts
│  │  │  ├─ IDepartmentData.ts
│  │  │  ├─ IPrintType.ts
│  │  │  ├─ IRoleData.ts
│  │  │  ├─ IUser.ts
│  │  │  └─ IUserProfile.ts
│  │  ├─ clientData
│  │  │  ├─ IClientData.ts
│  │  │  ├─ IClientReq.ts
│  │  │  └─ IClientRes.ts
│  │  ├─ env
│  │  │  └─ IEnv.ts
│  │  ├─ modal
│  │  │  └─ IModalData.ts
│  │  ├─ navigation
│  │  │  ├─ INavigation.ts
│  │  │  └─ IPrintNavigation.ts
│  │  ├─ paymentData
│  │  │  ├─ IPaymentData.ts
│  │  │  ├─ IPaymentReq.ts
│  │  │  └─ IPaymentRes.ts
│  │  ├─ receipt
│  │  │  ├─ IReceiptData.ts
│  │  │  └─ ISize.ts
│  │  └─ validAmountData
│  │     ├─ IValidAmountReq.ts
│  │     └─ IValidAmountRes.ts
│  ├─ lang
│  │  └─ es
│  │     ├─ errors.json
│  │     └─ layout.json
│  ├─ lib
│  │  └─ utils.ts
│  ├─ main.tsx
│  ├─ mount.tsx
│  ├─ services
│  │  ├─ getClientData.ts
│  │  └─ postPaymentStatus.ts
│  ├─ utils
│  │  ├─ bootstrap
│  │  │  ├─ baseUrlFromImportMeta.ts
│  │  │  └─ loadEnvConfig.ts
│  │  ├─ errors
│  │  │  └─ handleImageError.ts
│  │  ├─ formats
│  │  │  ├─ formatDate.ts
│  │  │  ├─ formatNumber.ts
│  │  │  ├─ formatString.ts
│  │  │  └─ formatUrl.ts
│  │  └─ http
│  │     ├─ client.ts
│  │     └─ useRequest.ts
│  └─ views
│     ├─ ErrorView.tsx
│     ├─ MainView.tsx
│     └─ pages
│        ├─ ClientView.tsx
│        ├─ HomeView.tsx
│        ├─ PreviewView.tsx
│        ├─ receipts
│        │  ├─ LetterView.tsx
│        │  └─ VoucherView.tsx
│        └─ ReceiptView.tsx
├─ tsconfig.app.json
├─ tsconfig.json
├─ tsconfig.node.json
└─ vite.config.ts

```

## 🌳 Estrategia de Ramas

| Rama | Entorno |
| --- | --- |
| main | Producción |
| qa | QA |
| develop | Desarrollo |

---

### Feature branches

```bash
feature/<descripcion>
```

**Ejemplo:**

```bash
feature/consulta-saldo
```

---

## ✅ Notas Finales

- Seguir estándares definidos para mantener consistencia entre microfrontends
- Validar configuración antes de despliegues
- Evitar hardcoding y asegurar uso de i18n
- Mantener separación clara entre desarrollo, QA y producción
