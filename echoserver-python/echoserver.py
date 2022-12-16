import socket
import threading
 
# Maximum number of connections that the server can accept
MAX_CONNECTIONS = 5
 
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 
# Bind the socket to the port
server_address = ('localhost', 10000)
print('Starting up on {} port {}'.format(*server_address))
sock.bind(server_address)
 
# Listen for incoming connections
sock.listen(MAX_CONNECTIONS)
 
# This function handles incoming connections and sends an echo response to each client
def handle_client(client_connection):
    # Receive the data in small chunks and retransmit it
    while True:
        data = client_connection.recv(1024)
        if data:
            response = data + b'This is an echo.'
            client_connection.sendall(response)
        else:
            break
 
# This function monitors standard input and shuts down the server if "exit" is typed
def monitor_input():
    while True:
        user_input = input()
        if user_input == 'exit':
            # Shut down the server
            sock.close()
            break
 
# Start a thread to monitor standard input
input_thread = threading.Thread(target=monitor_input)
input_thread.start()
 
# Wait for connections and handle them in a separate thread
while True:
    # Wait for a connection
    print('Waiting for a connection...')
    connection, client_address = sock.accept()
    try:
        print('Connection from {}'.format(client_address))
 
        # Start a new thread to handle the client
        client_thread = threading.Thread(target=handle_client, args=(connection,))
        client_thread.start()
    except:
        # Close the connection
        connection.close()
