#!/bin/bash

#AUTHOR : Es-sebbani Naim, Guestin Jason, Junhao Li
# Sort entry files of a directory

# Copyright (C) 2020 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,

version="trishell 1.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software.  You may redistribute copies of it under the terms of
the GNU General Public License <https://www.gnu.org/licenses/gpl.html>.
There is NO WARRANTY, to the extent permitted by law.

Written by Es-sebbani Naim, Guestin Jason, Junhao Li."

usage="Usage: $0 [-R] [-nsmleptg] dir
Sort entry files (by default, ascending order).

You can use all this option

    -R,         sort the contents of the tree starting at the directory dir. In this case we will sort according to the entry names but the path will be display(ed)?,
    -d,         sorting in descending order, by default sorting is done in ascending order,
    -n,         sort according to the entry name,
    -s,         sort by entry size,
    -m,         sort according to the last modification date of the entries,
    -l,         sort according to the number of rows of entries,
    -e,         sort according to the extension of the entries (characters found after the last point of the entry name),
    -p,         sort by the name of the entry owner,
    -t,         sort according to the type of file (order: directory, file, links, block type special file, file special type character, named pipe, socket),
    -g,         sort by the name of the entry group,
    -help       display this help and exit
    -version    display version information and exit


Report bugs to <naimessebbani@gmail.com>."

case "$1" in
-help)    echo "$usage"  || exit 0; exit;;
-version) echo "$version" || exit 0; exit;;
esac

firstIFS=$IFS
IFS=$' \t\n'
if [[ $# -gt 4 ]]
then
    echo "Trop d'arguments, $usage"
    exit 1
fi

#INIT VAR
asc=true
recursively=false
sortOrder="NULL"
sortLength=1
path="NULL"

#READ ARG
for i in "$@"
do
    if [[ "$i" = "-R" ]]
    then
        test "$recursively" = true && echo "Doublon dans les parametres -R" && exit 2
        recursively=true
    elif [[ "$i" = "-d" ]]
    then
        test $asc = false && echo "Doublon dans les parametres" && exit 2
        asc=false
    elif [[ "$i" =~ ^[^-] ]]
    then
        test "$path" != NULL && echo "Doublon dans les parametres" && exit 2
        ! test -d "$i" && echo "Chemin incorrect: $i" && exit 3
        path="$i"
    else
        test $sortOrder != NULL && echo "Doublon dans les parametres" && exit 2
        sortOrder="$i"
        sortLength=${#sortOrder}

        for a in $(seq 3 $(($sortLength+1)))
        do
            opt=`echo '\'$sortOrder | cut -c$a`
            if ! [[ $opt =~ [n|s|m|l|e|t|p|g] ]] 
            then
                echo "-$opt est un paramètre de tri invalide" && exit 4
            fi
        done
    fi
done
test "$path" = NULL && path="."


if [[ $sortOrder = NULL ]]
then
    sortOrder="-n"
fi

#START OF PROG
firstPath=`pwd`
cd "$path"
currentPath=`pwd`
allData=""
sizeOfAllData=0
allFolder=""
for i in *
do
    i=`echo $i | sed 's/\?/\\\?/'`
    allData="$i/$allData"
    test -d "$i" && allFolder="$currentPath/$i:$allFolder"
    sizeOfAllData=$(($sizeOfAllData+1))
done
echo -e "\x1B[39m\x1B[1m`pwd`\x1B[0m"
test "$allData" = "*/" && exit 0



#FONCTIONS DE TRI
#Tout le temps le meme principe
#Renvoie 1 si $1 < $2, 0 si $1 > $2, 2 si $1=$2

#tri par rapport au nom
nameSort(){
    if test "$1" \< "$2" 
    then
        echo 1
    elif test "$1" = "$2"
    then
        echo 2
    else
        echo 0
    fi
}

#tri par rapport a la valeur numérique
intSort(){
    if [[ "$1" -lt "$2" ]]
    then
        echo 1
    elif [[ "$1" -eq "$2" ]]
    then
        echo 2
    else
        echo 0
    fi
}

#tri par rapport a la taille
sizeSort(){
    local res1=`stat -c '%s' -- "$1"`
    local res2=`stat -c '%s' -- "$2"`

    intSort $res1 $res2
}

#tri par rapport a la derniere date de modification 
lastChangeSort(){
    local timestamp1=`stat -c '%Y' -- "$1"`
    local timestamp2=`stat -c '%Y' -- "$2"`

    intSort "$timestamp1" "$timestamp2"
}

#tri par rapport au nombre de ligne
linesSort(){
     local res1
     local res2

     if test -f "$1"; then
         res1=`wc -l "$1" | cut -d' ' -f1`
     elif test ! -f "$1"; then
         res1=0
     fi

     if test -f "$2"; then
         res2=`wc -l "$2" | cut -d' ' -f1`
     elif test ! -f "$2"; then
         res2=0
     fi

    intSort $res1 $res2
}


#tri par rapport a l'extension
extensionSort(){
    #chaine 1 et 2 sont les extensions
    # awk -F. separate the string by dot
    # print $NF will print the last one   
    local chaine1
    local chaine2
    case $1 in
    *.*)  
    chaine1=`echo -- "$1" | awk -F. '{print $NF}'`;;
    *)
    chaine1=0
    ;;
    esac

    case $2 in
    *.*)  
    chaine2=`echo -- "$2" | awk -F. '{print $NF}'`;;
    *)
    chaine2=0
    ;;
    esac

    nameSort "$chaine1" "$chaine2"
}

