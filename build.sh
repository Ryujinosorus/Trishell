#INSTALL COMMAND
sudo cp src/trishell.sh /usr/bin/trishell
sudo chmod 755 /usr/bin/trishell

#ADD MAN PAGES
sudo cp man_trishell /usr/local/man/man1/trishell.1
sudo gzip /usr/local/man/man1/trishell.1
