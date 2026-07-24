const trimTrailingSlashes = (value: string): string => {
  let end = value.length;
  while (end > 0 && value[end - 1] === "/") {
    end--;
  }
  return value.slice(0, end);
};

const trimLeadingSlashes = (value: string): string => {
  let start = 0;
  while (start < value.length && value[start] === "/") {
    start++;
  }
  return value.slice(start);
};

export const getFormatBaseUrl = (url: string): string => {
  const newUrl = trimTrailingSlashes(url);
  return newUrl.trim();
};

export const getFormatEndpoint = (endpoint?: string): string => {
  if (!endpoint) return "";
  const newEndpoint = `/${trimLeadingSlashes(endpoint)}`;
  return newEndpoint.trim();
};

export const isAbsoluteUrl = (url: string): boolean => {
  const lower = url.toLowerCase();
  return lower.startsWith("http://") || lower.startsWith("https://");
};
