# RPU_Codes

Merging des codes ORUMIP et RPU. Ce dossier comprend 3 sous dossiers:

- Regroupement_ORUMIP: fichiers de données
- Analyse_regroupement: opération pour créer le fichier mergé. A ne faire q'une fois pour mettre à jour le fichier mergé.
- Analyse_merge: analyse du fichier mergé.


Regroupement_ORUMIP
===================

Contient les fichiers natifs et transformés utilisés par _Analyse_regroupement.

Fichier source
--------------

 - __REGROUPEMENT-CIM10-FEDORU-V2.xlsx__ est le fichier des codes de regroupement de la FEDORU (version récupérée sur le site de la FEDORU le 22/11/2015)
 
 - __REGROUPEMENT-CIM10-FEDORU-V2.csv__ est le même fichier sauvegardé au format _csv2_, directement lisible par R.
 
 - __orumip.Rda__ est le même fichier sauvegardé au format compact de R. Son ouverture crée un dataframe du nom _orumip_.
 
Fichiers dérivés
-----------------

- __dpr2.Rda__ est le fichier des RPU 2015 (d15) dont on n'a conservé que les enregistrements où le DP est renseignés. Par ailleurs les caractères anormaux ont été corrigés.

- __merge2015.Rda__ est le fichier résultant du merging des fichiers _dpr2_ et _orumip_.
