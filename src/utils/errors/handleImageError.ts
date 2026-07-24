import { PlaceholderImg } from "@/assets/img";

const handleImageError = (e: React.SyntheticEvent<HTMLImageElement, Event>) => {
  const img = e.currentTarget;
  img.onerror = null;
  img.src = PlaceholderImg;
};

export default handleImageError;
