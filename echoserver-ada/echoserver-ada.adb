with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Unchecked_Conversion;
with Ada.Integer_Text_IO;
with Ada.Sockets;
with System.IO_Types;
with Ada.Calendar;
 
procedure Echo_Server is
 
   -- Maximum number of connections that the server can accept
   MAX_CONNECTIONS : constant := 5;
 
   -- Address and port for the server
   Server_Address : constant System.IO_Types.Address_Type :=
     ( Family => System.IO_Types.AF_INET,
       Port   => 10000,
       Addr   => (0, 0, 0, 0)
     );
 
   -- Socket for the server
   Server_Socket : Ada.Sockets.Socket_Type;
 
   -- Accept a connection and handle it in a separate task
   procedure Handle_Connection
     (Connection : Ada.Sockets.Socket_Type) is
   begin
      declare
         -- Buffer for receiving data
         Buffer : aliased System.IO_Types.Buffer_Type;
 
         -- Unbounded string for sending and receiving data
         Data : Ada.Strings.Unbounded.Unbounded_String;
 
         -- Status code for sending and receiving data
         Status : Ada.Sockets.Status_Type;
 
         -- Current time
         Current_Time : Ada.Calendar.Time;
      begin
         loop
            -- Receive data from the client
            Status := Connection.Receive (Buffer);
            Data := Ada.Unchecked_Conversion.Unchecked_Conversion
              (Buffer.all);
            exit when Data.Length = 0;
 
            -- Append the echo message
            Append (Data, "This is an echo.");
 
            -- Send the response to the client
            Connection.Send (Ada.Unchecked_Conversion.Unchecked_Conversion (Data));
         end loop;
      end;
   end Handle_Connection;
 
   -- Wait for connections and handle them in a separate task
   task type Connection_Handler is
      entry Start;
   end Connection_Handler;
 
   task body Connection_Handler is
   begin
      accept Start do
         loop
            declare
               -- Address of the client
               Client_Address : System.IO_Types.Address_Type;
 
               -- Socket for the client
               Client_Socket : Ada.Sockets.Socket_Type;
            begin
               -- Accept a connection from the client
               Server_Socket.Accept (Client_Address, Client_Socket);
 
               -- Handle the connection in a separate task
               declare
                  Task : Connection_Handler;
               begin
                  Put_Line ("Connection from " &
                    System.IO_Types.Address_Image (Client_Address));
                  Task.Start (Client_Socket);
               end;
            end;
         end loop;
      end Start;
   end Connection_Handler;
 
   -- Monitor standard input and shut down the server if "exit" is typed
   task type Input_Monitor is
      entry Start;

