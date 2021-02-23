export const uuid = () => {
  const key = 'wyyx__education__uuid';
  let res = localStorage.getItem(key);
  if (!res) {
    res = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
    localStorage.setItem(key, res);
  }
  return res;
};
