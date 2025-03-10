#include <uwebsockets/App.h>
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <nlohmann/json.hpp>
#include "encrypt.cpp"
#include <cstdlib> // For getenv()

using json = nlohmann::json;
using namespace std;

unordered_map<string, vector<string>> messages;

// Read PORT from Render's environment variable
int getPort() {
    const char* port = getenv("PORT");
    return port ? stoi(port) : 9001; // Default to 9001 if PORT is not set
}

int main() {
    int port = getPort();
    cout << "Starting WebSocket Server on port " << port << endl;

    uWS::App().ws<json>("/chat", {
        .open = [](auto *ws) {
            cout << "Client connected!" << endl;
        },
        .message = [](auto *ws, string_view message, uWS::OpCode opCode) {
            json msg = json::parse(message);
            string sender = msg["sender"];
            string receiver = msg["receiver"];
            string text = encryptMessage(msg["message"]); 

            messages[receiver].push_back(sender + ": " + text);
            ws->send("{\"status\":\"sent\"}", opCode);
        }
    }).listen(port, [](auto *token) {
        if (token) {
            cout << "Server running on Render-assigned port" << endl;
        }
    }).run();

    return 0;
}
