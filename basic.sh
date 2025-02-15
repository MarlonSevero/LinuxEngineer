#!/bin/bash

echo "Infos do sistema"
id root 
hostname
pwd
mkdir folder 
ls -la folder
cp -v /etc/passwd folder/passwd.bk
touch folder/teste.txt
echo "texto">> folder/teste.txt
mkdir folder/secondy
mv folder/teste.txt folder/secondy
echo "Backup realizado com sucesso" 
