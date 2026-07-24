const getInitials = (value: string): string => {
  return value
    .trim()
    .split(/\s+/)
    .map((word) => word.charAt(0).toUpperCase())
    .join("");
};

export default getInitials;
