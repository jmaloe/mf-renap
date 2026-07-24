import { ReactSVG } from "react-svg";
import { memo } from "react";

import { PlaceholderImg } from "@/assets/img";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  src?: string | null;
  isFill?: boolean;
  currentColor?: boolean;
  isHeader?: boolean;
  isDropdown?: boolean;
  open?: boolean;
}>;

const IconSVG = memo(
  ({
    id,
    src = "",
    isFill = false,
    currentColor = false,
    isHeader = false,
    isDropdown = false,
    open = false,
  }: IProps) => {
    if (!src || src == null) return null;

    const setFallback = () => {
      if (isHeader) {
        return (
          <img
            className="banrural-card-form-logo"
            alt="icon-mf"
            src={PlaceholderImg}
          />
        );
      }
    };

    return (
      <ReactSVG
        id={buildComponentId("ico", id)}
        src={src}
        className={
          isDropdown ? `transition-transform ${open && "rotate-180"}` : ""
        }
        fallback={setFallback}
        beforeInjection={(svg) => {
          const paths = svg.querySelectorAll("path");
          paths.forEach((path) => {
            if (currentColor) path.setAttribute("stroke", "currentColor");
            if (isFill) path.setAttribute("fill", "currentColor");
          });
        }}
      />
    );
  },
);

export default IconSVG;
