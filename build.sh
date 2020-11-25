#INSTALL COMMAND
sudo cp src/trishell /usr/bin/
sudo chmod 755 /usr/bin/trishell

#ADD MAN PAGES
sudo cp trishell /usr/local/man/man1/trishell.1
sudo gzip /usr/local/man/man1/trishell.1
