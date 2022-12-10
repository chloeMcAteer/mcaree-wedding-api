const AWS = require("aws-sdk");
AWS.config.region = "eu-west-2";
const s3Client = new AWS.S3();
const dynamoClient = new AWS.DynamoDB.DocumentClient();

const uploadFile = (fileName, file, mimeType) => {
  console.log("uploadFile");
  const buf = new Buffer(file, "base64");

  const uploadParams = {
    Bucket: process.env.S3_BUCKET_NAME,
    Key: fileName,
    Body: buf,
    ContentType: mimeType,
  };

  return s3Client.putObject(uploadParams).promise();
};

const createGuestEntry = async (
    entryId,
    name,
    message,
    updatedTime
) => {
  console.log(`createGuestEntry: ${entryId}`);
  var dbParams = {
    Item: {
      entry_id: entryId,
      name: name,
      message: message,
      last_updated: updatedTime,
    },
    ReturnConsumedCapacity: "NONE",
    TableName: process.env.DATABASE_NAME,
  };

  try {
    await dynamoClient.put(dbParams).promise();
  } catch (error) {
    throw error;
  }
};

module.exports = {
  uploadFile,
  createGuestEntry
};