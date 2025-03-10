#include "encryption.h"
#include <iostream>

using namespace std;

string encrypt_message(string plain) {
    return "ENCRYPTED(" + plain + ")";
}

string decrypt_message(string cipher) {
    return cipher.substr(10, cipher.size() - 11);
}
