import { useEffect, useRef, useState } from "react";

type IProps = Readonly<{
  contentWidth: number;
}>;

const useAutoScale = ({ contentWidth }: IProps) => {
  const containerRef = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(1);

  useEffect(() => {
    const element = containerRef.current;
    if (!element) return;

    const resizeObserver = new ResizeObserver(([entry]) => {
      const availableWidth = entry.contentRect.width;

      const newScale = Math.min(availableWidth / contentWidth, 1);
      setScale(newScale);
    });

    resizeObserver.observe(element);

    return () => resizeObserver.disconnect();
  }, [contentWidth]);

  return { containerRef, scale };
};

export default useAutoScale;
