#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/aes.h>
#include <iostream>

std::string encryptMessage(const std::string &message) {
    // Dummy AES encryption (replace with real encryption logic)
    return "ENCRYPTED_" + message;
}

std::string decryptMessage(const std::string &message) {
    return message.substr(10);
}
