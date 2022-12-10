const lib = require("./lib");
var path = require("path");
const { v4: uuidv4 } = require("uuid");
const { parse } = require("aws-multipart-parser");

// Lambda function index.handler
module.exports.handler = async (event, context, callback) => {
  let response;

  try {
    const formData = parse(event, true);

    const uploadedFile = formData.file.content;
    const uploadedFileExt = path.extname(formData.file.filename);
    const entryId = uuidv4();
    const name = formData.name;
    const message = formData.message;

    await lib.uploadFile(`${entryId}.${uploadedFileExt}`, uploadedFile, uploadedFileExt);

    const updatedTime = new Date(Date.now()).toISOString();

    //Update the DB
    await lib.createGuestEntry(
        entryId,
        name,
        message,
        updatedTime
    );

    response = {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS, POST",
      },
      body: JSON.stringify("Successfully uploaded file"),
    };
  } catch (err) {
    console.log(err);

    response = {
      statusCode: 500,
      headers: {
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS, POST",
      },
      body: JSON.stringify(err.message),
    };
  }
  return response;
};