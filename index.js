// Lambda function index.handler
module.exports.handler = async (event) => {
    try {
    
        const response = {
            statusCode: 200,
            // Using AWS Lambda Proxy, the code itself is responsible for dealing with CORS
            // https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html
            headers: {
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "OPTIONS,DELETE"
            },
            body: JSON.stringify({ message: 'Successfully called lambda' })
        };

        return response;
    } catch (err) {
        console.log(err);
        const response = {
            statusCode: 400,
            headers: {
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "OPTIONS,DELETE"
            },
            body: JSON.stringify({ message: 'Something went wrong uploading image' })
        };

        return response;
    }
}