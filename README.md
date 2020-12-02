# Projet Langage de Scripts  - SHELL : "Trier en SHELL"

Projet réalisé par Es-sebbani Naim, Guestin Jason, Junhao Li.

## Description

Réalisation d'un programme en SHELL qui trie les entrées d'un répertoire.

## Installation du programme

### Methode 1:

* sudo ./build.sh

### Methode 2:

* chmod u+x trishell.sh


# Liste des fonctionnalités
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



# Liste des fonctionnalités non réalisé

Tout fait pour l'instant, a part caractere speciaux

# Répartition des tâches

|                     | Naim Es-sebbani  |  Jason Guestion  | Junhao Li  
|---------------------|------------------|------------------|-----------
| Base algorithmique  |  :+1:            |                  |  
| -n nameSort         |  :+1:            |                  |  
| -s sizeSort         |                  |  :+1:            |   
| -m lastChangeSort   |                  |  :+1:            |   
| -l linesSort        |                  |  :+1:            |   
| -e extensionSort    |                  |  :+1:            |    
| -t typeSort         |                  |  :+1:            |   
| -p ownerSort        |                  |                  |   :+1:  
| -g groupSort        |                  |                  |   :+1:  
| -d Décroissant      |                  |  :+1:            |   
| -R Récursivité      |  :+1:            |                  |  
| Testeur             |                  |                  |   :+1: 
| Affichage           |                  |  :+1:            |  
| Débogage            |  :+1:            |  :+1:            |    



# Poucentage du travail réalisé 


# Conclusion 
