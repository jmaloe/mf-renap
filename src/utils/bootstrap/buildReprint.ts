let isReprint: boolean = false;

export const setIsReprint = (value: boolean = true): void => {
  isReprint = value;
};

export const getIsReprint = (): boolean => {
  return isReprint;
};
