/* eslint-disable react-refresh/only-export-components */
import { StrictMode } from "react";
import { createRoot, type Root } from "react-dom/client";

import App from "@/App";

type MountProps = React.ComponentProps<typeof App>;

interface IProps {
  unmount: () => void;
  updateProps: (next?: MountProps) => void;
}

const Mount = (container: Element, props?: MountProps): IProps => {
  const root: Root = createRoot(container);

  const render = (next?: MountProps) => {
    root.render(
      <StrictMode>
        <App {...(next ?? {})} />
      </StrictMode>,
    );
  };

  render(props);
  
  return {
    unmount: () => root.unmount(),
    updateProps: (next) => render(next),
  };
};

export { Mount as mount };
