const formatterResponse = (data, message) => {
  return {
    success: true,
    message,
    data,
    items: data.length,
  };
};

const errorResponse = (message) => {
  return {
    success: false,
    message: message,
  };
};

export { 
  formatterResponse, 
  errorResponse 
};