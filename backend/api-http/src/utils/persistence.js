import { DateTime } from "luxon";

const jsonJoin = async (json, joins) => {
  const jsonArray = formatterJsonDate(Array.isArray(json) ? json : [json]);
  const joinArray = Array.isArray(joins) ? joins : [joins];
  for (const { join, on, as = "related", many, subJoin = null } of joinArray) {
    for (let i = 0; i < jsonArray.length; i++) {
      const obj = jsonArray[i];
      let result = formatterJsonDate(await join.findByField({[on]: obj[on]}));
      result = subJoin ? await jsonJoin(result, subJoin) : result;
      const newObj = {};
      for (const [key, value] of Object.entries(obj)) {
        if (key === on) {
          if (many) {
            newObj[on] = value;
            newObj[as] = result;
          } else {
            if (value === null) 
              newObj[on] = value;
            newObj[as] = result[0];
          }
        } else { 
          newObj[key] = value;
        }
      }
      jsonArray[i] = newObj;
    }
  }
  return Array.isArray(json) ? jsonArray : jsonArray[0];
};

const generateNumber = (lastNumber) => {
  const match = lastNumber.match(/BOL-(\d{8})-(\d+)/);
  const now = new Date();
  const today = formatDate(now, "YYYY-MM-DD");
  const date = isoDateToDateString(match[1]);
  if (date === today) {
    return `BOL-${match[1]}-${String(Number(match[2]) + 1).padStart(5, '0')}`;
  } else {
    return `BOL-${formatDate(now, "YYYYMMDD")}-${String(1).padStart(5, '0')}`;
  }
};

const formatDate = (date, format) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return format.toUpperCase().replace('YYYY', year).replace('MM', month).replace('DD', day);
};

const isoDateToDateString = (dateStr) => {
  const year = dateStr.substring(0, 4);
  const month = dateStr.substring(4, 6);
  const day = dateStr.substring(6, 8);
  return `${year}-${month}-${day}`;
};

const roundDecimal = (valor) => Math.round(valor * 100) / 100;

const formatterJsonDate = (json) => {
  let jsonArray = Array.isArray(json) ? json : [json];
  jsonArray = jsonArray.map(obj => {
    const newObj = {};
    for (const [key, value] of Object.entries(obj)) {
      if (value instanceof Date) 
          newObj[key] = DateTime.fromJSDate(value, { zone: 'America/Lima' }).toFormat('yyyy-MM-dd HH:mm:ss');
      else
        newObj[key] = value;
    }
    return newObj;
  });
  return Array.isArray(json) ? jsonArray : jsonArray[0];
};

export {
  jsonJoin,
  generateNumber,
  roundDecimal,
  formatterJsonDate
};