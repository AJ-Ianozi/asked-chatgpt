After asking ChatGPT to [create an echo server in python](https://github.com/AJ-Ianozi/asked-chatgpt/tree/main/echoserver-python) I then asked it:

> Rewrite the above program in Ada.

The result: it did try.  There's no "Ada.Sockets" library, but this even uses tasks and other ada-specific features.

This code will *not work* without some tweaking.
