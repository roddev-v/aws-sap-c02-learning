exports.handle = async (event) => {
  const data = {
    message: "Hello from Lambda",
    requestId: event?.requestContext?.requestId || null,
    timestamp: new Date().toISOString(),
    items: [
      { id: 1, name: "alpha" },
      { id: 2, name: "beta" }
    ]
  };

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
      "Cache-Control": "max-age=0"
    },
    body: JSON.stringify(data)
  };
};