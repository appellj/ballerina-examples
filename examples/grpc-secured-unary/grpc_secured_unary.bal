// This is server implementation for secured connection (HTTPS) scenario
import ballerina/io;
import ballerina/log;
import ballerina/grpc;

// Server endpoint configuration with SSL configurations.
endpoint grpc:Listener ep {
    host: "localhost",
    port: 9090,
    secureSocket: {
        keyStore: {
            path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "${ballerina.home}/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        },
        protocol: {
            name: "TLSv1.2",
            versions: ["TLSv1.2", "TLSv1.1"]
        },
        ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"],
        sslVerifyClient: "require"
    }
};

service<grpc:Service> HelloWorld bind ep {
    hello(endpoint caller, string name) {
        io:println("name: " + name);
        string message = "Hello " + name;

        // Sends response message to the caller.
        error? err = caller->send(message);

        io:println(err.message but { () => "Server send response : " +
                                                                    message });
        // Sends `completed` notification to caller.
        _ = caller->complete();

    }
}
