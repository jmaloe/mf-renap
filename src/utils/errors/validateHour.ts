const validateHour = (start: number, end: number): boolean => {
  const hour = new Date().getHours();
  return hour >= start && hour < end;
};

export default validateHour;
