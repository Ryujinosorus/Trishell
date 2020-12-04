# Projet Langage de Scripts  - SHELL : "Trier en SHELL"

Projet réalisé par Es-sebbani Naim, Guestin Jason, Junhao Li.

Porte: https://github.com/Ryujinosorus/Trishell

## Description

Réalisation d'un programme en SHELL qui trie les entrées d'un répertoire.

## Installation du programme

### Methode 1:

* sudo ./build.sh

### Methode 2:

* chmod u+x trishell.sh


# Liste des fonctionnalités demandé
* -R : tri le contenu de l’arborescence débutant au répertoire rep. Dans ce cas on triera par rapport aux noms des entrées mais on affichera le chemin d’accès 
* -d : tri dans l’ordre décroissant, par défaut le tri est effectué dans l’ordre croissant 
* -nsdletpg : permet de spécifier le critère de tri utilisé. Ces critères peuvent être combinés, dans ce cas si deux fichiers sont identiques pour le premier critère, le second critère les départegera et ainsi de suite.
*   -n : tri suivant le nom des entrées ;
*   -s : tri suivant la taille des entrées ;
*   -m : tri suivant la date de dernière modification des entrées ;
*   -l : tri suivant le nombre de lignes des entrées ;
*   -e : tri suivant l’extension des entrées (caractères se trouvant après le dernier point du nom de l’entrée ;
*   -t : tri suivant le type de fichier (ordre : répertoire, fichier, liens, fichier spécial de type bloc, fichier spécial de type caractère, tube nommé, socket) ;
*   -p : tri suivant le nom du propriétaire de l’entrée ;
*   -g : tri suivant le groupe du propriétaire de l’entrée.


# Liste des fonctionnalités réalisé

## Fonction de tri

Tout le temps le meme principe:
    Prend 2 arguments .
    Renvoie 1 si $1 < $2
    Renvoie 0 si $1> $2
    Renvoie 2 si $1 = $2

* nameSort() :
  * test "$chaine1" \< "$chaine2" permet de comparer par rapport a l'ordre lexicographique
* sizeSort() :
  * stat -c "%s" renvoie la taille de cette entrée.

* lastChangeSort() :
  * stat -c "%Y" renvoie la derniere modification de cette entrée

* linesSort() :
  * On calcule les lignes seulement sur les entrées de type fichier, soit -f.
  * wc -l -- "$fichier" | cut -d\  -f1 permet de récuperer le nombre de ligne

* extensionSort() : 
* typeSort() : 
    * On regarde le type via -d -f -L -b -c -p -S
* ownerSort() : 
  * stat -c "%U" renvoie une chaîne correspondant au nom du groupe de cette entrée.

* groupSort() : 
  * stat -c "%G" renvoie une chaîne correspondant au nom du groupe de cette entrée.

* getLowest() :
    * Prend trois arguments,``` getLowest $file1 $file2 0``` compare les deux premiers arguments en fonction du premier parametre de tri '0', en cas d'égalité il y a un appel récursive ```getLowest $1 $2 $(($3+1))```
* getLast() :
    * Prend en paramétre un tableau. Parcour le tableau et retourne le plus petit grace à ``` getLowest ```. 
* change() : 
    * ``` change $tab $elemm``` renvoie le tableau sans l'elément $elem
* tri() : 
    * Prend en paramétre une chaine de caractére représantant un tableau dans lequel chaque élément du tableau est séparé par un / . Parcour le tableau et affiche le plus petit grace à ``` getLast ``` puis réitére cette opération sur le tableau sans le plus petit élément tant que le tableau n'est pas vide . 

# Liste des fonctionnalités non réalisé

## Tri en O(nlogn)

Un tri en 0(nlogn) a été réalisé.
Voici le code :

```
getElemAt(){
    echo "$1" | cut -d/ -f$(($2+1))
}


reduce(){
    test $1 = 0 && echo 1 && exit
    res=`bc -l <<< $1/1.3`
    res=`echo $res | cut -d. -f1`
    test -z $res && echo 1 && exit
    if test "$res" = "0"
    then
        echo 1
    else
        echo $res
    fi
}

swap(){
    res=`echo "$1" | sed -E 's/'$2'\//'$3'_\//'`
    res=`echo "$res" | sed -E 's/'$3'\//'$2'\//'`
    res=`echo "$res" | sed -E 's/'$3'_\//'$3'\//'`
    echo "$res"
}

tri(){
    permutation="true"
    tab=$1
    gap=$2
    while [ $permutation = "true" ] || [ "$gap" -gt 1 ]
    do
        permutation="false"
        gap=`reduce $gap`
        for index in $(seq 0  $(($2-$gap-1)) )
        do
            file1=`getElemAt $tab $index`
            file2=`getElemAt $tab $(($index+$gap))`
            if test `getLowest $file2 $file1 0` = 1
            then
                permutation="true"
                tab=`swap $tab $file1 $file2`
            fi
        done
    done
    IFS=/
}
   
```
Ceci est une representation du tri a peigne . 
Cependant lors de la permutation d'élements, nous utilisons 3 commande sed . 
A cela s'ajoute l'utilisation de float ainsi que des divisions . 
Donc au final notre tri en O(n2) est plus rapide que notre tri en O(nlogn)

# Répartition des tâches

|                     | Naim Es-sebbani  |  Jason Guestion  | Junhao Li  
|---------------------|------------------|------------------|-----------
| Base algorithmique  |  :+1:            |                  |  
| -n nameSort         |  :+1:            |                  |  
| -s sizeSort         |                  |  :+1:            |   
| -m lastChangeSort   |                  |  :+1:            |   
| -l linesSort        |                  |  :+1:            |   
| -e extensionSort    |                  |                  |   :+1:   
| -t typeSort         |                  |  :+1:            |   
| -p ownerSort        |                  |                  |   :+1:  
| -g groupSort        |                  |                  |   :+1:  
| -d Décroissant      |                  |  :+1:            |   
| -R Récursivité      |  :+1:            |                  |  
| Testeur             |                  |                  |   :+1: 
| Affichage           |                  |  :+1:            |  
| Débogage            |  :+1:            |  :+1:            |    
| Manual              |  :+1:            |                  |    


# Poucentage du travail réalisé 


# Conclusion 
