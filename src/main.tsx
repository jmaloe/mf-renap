import { StrictMode } from "react";
import { createRoot } from "react-dom/client";

import "@/index.css";
import App from "@/App.tsx";
import { mockAuthProps } from '@/mocks/authMock';

const container = document.getElementById("root")!;
const root = createRoot(container);

root.render(
  <StrictMode>
    <App  authProps={mockAuthProps} />
  </StrictMode>,
);
