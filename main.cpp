#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <nlohmann/json.hpp>
#include "encryption.h"

using json = nlohmann::json;
using namespace std;

json database;
string DB_FILE = "database.json";

void load_db() {
    ifstream file(DB_FILE);
    if (!file) {
        database = {{"users", {}}, {"messages", {}}};
    } else {
        file >> database;
    }
    file.close();
}

void save_db() {
    ofstream file(DB_FILE);
    file << database.dump(4);
    file.close();
}

bool register_user(string username, string password) {
    if (database["users"].contains(username)) return false;
    database["users"][username] = {{"password", password}};
    save_db();
    return true;
}

bool login_user(string username, string password) {
    return database["users"].contains(username) && database["users"][username]["password"] == password;
}

void store_message(string sender, string receiver, string encrypted_msg) {
    database["messages"][receiver].push_back({{"sender", sender}, {"message", encrypted_msg}});
    save_db();
}

json get_messages(string user) {
    return database["messages"][user];
}

int main() {
    load_db();
    cout << "Chat Server Running...
";
    while (true) {
        string command;
        cout << "Enter command (register, login, send, get): ";
        cin >> command;

        if (command == "register") {
            string username, password;
            cout << "Enter username: "; cin >> username;
            cout << "Enter password: "; cin >> password;
            if (register_user(username, password)) cout << "User registered!
";
            else cout << "User already exists!
";
        } else if (command == "login") {
            string username, password;
            cout << "Enter username: "; cin >> username;
            cout << "Enter password: "; cin >> password;
            if (login_user(username, password)) cout << "Login successful!
";
            else cout << "Invalid login!
";
        } else if (command == "send") {
            string sender, receiver, message;
            cout << "Sender: "; cin >> sender;
            cout << "Receiver: "; cin >> receiver;
            cout << "Message: "; cin.ignore(); getline(cin, message);
            store_message(sender, receiver, message);
            cout << "Message sent!
";
        } else if (command == "get") {
            string user;
            cout << "Enter username: "; cin >> user;
            json messages = get_messages(user);
            for (auto& msg : messages) {
                cout << "From: " << msg["sender"] << " - " << msg["message"] << endl;
            }
        }
    }
    return 0;
}
