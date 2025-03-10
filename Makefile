all:
	g++ -o server main.cpp encryption.cpp -std=c++11

clean:
	rm -f server