#tri par rapport au type
typeSort(){
    # Répertoire: valeur 1
    # Fichier: valeur 2
    # Lien symbolique: valeur 3
    # Fichier bloc: valeur 4
    # Fichier caractère: valeur 5
    # Tube nommé: valeur 6
    # Socket: valeur 7
    # Le reste à la valeur 8.

    local res1
    local res2

    if test -d "$1"; then
        res1="1"
    elif test -f "$1"; then
        res1="2"
    elif test -L "$1"; then
        res1="3"
    elif test -b "$1"; then
        res1="4"
    elif test -c "$1"; then
        res1="5"
    elif test -p "$1"; then
        res1="6"
    elif test -S "$1"; then
        res1="7"
    else
        res1="8"
    fi

    if test -d "$2"; then
        res2="1"
    elif test -f "$2"; then
        res2="2"
    elif test -L "$2"; then
        res2="3"
    elif test -b "$2"; then
        res2="4"
    elif test -c "$2"; then
        res2="5"
    elif test -p "$2"; then
        res2="6"
    elif test -S "$2"; then
        res2="7"
    else
        res2="8"
    fi

    intSort "$res1" "$res2" 
}

#tri par rapport au proprietaire
ownerSort(){    
    # $1 $2 est le chemin de ce fichier ou répertoire
    # compare the owner name of 2 files or folders.
    
    local chaine1=`stat -c '%U' -- "$1"`
    local chaine2=`stat -c '%U' -- "$2"`


    nameSort "$chaine1" "$chaine2"
}

#tri par rapport au groupe
groupSort(){
    # $1 $2 est le chemin de ce fichier ou répertoire
    # compare the group name of 2 files or folders.
   
    local chaine1=` stat -c "%G" -- "$1"`
    local chaine2=` stat -c "%G" -- "$2"`

    nameSort "$chaine1" "$chaine2"
}
#FIN FONCTION DE TRI


#getLowest $elem1 $elem2
#compare les deux parametres par rapport au tri fourni en drapeux
#renvoie 1 si $1 est plus petit que $2, sinon 0
getLowest(){
    if [[ $3 -ge $sortLength ]]
    then
        echo "1"
    else
        #On recupere le nom de la fonction de tri aproprié
        local char=`echo '\'$sortOrder | cut -c$(($3+3))`
        local res
        #On compare
        IFS=\ 
        case $char in
        n) res=`nameSort "$1" "$2"`;;
        s) res=`sizeSort "$1" "$2"`;;
        m) res=`lastChangeSort "$1" "$2"`;;
        l) res=`linesSort "$1" "$2"`;;
        e) res=`extensionSort "$1" "$2"`;;
        t) res=`typeSort "$1" "$2"`;;
        p) res=`ownerSort "$1" "$2"`;;
        g) res=`groupSort "$1" "$2"`;;
        esac
        #Si il y a egalité on passe au tri suivant
        if [[ "$res" -eq 2 ]]
        then
            local tmp=`expr $3 + 1`
            echo `getLowest "$1" "$2" $tmp`
        else
        IFS=/
        #Sinon on affiche le resultat
            if test $asc = "true"
            then 
                echo $res
            elif test "$res" = 1
            then 
                echo 0
            else
                echo 1
            fi
        fi
    fi
}

#parcour le "tableau" fourni agrument ($1) et renvoie le plus petit element
getLast(){
    local res=`echo "$1" | cut -d'/' -f1`
    for i in $1
    do
        if [[ `getLowest "$i" "$res" 0` -eq 1 ]]
        then
            res="$i"
        fi
    done
    echo "$res"
}

#suprime $1 de $2
change(){
    local res=""
    for i in $2
    do
        if [[ "$1" != "$i" ]]
        then
            res="$res""$i/"
        fi
    done
    echo "$res"
}

#recupere le plus petit element, l'affiche, et relance la meme fonction sans le plus petit element
tri(){
    test -z "$1" && return  
    local res=`getLast "$1"`
    if test -d "$res"
    then
        echo -e "\x1B[94m'-> "$res"\x1B[0m"
    else
        echo -e "\x1B[96m'-> "$res"\x1B[0m"
    fi
    tri "`change "$res" "$1"`"
}

#modifie l'IFS et trie
main(){
    IFS=/
    tri "$allData"
    IFS=' '
}


recursivity(){
    IFS=":"
    for i in $allFolder
    do
        tmp=""
        if test $asc = "false"
        then 
            tmp="-d"
        fi
        "$0" "$i" $sortOrder -R $tmp
    done
}


main 
cd "$firstPath"
test $recursively = true && recursivity
IFS=$firstIFS
exit 0
