# Analyse par codes de regroupement
JcB  
03/12/2014  

source: Stat Resural/Codes regroupement_ORUMIP/analyse_regroup.Rmd

Analyse du fichier transmis par l'ORUMIP
========================================
 
Le fichier Regroupements ORUMiP Thésaurus SFMU.csv doit être enregistré en inclant les guillemets entre les différents champs à cause des apostophes. La ligne 1 doit être supprimée.

dictionnaire des termes
-----------------------
- GAUX: signes généraux et autres pathologies
- MLSV: malaises, syncope

Le fichier de travail __d3__ est préparé à partir de __d14__ pour les données 2014 et le fichier de regroupement de l'Orumip (version 2). Les fichiers sources sont mergés sur la base des codes CIM10. Les codes CIM10 Orumip respectent la nomenclature PMSI avec des détails supplémentaires précédés du signe +.

Pour le calcul des horaires de PDS il faut rajouter le fichier __Trame commune/horaires_pds.Rda__.

Le 6/6/2015 ajout de la colonne SORTIE dans d3 pour pouvoir calculer une durée de présence en fonction de la pathologie.


```r
library(knitr)
options(scipen = 6, digits = 2)

# # Pour MAC:
# path <- "Regroupement_ORUMIP"
# d <- read.csv2(paste(path, file2, sep="/"), skip = 1)
# load("../RPU_2014/rpu2014d0112_c2.Rda") # d14
# load("~/Documents/RESURAL/Trame_Commune/horaires_pds.Rda") #h.pds
# 
# # 
# # Pour XPS
# # path <- "../Regroupement_ORUMIP"
# # file2 <- "REGROUPEMENT-CIM10-FEDORU-V2.csv"
# 
# # on récupère la nomenclature de l'Orumip
# d <- read.csv2(paste(path, file2, sep="/"), skip = 1)
# # save(d, file = "../Regroupement_ORUMIP/REGROUPEMENT-CIM10-FEDORU-V2.Rda")
# 
# # # DP 2014
# # load("~/Documents/Resural/Stat Resural/RPU_2014/rpu2014d0112_c2.Rda") # d14
# 
# # Ajout des horaires de PDS
# d14$HPDS <- h.pds
# 
# # Sélestion des colonnes utiles
# dpr2 <- d14[!is.na(d14$DP), c("DP","CODE_POSTAL","ENTREE","SORTIE", "FINESS","GRAVITE","ORIENTATION","MODE_SORTIE","AGE","SEXE","TRANSPORT","DESTINATION","NAISSANCE", "HPDS")]
# 
# # correction des caractères bloquants
# dpr2$DP<-gsub("\xe8","è",as.character(dpr2$DP),fixed=FALSE)
# dpr2$DP<-gsub("\xe9","é",as.character(dpr2$DP),fixed=FALSE)
# 
# # suppression des points décimaux
# dpr2$DP <- gsub(".", "", dpr2$DP, fixed=TRUE)
# 
# # suppression des minuscules
# dpr2$DP <- toupper(dpr2$DP)
# # save(dpr2, file = "dpr2.Rda")
# 
# # on réalise un merging des deux fichiers sur la base du code CIM 10
# d3 <- merge(dpr2, d, by.x = "DP", by.y = "Code", all.x = TRUE)
# save(d3, file = "d3.Rda") # d3
# 
# # ménage
# rm(d14, d, dpr2)
```

Fichier des codes de regroupement ORUMIP
========================================

Analyse du fichier source de l'ORUMIP.

```r
path <- "../Regroupement_ORUMIP/Old Regroupement/" # en mode console path <- "Regroupement_ORUMIP"
# file <- "Regroupements ORUMiP Thésaurus SFMU.csv"
file2 <- "REGROUPEMENT-CIM10-FEDORU-V2.csv"

# on récupère la nomenclature de l'Orumip
#d <- read.csv(paste(path, file, sep="/"), skip = 1)
d <- read.csv2(paste(path, file2, sep="/"), skip = 1)

names(d)
```

```
## [1] "Code"          "Libéllé.CIM"   "X"             "TYPE.URGENCES"
## [5] "CHAPITRE"      "SOUS.CHAPITRE"
```
Retrouver tous les codes CIM10 correspondants à une gastro-entérite:


```r
ge <- d[which(d$SOUS.CHAPITRE == "Diarrhée et gastro-entérite"),]
```
On rouve 91 codes. Les GE habituelles sont regroupées par les codes commençant par __A0__. Wikipédia rapporte aussi le code __J10.8__, __J11.8__ (GE grippale), 

Création  d'un nouveau fichier août 2015
========================================

L'objectif est de créer un fichier résultant du merging des RPU 2015 et des codes de regroupement ORUMIP.

Récupération des codes de regroupement
--------------------------------------
Les codes de regroupement sont fournis sous forme d'un classeur Excel.

- création d'un nouveau dossier: Regroupement_ORUMIP/Regroupement_ORUMIP/
- on y met _Regroupements ORUMiP Thésaurus SFMU.xlsx_. Le 22/11/2015 on le remplace par le fichier __REGROUPEMENT-CIM10-FEDORU-V2.xlsx__ récupéré sur le site de la FEDORU.
- on sauvegarde _REGROUPEMENT-CIM10-FEDORU-V2.xlsx_ au format .CSV2 (semi-colon) car le tableur posssède des rubriques où les mots sont séparés par des virgules, sous le nom de __REGROUPEMENT-CIM10-FEDORU-V2.csv__.
- Le fichier CSV récupéré sous le nom __orumip__ et sauvegardé au format R sous __orumip.Rda__.

```{}
# pour mac en mode console
path <- "Regroupement_ORUMIP/Regroupement_ORUMIP/"
file <- "REGROUPEMENT-CIM10-FEDORU-V2.csv"
orumip <- read.csv2(paste0(path, file), skip = 2)

```

On renomme les entête de colonnes
```{}
x <- c("CIM10", "LIBELLE_CIM10", "SFMU", "TYPE_URGENCES", "CHAPITRE","SOUS_CHAPITRE")
names(orumip) <- x

names(orumip)
head(orumip)

# enregistrement au format R
write.csv2(orumip, file = "orumip.Rda")
```

Récupération des RPU 2015
-------------------------
Le ficher des RPU récupéré et nettoyé (on ne conserve que les RPU dont le DP est renseigné) est sauvegardé sous le nom de __dpr2.Rda__.

Lecture du fichier des RPU 2015
```{}
load("../RPU_2014/rpu2015d0112_provisoire.Rda") # d15
# load("~/Documents/RESURAL/Trame_Commune/horaires_pds.Rda") #h.pds

# On ne garde que les RPU avec un DP
dpr2 <- d15[!is.na(d15$DP), ]
```

supression des caractères anormaux
```{}
Encoding(dpr2$DP) <- "latin1"
Encoding(dpr2$MOTIF) <- "latin1"
```

suppression des points décimaux
```{}
dpr2$DP <- gsub(".", "", dpr2$DP, fixed=TRUE)
```

suppression des minuscules
```{}
dpr2$DP <- toupper(dpr2$DP)
```

Sauvegarde du fichier dpr2
```{}
save(dpr2, file = "Regroupement_ORUMIP/dpr2.Rda")

save(dpr2, file = "dpr2.Rda")
```

Merging des 2 fichiers
-----------------------
Le fichier résultant est sauvegardé sous le nom de __merge2015.Rda__.

on réalise un merging des deux fichiers sur la base du code CIM 10
```{}
merge2015 <- merge(dpr2, orumip, by.x = "DP", by.y = "CIM10", all.x = TRUE)

# sauvegarde obsolète
save(merge2015, file = "Regroupement_ORUMIP/merge2015.Rda") # merge2015

# sauvegarde
save(merge2015, file = "merge2015.Rda") # merge2015
```

Analyse rapide
--------------
On utilise le fichier __merge2015.Rda__ créé à l'étape précédente, résultant du croisement des RPU 2015 (au 5 novembre 2015) et des code de regroupement ORUMIP. Les codes CIM10 sont dans la colonne DP.


```r
load("../Regroupement_ORUMIP/merge2015.Rda")
head(merge2015)
```

```
##     DP                                   id CODE_POSTAL          COMMUNE
## 1 A010 c3d2c959-12c4-49e3-85ed-ac9e1e579e32       67201      ECKBOLSHEIM
## 2 A020 d0301a1e-b304-4385-a10c-0f901ea5e782       67650 DAMBACH LA VILLE
## 3 A020 3a4b38c2-3c4c-4427-b6be-1bc1b1282e2f       68590       RORSCHWIHR
## 4 A020 00857fa2-3a37-4ea0-ae62-a4b372e392a3       67350             <NA>
## 5 A020 0b7786ab-a9e0-43f0-8bb2-d9d5afcb23b7       67500         HAGUENAU
## 6 A020 c233649e-09af-4e11-8846-f01fd7f34b24       67230        HERBSHEIM
##   DESTINATION              ENTREE    EXTRACT FINESS GRAVITE MODE_ENTREE
## 1        <NA> 2015-01-05 13:11:00 2015-01-06    NHC       2    Domicile
## 2        <NA> 2015-07-10 12:41:00      16627    Sel       2    Domicile
## 3        <NA> 2015-04-28 22:47:00 2015-04-29    Sel       2    Domicile
## 4         MCO 2015-08-12 05:50:00 2015-08-13    Hag       2    Domicile
## 5        <NA> 2015-02-28 14:10:00 2015-03-01    Hag       2    Domicile
## 6        <NA> 2015-10-23 21:09:00 2015-10-24    Sel       2    Domicile
##   MODE_SORTIE MOTIF           NAISSANCE ORIENTATION PROVENANCE SEXE
## 1        <NA>  R509 1983-04-08 00:00:00        <NA>       <NA>    F
## 2    Domicile A09.9 1990-05-18 00:00:00        <NA>        PEA    F
## 3    Domicile   Z04 1966-01-16 00:00:00        <NA>        PEA    F
## 4    Mutation  A090 2014-06-23 00:00:00        UHCD       <NA>    F
## 5    Domicile  A090 2014-09-12 00:00:00        <NA>       <NA>    M
## 6    Domicile R10.4 1987-05-11 00:00:00        <NA>        PEA    F
##                SORTIE TRANSPORT TRANSPORT_PEC AGE         LIBELLE_CIM10
## 1 2015-01-05 19:46:00      <NA>          <NA>  31       Fièvre typhoïde
## 2 2015-07-10 16:43:00     PERSO         AUCUN  25 Entérite à Salmonella
## 3 2015-04-28 23:52:00     PERSO         AUCUN  49 Entérite à Salmonella
## 4 2015-08-12 06:30:00      <NA>         AUCUN   1 Entérite à Salmonella
## 5 2015-03-01 14:10:00      <NA>         AUCUN   0 Entérite à Salmonella
## 6 2015-10-24 00:45:00     PERSO         AUCUN  28 Entérite à Salmonella
##   SFMU      TYPE_URGENCES                                     CHAPITRE
## 1  OUI Médico-chirurgical Douleurs abdominales, pathologies digestives
## 2  non Médico-chirurgical Douleurs abdominales, pathologies digestives
## 3  non Médico-chirurgical Douleurs abdominales, pathologies digestives
## 4  non Médico-chirurgical Douleurs abdominales, pathologies digestives
## 5  non Médico-chirurgical Douleurs abdominales, pathologies digestives
## 6  non Médico-chirurgical Douleurs abdominales, pathologies digestives
##                 SOUS_CHAPITRE
## 1 Diarrhée et gastro-entérite
## 2 Diarrhée et gastro-entérite
## 3 Diarrhée et gastro-entérite
## 4 Diarrhée et gastro-entérite
## 5 Diarrhée et gastro-entérite
## 6 Diarrhée et gastro-entérite
```

```r
table(merge2015$TYPE_URGENCE)
```

```
## 
##      Autre recours Médico-chirurgical      Psychiatrique 
##               8145             147819               5677 
##      Toxicologique    Traumatologique 
##               4180              99558
```

```r
table(merge2015$CHAPITRE)
```

```
## 
##                                      autre et sans précision 
##                                                          268 
##                Céphalées, pathologies neurologiques hors SNP 
##                                                        10302 
##            Demande de certificats, de dépistage, de conseils 
##                                                         3053 
##          Dermato-allergologie et atteintes cutanéo-muqueuses 
##                                                        10464 
##                Difficultés psychosociales, socio-économiques 
##                                                          514 
##                 Douleurs abdominales, pathologies digestives 
##                                                        27580 
##            Douleurs de membre, rhumatologie, orthopédie, SNP 
##                                                        19834 
##               Douleurs pelviennes, pathologies uro-génitales 
##                                                        11930 
##         Douleurs thoraciques, pathologies cardio-vasculaires 
##                                                        10858 
##        Dyspnées, pathologies des voies aériennes inférieures 
##                                                        11820 
##                             Fièvre et infectiologie générale 
##                                                         5702 
##             Iatrogénie et complication post chirurgicale SAI 
##                                                         1731 
##                                      Intoxication alcoolique 
##                                                         2308 
##                          Intoxication au monoxyde de carbone 
##                                                           80 
##                                  Intoxication médicamenteuse 
##                                                         1425 
##                         Intoxication par d'autres substances 
##                                                          367 
## Malaises, lipothymies, syncopes, étourdissements et vertiges 
##                                                         7632 
##            ORL, ophtalmo, stomato et carrefour aéro-digestif 
##                                                        20334 
##      Recours lié à l'organisation de la continuité des soins 
##                                                          409 
##                      Réorientations, fugues,  refus de soins 
##                                                         1277 
##                        Signes généraux et autres pathologies 
##                                                        11363 
##                Soins de contrôle, surveillances et entretien 
##                                                          893 
##                          Traumatisme autre et sans précision 
##                                                         6254 
##                             Traumatisme de la tête et du cou 
##                                                        22271 
##                              Traumatisme du membre inférieur 
##                                                        29599 
##                              Traumatisme du membre supérieur 
##                                                        35340 
##                         Traumatisme thoraco-abdomino-pelvien 
##                                                         6094 
##            Troubles du psychisme, pathologies psychiatriques 
##                                                         5677
```

```r
table(merge2015$SOUS_CHAPITRE)
```

```
## 
##                                                                                - 
##                                                                            12325 
##                                                    Abcès, phlegmons, furoncles,… 
##                                                                             3249 
##                                        AEG, asthénie, syndrôme de glissement, .. 
##                                                                             2166 
##                            Agitation, trouble de personnalité et du comportement 
##                                                                             1611 
##                                    Anémie, aplasie, autre atteinte hématologique 
##                                                                             1440 
##                                    Angines, amygdalites, rhino-pharyngites, toux 
##                                                                             7768 
##                              Angoisse, stress, trouble névrotique ou somatoforme 
##                                                                             2287 
##                                           Angor et autre cardiopathie ischémique 
##                                                                              509 
##                                   Appendicite et autre pathologie appendiculaire 
##                                                                              756 
##                                                                  Arrêt cardiaque 
##                                                                              100 
##                                          Arthralgie, arthrites, tendinites,  ... 
##                                                                             5128 
##                                                   Ascite, ictère et hépatopathie 
##                                                                              571 
##                                                                           Asthme 
##                                                                             1776 
##                                                      Atteintes de nerfs crâniens 
##                                                                              301 
##                                                   autre affection dermatologique 
##                                                                             1019 
##                                                     autre affection uro-génitale 
##                                                                              291 
##                                   autre atteinte des voies aériennes inférieures 
##                                                                              149 
##                                     autre atteinte des voies aéro-digestives sup 
##                                                                               90 
##                                       autre rhumato et syst nerveux périphérique 
##                                                                             1195 
##                                  autres infectiologie générale et sans précision 
##                                                                             1367 
##                                                  autres patho cardio-vasculaires 
##                                                                              442 
##                                    autres pathologies digestives et alimentaires 
##                                                                             1511 
##                                            autres pathologies et signes généraux 
##                                                                             1640 
##                                                      autres recours obstétricaux 
##                                                                              155 
##                                     AVC, AIT, hémiplégie et syndrômes apparentés 
##                                                                             2562 
##                                      BPCO et insuffisance respiratoire chronique 
##                                                                              951 
##                                                  Bronchite aiguë et bronchiolite 
##                                                                             2069 
##                               Cervicalgie, névralgie et autre atteinte cervicale 
##                                                                             1057 
##                                                         Choc cardio-circulatoire 
##                                                                              299 
##                                         Colique néphrétique et lithiase urinaire 
##                                                                             2837 
##                        Comas, tumeurs, encéphalopathies et autre atteinte du SNC 
##                                                                              586 
##                             Constipation et autre trouble fonctionnel intestinal 
##                                                                             3561 
##               Contusions et lésions superf cutanéo-muqueuses (hors plaies et CE) 
##                                                                            26065 
##                                               Dépression et troubles de l'humeur 
##                                                                              906 
##                                             Dermite atopique, de contact, prurit 
##                                                                              738 
##                                  Déshydratation et trouble hydro-électrolytiques 
##                                                                             1024 
##                                             Désorientation et troubles cognitifs 
##                                                                              628 
##                                               Diabète et troubles de la glycémie 
##                                                                              979 
##                                                      Diarrhée et gastro-entérite 
##                                                                             5815 
##                                                              Dissection aortique 
##                                                                               34 
##                                      Dorsalgie et pathologie rachidienne dorsale 
##                                                                             1065 
##                                                Douleur abdominale sans précision 
##                                                                             7922 
##                                     Douleur de membre, contracture, myalgie, ... 
##                                                                             5031 
##                                                   Douleur dentaire, stomatologie 
##                                                                             1508 
##                                 Douleur oculaire, conjonctivites, autre ophtalmo 
##                                                                             5261 
##                                                                Douleur pelvienne 
##                                                                              198 
##                                   Douleur précordiale ou thoracique non élucidée 
##                                                                             3975 
##                    Douleurs aiguës et chroniques non précisées, soins palliatifs 
##                                                                             4114 
##                                         Douleur testiculaire et autre andrologie 
##                                                                              777 
##                                                     Douleur thoracique pariétale 
##                                                                             1614 
##                                                     Dyspnée et gène respiratoire 
##                                                                             1487 
##                                                               Embolie pulmonaire 
##                                                                              470 
##                                                  Entorses et luxations de membre 
##                                                                            15478 
##                                   Entorses, fractures et lésions costo-sternales 
##                                                                              859 
##                          Entorses, luxations et fractures du rachis ou du bassin 
##                                                                             1420 
##                                                         Epilepsie et convulsions 
##                                                                             2141 
##                                                                        Epistaxis 
##                                                                             1259 
##                                                                        Érysipèle 
##                                                                              920 
##                                                     Erythème et autres éruptions 
##                                                                              830 
##                                                                           Fièvre 
##                                                                             2297 
##                                                              Fractures de membre 
##                                                                            16509 
##                                  Fractures OPN, dents et lésions de la mâchoire  
##                                                                              857 
##                                Gastrite, Ulcère Gastro-duodénal non hémorragique 
##                                                                             1290 
##                                      GEU, fausse couche, hémorragie obstétricale 
##                                                                              153 
##                                                                           Grippe 
##                                                                             1215 
##                                                                        Hématurie 
##                                                                              488 
##                                                                       Hémoptysie 
##                                                                              156 
##                                  Hémorragie digestive sans mention de péritonite 
##                                                                              488 
##                                                    HTA et poussées tensionnelles 
##                                                                              607 
##                                      Hypotension artérielle sans mention de choc 
##                                                                              195 
##                                                            Infarctus du myocarde 
##                                                                              392 
##                                                    Infection des voies urinaires 
##                                                                             4182 
##                                                           Insuffisance cardiaque 
##                                                                             1831 
##                                                              Insuffisance rénale 
##                                                                              513 
##                                                  Insuffisance respiratoire aiguë 
##                                                                              632 
##                                  Laryngite, trachéite et autre atteinte laryngée 
##                                                                             1037 
## Lésion prof des tissus (tendons, vx, nerfs,..) ou d'organes internes  (hors TC)  
##                                                                             1852 
##                                                 Lésions de l'oeil ou de l'orbite 
##                                                                             1909 
##                                      Lésions traumatique autre et sans précision 
##                                                                             5270 
##                        Lithiase, infection et autre atteinte des voies biliaires 
##                                                                             1168 
##                                      Lombalgie, lombo-sciatique, rachis lombaire 
##                                                                             4744 
##                                               Malaises sans PC ou sans précision 
##                                                                             4562 
##                          Méningisme, méningite, encéphalite et infections du SNC 
##                                                                              146 
##                                  Méno - métrorragie et autre hémorragie génitale 
##                                                                              118 
##                                                            Migraine et céphalées 
##                                                                             2922 
##                               Mycoses, parasitoses et autres infections cutanées 
##                                                                              285 
##                                                            Nausées, vomissements 
##                                                                             1266 
##                                                          Occlusion toute origine 
##                                                                              738 
##                                                  Oedeme et tuméfaction localisés 
##                                                                              560 
##                                         Oesophagite et reflux gastro-oesophagien 
##                                                                              535 
##                                 Otalgie, otites et autre pathologies otologiques 
##                                                                             3005 
##                                  Pancréatite aiguë et autre atteinte du pancréas 
##                                                                              474 
##                                                                      Péricardite 
##                                                                              133 
##                                                         Péritonite toute origine 
##                                                                              206 
##                                                            Phlébite périphérique 
##                                                                              448 
##                                            Piqûres d'arthropode, d'insectes, ... 
##                                                                              568 
##                                        Plaies et corps étrangers cutanéo-muqueux 
##                                                                            22576 
##                                                 Pleurésie et épanchement pleural 
##                                                                              216 
##                                                                     Pneumopathie 
##                                                                             3691 
##                                                     Pneumothorax non traumatique 
##                                                                              223 
##                                                                      Proctologie 
##                                                                             1279 
##                                                    Prostatite, orchi-épididymite 
##                                                                              558 
##                                         Rétention urinaire, pb de sonde, dysurie 
##                                                                             1061 
##                                            Schizophrénie, délire, hallucinations 
##                                                                              873 
##                                                            Septicémies et sepsis 
##                                                                              366 
##                                                   Sinusites aiguës et chroniques 
##                                                                              406 
##                                  Sujet en contact avec une maladie transmissible 
##                                                                              457 
##                                        Syncopes, lipothymies et malaises avec PC 
##                                                                              602 
##                                                Thrombose artérielle périphérique 
##                                                                              163 
##                                                            Traumatismes crâniens 
##                                                                             6763 
##                                            Trouble du rythme et de la conduction 
##                                                                             1730 
##                                   Troubles sensitifs, moteurs et toniques autres 
##                                                                             1016 
##                                                                        Urticaire 
##                                                                             1463 
##                                             Vertiges et sensations vertigineuses 
##                                                                             2468 
##                                                        Viroses cutanéo-muqueuses 
##                                                                              832 
##                                Vulvo-vaginites, salpingites et autre gynécologie 
##                                                                              599
```

```r
# table des CODE_URGENCE par FINESS
t <- tapply(merge2015$TYPE_URGENCE, list(merge2015$FINESS, merge2015$TYPE_URGENCE), length)
t
```

```
##     Autre recours Médico-chirurgical Psychiatrique Toxicologique
## 3Fr           514               4684           152            68
## Alk           163               1134            49            16
## Ane            NA                 NA            NA            NA
## Col          2243              25717          1367           915
## Dia           489               5923           109             3
## Dts            NA               1618            NA            NA
## Geb           530               6062           122           111
## Hag           738              17936           461           468
## Hus            NA                 NA            NA            NA
## Mul          1056              18671          1416           696
## Odi            97               6833            55             2
## Ros            NA                 NA            NA            NA
## Sav           149               2640           133            76
## Sel           785              11274           242           355
## Wis           409               5398           207            94
## HTP           450              22884           506           493
## NHC           138              10008           268           564
## Emr           324               4812           565           286
## Hsr            60               2225            25            33
## Ccm            NA                 NA            NA            NA
##     Traumatologique
## 3Fr            3525
## Alk            1315
## Ane              NA
## Col           19205
## Dia            4012
## Dts            6080
## Geb            6659
## Hag           10948
## Hus              NA
## Mul            7819
## Odi            3048
## Ros             502
## Sav            2724
## Sel           10863
## Wis            3901
## HTP           15133
## NHC             602
## Emr            3215
## Hsr               7
## Ccm              NA
```

```r
# somme d'une ligne et % de cas par FINESS
b <- apply(t, 1, sum, na.rm = TRUE)
round(t*100/b, 2)
```

```
##     Autre recours Médico-chirurgical Psychiatrique Toxicologique
## 3Fr          5.75                 52          1.70          0.76
## Alk          6.09                 42          1.83          0.60
## Ane            NA                 NA            NA            NA
## Col          4.54                 52          2.76          1.85
## Dia          4.64                 56          1.03          0.03
## Dts            NA                 21            NA            NA
## Geb          3.93                 45          0.90          0.82
## Hag          2.42                 59          1.51          1.53
## Hus            NA                 NA            NA            NA
## Mul          3.56                 63          4.77          2.35
## Odi          0.97                 68          0.55          0.02
## Ros            NA                 NA            NA            NA
## Sav          2.60                 46          2.32          1.33
## Sel          3.34                 48          1.03          1.51
## Wis          4.09                 54          2.07          0.94
## HTP          1.14                 58          1.28          1.25
## NHC          1.19                 86          2.31          4.87
## Emr          3.52                 52          6.14          3.11
## Hsr          2.55                 95          1.06          1.40
## Ccm            NA                 NA            NA            NA
##     Traumatologique
## 3Fr            39.4
## Alk            49.1
## Ane              NA
## Col            38.8
## Dia            38.1
## Dts            79.0
## Geb            49.4
## Hag            35.8
## Hus              NA
## Mul            26.4
## Odi            30.4
## Ros           100.0
## Sav            47.6
## Sel            46.2
## Wis            39.0
## HTP            38.3
## NHC             5.2
## Emr            34.9
## Hsr             0.3
## Ccm              NA
```

```r
# total par colonne et pourcentage
a <- apply(t, 2, sum, na.rm = TRUE) # somme des colonnes
a
```

```
##      Autre recours Médico-chirurgical      Psychiatrique 
##               8145             147819               5677 
##      Toxicologique    Traumatologique 
##               4180              99558
```

```r
round(a * 100/sum(a), 2)
```

```
##      Autre recours Médico-chirurgical      Psychiatrique 
##                3.1               55.7                2.1 
##      Toxicologique    Traumatologique 
##                1.6               37.5
```

```r
# manipulation d'une ligne
t['NHC',]
```

```
##      Autre recours Médico-chirurgical      Psychiatrique 
##                138              10008                268 
##      Toxicologique    Traumatologique 
##                564                602
```

```r
sum(t['NHC',])
```

```
## [1] 11580
```

```r
t['NHC',] / sum(t['NHC',])
```

```
##      Autre recours Médico-chirurgical      Psychiatrique 
##              0.012              0.864              0.023 
##      Toxicologique    Traumatologique 
##              0.049              0.052
```

```r
round(t['NHC',]*100 / sum(t['NHC',]), 2)
```

```
##      Autre recours Médico-chirurgical      Psychiatrique 
##                1.2               86.4                2.3 
##      Toxicologique    Traumatologique 
##                4.9                5.2
```

```r
# table des CODE_DISCIPLINE par FINESS
t <- tapply(merge2015$CHAPITRE, list(merge2015$FINESS, merge2015$CHAPITRE), length)
```

Codes non reconnus
------------------

De nombreux codes ne sont pas reconnus par le fichier de regroupement. Il faut donc les remplacer par des codes de substitutions reconnus par le fichier de regroupement (orumip). Le nombre de codes de sustitution étant important, il est plus facile de les regrouper dans le fichier __codes_remplacement.csv__ qui peut être mis à jour régulièrement à partir du fichier __codes_remplacement.ods__.

NB: certains codes restent inexploitables car sans correspondance dans le thésaurus. Par exemple W199 correspond aux chutes sans précisions. D'une manière générale, les codes commençant par U, V, W, X, Y n'ont pas de correspondance. La version 8 du cahier des charges de l'InVS recommande d'appliquer la méthodologie PMSI, c'est à dire de ne pas utiliser les codes qui sont interdits en diagnostic principal. Par exemple le code R53 (malaise et fatigue) n'est pas un DP. Il faut utiliser R53.0 (Altération de l'état général) ou R53.1 (malaise) ou R53.2 (fatigue) qui sont reconnus comme DP.


```r
library(epicalc)
```

```
## Loading required package: foreign
## Loading required package: survival
## Loading required package: MASS
## Loading required package: nnet
```

```r
tab1(merge2015$LIBELLE_CIM10, graph = FALSE)
```

```
## Warning in cbind(output0, round(percent0, decimal), c(round(percent1,
## decimal), : number of rows of result is not a multiple of vector length
## (arg 3)
```

```
## merge2015$LIBELLE_CIM10 : 
##                                                                                        Frequency
## Douleurs abdominales, autres et non précisées                                               6984
## Entorse et foulure de la cheville                                                           6670
## Plaie ouverte de(s) doigt(s) (sans lésion de l'ongle)                                       4038
## Douleur thoracique, sans précision                                                          3815
## Malaise                                                                                     3491
## Rhinopharyngite (aiguë) [rhume banal]                                                       3390
## Contusion d'autres parties du poignet et de la main                                         3082
## Constipation                                                                                3080
## Commotion cérébrale, sans plaie intracrânienne                                              2701
## Colique néphrétique, sans précision                                                         2648
## Douleur au niveau d'un membre                                                               2591
## Commotion cérébrale                                                                         2566
## Contusion du genou                                                                          2448
## Plaie ouverte d'autres parties de la tête                                                   2313
## Contusion de parties autres et non précisées du pied                                        2276
## Entorse et foulure de doigt(s)                                                              2266
## Douleur aiguë                                                                               2117
## Contusion de(s) doigt(s) sans lésion de l'ongle                                             2023
## Gastroentérites et colites d’origine infectieuse, autres et non précisées                   1935
## Douleur, sans précision                                                                     1873
## Plaie ouverte du poignet et de la main, partie non précisée                                 1781
## Pneumopathie, sans précision                                                                1691
## Céphalée                                                                                    1673
## Plaie ouverte du cuir chevelu                                                               1659
## Fièvre, sans précision                                                                      1629
## Autres gastroentérites et colites d'origine infectieuse et non précisée                     1606
## Autres douleurs thoraciques                                                                 1575
## Contusion de l'épaule et du bras                                                            1574
## Lombalgie basse                                                                             1526
## Troubles mentaux et du comportement liés à l'utilisation d'alcool : intoxication aiguë      1492
## Contusion du coude                                                                          1351
## Contusion du thorax                                                                         1340
## Entorse et foulure de parties autres et non précisées du genou                              1274
## Épistaxis                                                                                   1259
## Nausées et vomissements                                                                     1200
## Allergie, sans précision                                                                    1199
## Fracture fermée de l'extrémité inférieure du radius                                         1117
## Dyspnée                                                                                     1104
## Contusion d'un (des) orteil(s) (sans lésion de l'ongle)                                     1092
## Insuffisance cardiaque, sans précision                                                      1083
## Entorse et foulure du poignet                                                               1080
## Plaie ouverte de la tête, partie non précisée                                               1039
## Sujet inquiet de son état de santé (sans diagnostic)                                        1030
## Asthme, sans précision                                                                      1027
## Altération [baisse] de l'état général                                                       1010
## Néphrite tubulo-interstitielle aiguë                                                        1006
## Acte non effectué par décision du sujet pour des raisons autres et non précisées             956
## Plaie ouverte de la lèvre et de la cavité buccale                                            945
## Contusion de la cheville                                                                     940
## Érysipèle                                                                                    920
## Infection des voies urinaires, siège non précisé                                             914
## Délivrance d'un certificat médical                                                           894
## Malaise et fatigue                                                                           882
## Gastrite, sans précision                                                                     862
## Fracture fermée du col du fémur                                                              857
## Entorse et foulure des ligaments latéraux du genou (interne) (externe)                       856
## Bronchite aiguë, sans précision                                                              846
## Autres examens à des fins administratives                                                    839
## Laryngite (aiguë)                                                                            836
## Contusion des lombes et du bassin                                                            830
## Commotion cérébrale, avec plaie intracrânienne                                               817
## Lésion traumatique, sans précision                                                           812
## Abcès cutané, furoncle et anthrax, sans précision                                            811
## Chutes à répétition, non classées ailleurs                                                   811
## Fracture de l'extrémité inférieure du radius                                                 811
## Étourdissements et éblouissements                                                            803
## Fracture fermée de parties autres et non précisées du poignet et de la main                  794
## Plaie ouverte de la paupière et de la région péri-oculaire                                   784
## Gastroentérites et colites d’origine non précisée                                            779
## Infarctus cérébral, sans précision                                                           779
## Épilepsie, sans précision                                                                    771
## Pharyngite (aiguë), sans précision                                                           742
## Contusion de la hanche                                                                       734
## Contusion de parties autres et non précisées de la jambe                                     722
## Rétention d'urine                                                                            721
## Cystite, sans précision                                                                      718
## Plaie ouverte d'autres parties du pied                                                       717
## Corps étranger dans la cornée                                                                700
## Entorse et foulure de parties autres et non précisées du pied                                697
## Fracture fermée d'un autre doigt                                                             686
## Amygdalite (aiguë), sans précision                                                           671
## Chute, sans précision, lieu sans précision                                                   663
## Cystite aiguë                                                                                640
## Épisode dépressif, sans précision                                                            635
## Trouble panique [anxiété épisodique paroxystique]                                            634
## Conjonctivite aiguë, sans précision                                                          633
## Otite moyenne, sans précision                                                                630
## Lésion traumatique superficielle de la tête, partie non précisée                             629
## Entorse et foulure du rachis cervical                                                        626
## Plaie ouverte d'autres parties du poignet et de la main                                      612
## Urticaire, sans précision                                                                    611
## Pneumopathie bactérienne, sans précision                                                     610
## Myalgie                                                                                      606
## Plaie ouverte de la tête                                                                     606
## Syncope et collapsus (sauf choc)                                                             602
## Rash et autres éruptions cutanées non spécifiques                                            598
## Lombalgie basse - Région lombaire                                                            597
## Luxation de l'articulation de l'épaule                                                       589
## (Other)                                                                                   129877
## NA's                                                                                         296
##   Total                                                                                   265675
##                                                                                          %(NA+)
## Douleurs abdominales, autres et non précisées                                               2.6
## Entorse et foulure de la cheville                                                           2.5
## Plaie ouverte de(s) doigt(s) (sans lésion de l'ongle)                                       1.5
## Douleur thoracique, sans précision                                                          1.4
## Malaise                                                                                     1.3
## Rhinopharyngite (aiguë) [rhume banal]                                                       1.3
## Contusion d'autres parties du poignet et de la main                                         1.2
## Constipation                                                                                1.2
## Commotion cérébrale, sans plaie intracrânienne                                              1.0
## Colique néphrétique, sans précision                                                         1.0
## Douleur au niveau d'un membre                                                               1.0
## Commotion cérébrale                                                                         1.0
## Contusion du genou                                                                          0.9
## Plaie ouverte d'autres parties de la tête                                                   0.9
## Contusion de parties autres et non précisées du pied                                        0.9
## Entorse et foulure de doigt(s)                                                              0.9
## Douleur aiguë                                                                               0.8
## Contusion de(s) doigt(s) sans lésion de l'ongle                                             0.8
## Gastroentérites et colites d’origine infectieuse, autres et non précisées                   0.7
## Douleur, sans précision                                                                     0.7
## Plaie ouverte du poignet et de la main, partie non précisée                                 0.7
## Pneumopathie, sans précision                                                                0.6
## Céphalée                                                                                    0.6
## Plaie ouverte du cuir chevelu                                                               0.6
## Fièvre, sans précision                                                                      0.6
## Autres gastroentérites et colites d'origine infectieuse et non précisée                     0.6
## Autres douleurs thoraciques                                                                 0.6
## Contusion de l'épaule et du bras                                                            0.6
## Lombalgie basse                                                                             0.6
## Troubles mentaux et du comportement liés à l'utilisation d'alcool : intoxication aiguë      0.6
## Contusion du coude                                                                          0.5
## Contusion du thorax                                                                         0.5
## Entorse et foulure de parties autres et non précisées du genou                              0.5
## Épistaxis                                                                                   0.5
## Nausées et vomissements                                                                     0.5
## Allergie, sans précision                                                                    0.5
## Fracture fermée de l'extrémité inférieure du radius                                         0.4
## Dyspnée                                                                                     0.4
## Contusion d'un (des) orteil(s) (sans lésion de l'ongle)                                     0.4
## Insuffisance cardiaque, sans précision                                                      0.4
## Entorse et foulure du poignet                                                               0.4
## Plaie ouverte de la tête, partie non précisée                                               0.4
## Sujet inquiet de son état de santé (sans diagnostic)                                        0.4
## Asthme, sans précision                                                                      0.4
## Altération [baisse] de l'état général                                                       0.4
## Néphrite tubulo-interstitielle aiguë                                                        0.4
## Acte non effectué par décision du sujet pour des raisons autres et non précisées            0.4
## Plaie ouverte de la lèvre et de la cavité buccale                                           0.4
## Contusion de la cheville                                                                    0.4
## Érysipèle                                                                                   0.3
## Infection des voies urinaires, siège non précisé                                            0.3
## Délivrance d'un certificat médical                                                          0.3
## Malaise et fatigue                                                                          0.3
## Gastrite, sans précision                                                                    0.3
## Fracture fermée du col du fémur                                                             0.3
## Entorse et foulure des ligaments latéraux du genou (interne) (externe)                      0.3
## Bronchite aiguë, sans précision                                                             0.3
## Autres examens à des fins administratives                                                   0.3
## Laryngite (aiguë)                                                                           0.3
## Contusion des lombes et du bassin                                                           0.3
## Commotion cérébrale, avec plaie intracrânienne                                              0.3
## Lésion traumatique, sans précision                                                          0.3
## Abcès cutané, furoncle et anthrax, sans précision                                           0.3
## Chutes à répétition, non classées ailleurs                                                  0.3
## Fracture de l'extrémité inférieure du radius                                                0.3
## Étourdissements et éblouissements                                                           0.3
## Fracture fermée de parties autres et non précisées du poignet et de la main                 0.3
## Plaie ouverte de la paupière et de la région péri-oculaire                                  0.3
## Gastroentérites et colites d’origine non précisée                                           0.3
## Infarctus cérébral, sans précision                                                          0.3
## Épilepsie, sans précision                                                                   0.3
## Pharyngite (aiguë), sans précision                                                          0.3
## Contusion de la hanche                                                                      0.3
## Contusion de parties autres et non précisées de la jambe                                    0.3
## Rétention d'urine                                                                           0.3
## Cystite, sans précision                                                                     0.3
## Plaie ouverte d'autres parties du pied                                                      0.3
## Corps étranger dans la cornée                                                               0.3
## Entorse et foulure de parties autres et non précisées du pied                               0.3
## Fracture fermée d'un autre doigt                                                            0.3
## Amygdalite (aiguë), sans précision                                                          0.3
## Chute, sans précision, lieu sans précision                                                  0.2
## Cystite aiguë                                                                               0.2
## Épisode dépressif, sans précision                                                           0.2
## Trouble panique [anxiété épisodique paroxystique]                                           0.2
## Conjonctivite aiguë, sans précision                                                         0.2
## Otite moyenne, sans précision                                                               0.2
## Lésion traumatique superficielle de la tête, partie non précisée                            0.2
## Entorse et foulure du rachis cervical                                                       0.2
## Plaie ouverte d'autres parties du poignet et de la main                                     0.2
## Urticaire, sans précision                                                                   0.2
## Pneumopathie bactérienne, sans précision                                                    0.2
## Myalgie                                                                                     0.2
## Plaie ouverte de la tête                                                                    0.2
## Syncope et collapsus (sauf choc)                                                            0.2
## Rash et autres éruptions cutanées non spécifiques                                           0.2
## Lombalgie basse - Région lombaire                                                           0.2
## Luxation de l'articulation de l'épaule                                                      0.2
## (Other)                                                                                    48.9
## NA's                                                                                        0.1
##   Total                                                                                   100.0
##                                                                                          %(NA-)
## Douleurs abdominales, autres et non précisées                                               0.0
## Entorse et foulure de la cheville                                                           0.0
## Plaie ouverte de(s) doigt(s) (sans lésion de l'ongle)                                       0.0
## Douleur thoracique, sans précision                                                          0.0
## Malaise                                                                                     0.0
## Rhinopharyngite (aiguë) [rhume banal]                                                       0.0
## Contusion d'autres parties du poignet et de la main                                         0.0
## Constipation                                                                                0.0
## Commotion cérébrale, sans plaie intracrânienne                                              0.0
## Colique néphrétique, sans précision                                                         0.0
## Douleur au niveau d'un membre                                                               0.2
## Commotion cérébrale                                                                         0.0
## Contusion du genou                                                                          0.3
## Plaie ouverte d'autres parties de la tête                                                   0.0
## Contusion de parties autres et non précisées du pied                                        0.0
## Entorse et foulure de doigt(s)                                                              0.0
## Douleur aiguë                                                                               0.0
## Contusion de(s) doigt(s) sans lésion de l'ongle                                             0.0
## Gastroentérites et colites d’origine infectieuse, autres et non précisées                   0.0
## Douleur, sans précision                                                                     0.0
## Plaie ouverte du poignet et de la main, partie non précisée                                 0.0
## Pneumopathie, sans précision                                                                0.0
## Céphalée                                                                                    0.0
## Plaie ouverte du cuir chevelu                                                               0.0
## Fièvre, sans précision                                                                      0.0
## Autres gastroentérites et colites d'origine infectieuse et non précisée                     0.0
## Autres douleurs thoraciques                                                                 0.0
## Contusion de l'épaule et du bras                                                            0.0
## Lombalgie basse                                                                             0.0
## Troubles mentaux et du comportement liés à l'utilisation d'alcool : intoxication aiguë      0.0
## Contusion du coude                                                                          0.0
## Contusion du thorax                                                                         0.0
## Entorse et foulure de parties autres et non précisées du genou                              0.0
## Épistaxis                                                                                   0.0
## Nausées et vomissements                                                                     0.0
## Allergie, sans précision                                                                    0.0
## Fracture fermée de l'extrémité inférieure du radius                                         0.0
## Dyspnée                                                                                     0.0
## Contusion d'un (des) orteil(s) (sans lésion de l'ongle)                                     0.0
## Insuffisance cardiaque, sans précision                                                      0.0
## Entorse et foulure du poignet                                                               0.0
## Plaie ouverte de la tête, partie non précisée                                               0.0
## Sujet inquiet de son état de santé (sans diagnostic)                                        0.0
## Asthme, sans précision                                                                      0.0
## Altération [baisse] de l'état général                                                       0.0
## Néphrite tubulo-interstitielle aiguë                                                        0.0
## Acte non effectué par décision du sujet pour des raisons autres et non précisées            0.0
## Plaie ouverte de la lèvre et de la cavité buccale                                           0.0
## Contusion de la cheville                                                                    0.0
## Érysipèle                                                                                   0.0
## Infection des voies urinaires, siège non précisé                                            0.0
## Délivrance d'un certificat médical                                                          0.0
## Malaise et fatigue                                                                          0.0
## Gastrite, sans précision                                                                    0.0
## Fracture fermée du col du fémur                                                             0.0
## Entorse et foulure des ligaments latéraux du genou (interne) (externe)                      0.0
## Bronchite aiguë, sans précision                                                             0.0
## Autres examens à des fins administratives                                                   0.0
## Laryngite (aiguë)                                                                           0.0
## Contusion des lombes et du bassin                                                           0.0
## Commotion cérébrale, avec plaie intracrânienne                                              0.0
## Lésion traumatique, sans précision                                                          0.0
## Abcès cutané, furoncle et anthrax, sans précision                                           0.0
## Chutes à répétition, non classées ailleurs                                                  0.0
## Fracture de l'extrémité inférieure du radius                                                0.0
## Étourdissements et éblouissements                                                           0.0
## Fracture fermée de parties autres et non précisées du poignet et de la main                 0.0
## Plaie ouverte de la paupière et de la région péri-oculaire                                  0.0
## Gastroentérites et colites d’origine non précisée                                           0.0
## Infarctus cérébral, sans précision                                                          0.0
## Épilepsie, sans précision                                                                   0.0
## Pharyngite (aiguë), sans précision                                                          0.0
## Contusion de la hanche                                                                      0.0
## Contusion de parties autres et non précisées de la jambe                                    0.0
## Rétention d'urine                                                                           0.0
## Cystite, sans précision                                                                     0.0
## Plaie ouverte d'autres parties du pied                                                      0.0
## Corps étranger dans la cornée                                                               0.0
## Entorse et foulure de parties autres et non précisées du pied                               0.0
## Fracture fermée d'un autre doigt                                                            0.0
## Amygdalite (aiguë), sans précision                                                          0.0
## Chute, sans précision, lieu sans précision                                                  0.0
## Cystite aiguë                                                                               0.0
## Épisode dépressif, sans précision                                                           0.0
## Trouble panique [anxiété épisodique paroxystique]                                           0.0
## Conjonctivite aiguë, sans précision                                                         0.0
## Otite moyenne, sans précision                                                               0.0
## Lésion traumatique superficielle de la tête, partie non précisée                            0.0
## Entorse et foulure du rachis cervical                                                       0.0
## Plaie ouverte d'autres parties du poignet et de la main                                     0.0
## Urticaire, sans précision                                                                   0.0
## Pneumopathie bactérienne, sans précision                                                    0.0
## Myalgie                                                                                     0.0
## Plaie ouverte de la tête                                                                    0.0
## Syncope et collapsus (sauf choc)                                                            0.0
## Rash et autres éruptions cutanées non spécifiques                                           0.0
## Lombalgie basse - Région lombaire                                                           0.0
## Luxation de l'articulation de l'épaule                                                      0.0
## (Other)                                                                                     0.0
## NA's                                                                                        0.0
##   Total                                                                                   100.0
```

```r
a <- merge2015[is.na(merge2015$LIBELLE_CIM10),]
x <- cbind(summary(as.factor(a$DP)))
head(x)
```

```
##       [,1]
## I200+   11
## N23 0   10
## W5700    9
## W0689    6
## V4259    5
## W5701    5
```
Codes de remplacement
---------------------
- S060 commotion cérébrale (DP) -> S0600
- M796	Douleur au niveau d'un membre (DP) -> M7969
- R520  Douleur aiguë (DP) -> R529
- A09  Autres gastroentérites et colites d'origine infectieuse ou non précisée (non DP): -> A090
- M545  Lombalgie basse (DP) -> M5456
- F100  Troubles mentaux et du comportement liés à l'utilisation d'alcool : intoxication aiguë (F1000)
- S836  Entorse et foulure de parties autres et non précisées du genou -> S830
- Z028  Autres examens à des fins administratives -> Z022
- S525  Fracture de l'extrémité inférieure du radius	-> 5250
- T149  Lésion traumatique, sans précision -> T140
- R53  Malaise et fatigue <- R53+1 (malaises)
- H669  Otite moyenne, sans précision -> H660
- J039  Amygdalite , sans précision <- H605
- H103  Conjonctivite aiguë, sans précision -> H100
- W199  Chute, sans précision, lieu sans précision -> Pas de correspondance. N'est pas un DP
- M544  Lumbago avec sciatique -> M5446
- M791  Myalgie -> M7919
- J180  Bronchopneumopathie, sans précision	<- J189
- S626	Fracture d'un autre doigt -> 6260
- M542	Cervicalgie -> M5422

- M779   M7799
- M543   M5437
- T119   T220
- R002   R000
- S01    S010
- H609   H605
- J31    J310
- M5459  M5456
- R10    R100
- N12    N10
- T131   S910
- W570   T634
- V899   
- S623   S6230
- J038   J069
- H109   H100
- Y099   
- T159   T150
- J03    J00
- J21    J210

Les codes de remplacement sont stockés dans le fichier __Analyse-regroupements/codes_remplacement.csv__. Le fichier comporte 2 colonnes:

- les codes RPU
- les codes de remplacement compatibles avec le thésaurus de regroupment


Récupération du fichier des codes de substitution:

```r
# récupère le fichier des codes de substitution
# mode console: file <- "Analyse_regroupements/codes_remplacement.csv"
file <- "codes_remplacement.csv"
sub <- read.csv(file)
n <- nrow(sub)
sub$CODE_RPU <- as.character(sub$CODE_RPU)
sub$SUBSTITUTION <- as.character(sub$SUBSTITUTION)
```

Le fichier __dpr2__ doit être corrigé avant le merging

```r
# substitue les codes dans dpr2

load("../Regroupement_ORUMIP/dpr2.Rda")
load("../Regroupement_ORUMIP/orumip.Rda")

for(i in 1:n){
  dpr2$DP[dpr2$DP == sub$CODE_RPU[i]] <- sub$SUBSTITUTION[i]
  }

# merge avec le fichier de regroupement ORUMIP

merge2015 <- merge(dpr2, orumip, by.x = "DP", by.y = "CIM10", all.x = TRUE)

# controle
a <- merge2015$CODE_URGENCE
sum(is.na(a))
```

```
## Warning in is.na(a): is.na() appliqué à un objet de type 'NULL' qui n'est
## ni une liste, ni un vecteur
```

```
## [1] 0
```

```r
a <- merge2015$DP[is.na(merge2015$CODE_URGENCE)]
```

```
## Warning in is.na(merge2015$CODE_URGENCE): is.na() appliqué à un objet de
## type 'NULL' qui n'est ni une liste, ni un vecteur
```

```r
head(a)
```

```
## character(0)
```

```r
head(summary(as.factor(a)))
```

```
## integer(0)
```

```r
# sauve le fichier merge
save(merge2015, file = "../Regroupement_ORUMIP/merge2015.Rda") # merge2015
```

Longueur des codes CIM10

```r
a <- dpr2$DP
summary(as.factor(nchar(a)))
```

```
##      1      3      4      5      6      7      8     10     15     16 
##      1  29029 204201  31954    469     13      2      1      1      1 
##     18     19 
##      2      1
```

Codes anormaux

```r
a[which(nchar(a)==1)]
```

```
## [1] "Z"
```

```r
a[which(nchar(a)==7)]
```

```
##  [1] "S011 02" "S929 01" "G510 02" "S823 01" "S720 02" "S223 01" "S422 02"
##  [8] "S729 01" "S011 02" "K409 01" "S202 02" "S801 02" "S800 01"
```

```r
a[which(nchar(a)==8)]
```

```
## [1] "S2250+B6" "S2250+B6"
```

```r
a[which(nchar(a)==18)]
```

```
## [1] "MM199) ARTHROSE SP" "MM255) ARTHRALGIES"
```



Analyse
=======

d3.Rda devient merge2015 (+++)


```r
library(epicalc)
path <- "../" # path <- "" en mode console
load("../Regroupement_ORUMIP/merge2015.Rda") # d3 est le fichier mergé
source(paste0(path,"regroupement.R"))

# affichage des résultats
summary(merge2015$TYPE_URGENCES)
```

```
##      Autre recours Médico-chirurgical      Psychiatrique 
##               8145             147819               5677 
##      Toxicologique    Traumatologique               NA's 
##               4180              99558                296
```

```r
summary(merge2015$CHAPITRE)
```

```
##                                      autre et sans précision 
##                                                          268 
##                Céphalées, pathologies neurologiques hors SNP 
##                                                        10302 
##            Demande de certificats, de dépistage, de conseils 
##                                                         3053 
##          Dermato-allergologie et atteintes cutanéo-muqueuses 
##                                                        10464 
##                Difficultés psychosociales, socio-économiques 
##                                                          514 
##                 Douleurs abdominales, pathologies digestives 
##                                                        27580 
##            Douleurs de membre, rhumatologie, orthopédie, SNP 
##                                                        19834 
##               Douleurs pelviennes, pathologies uro-génitales 
##                                                        11930 
##         Douleurs thoraciques, pathologies cardio-vasculaires 
##                                                        10858 
##        Dyspnées, pathologies des voies aériennes inférieures 
##                                                        11820 
##                             Fièvre et infectiologie générale 
##                                                         5702 
##             Iatrogénie et complication post chirurgicale SAI 
##                                                         1731 
##                                      Intoxication alcoolique 
##                                                         2308 
##                          Intoxication au monoxyde de carbone 
##                                                           80 
##                                  Intoxication médicamenteuse 
##                                                         1425 
##                         Intoxication par d'autres substances 
##                                                          367 
## Malaises, lipothymies, syncopes, étourdissements et vertiges 
##                                                         7632 
##            ORL, ophtalmo, stomato et carrefour aéro-digestif 
##                                                        20334 
##      Recours lié à l'organisation de la continuité des soins 
##                                                          409 
##                      Réorientations, fugues,  refus de soins 
##                                                         1277 
##                        Signes généraux et autres pathologies 
##                                                        11363 
##                Soins de contrôle, surveillances et entretien 
##                                                          893 
##                          Traumatisme autre et sans précision 
##                                                         6254 
##                             Traumatisme de la tête et du cou 
##                                                        22271 
##                              Traumatisme du membre inférieur 
##                                                        29599 
##                              Traumatisme du membre supérieur 
##                                                        35340 
##                         Traumatisme thoraco-abdomino-pelvien 
##                                                         6094 
##            Troubles du psychisme, pathologies psychiatriques 
##                                                         5677 
##                                                         NA's 
##                                                          296
```

```r
summary(merge2015$SOUS_CHAPITRE)
```

```
##               Contusions et lésions superf cutanéo-muqueuses (hors plaies et CE) 
##                                                                            26065 
##                                        Plaies et corps étrangers cutanéo-muqueux 
##                                                                            22576 
##                                                              Fractures de membre 
##                                                                            16509 
##                                                  Entorses et luxations de membre 
##                                                                            15478 
##                                                                                - 
##                                                                            12325 
##                                                Douleur abdominale sans précision 
##                                                                             7922 
##                                    Angines, amygdalites, rhino-pharyngites, toux 
##                                                                             7768 
##                                                            Traumatismes crâniens 
##                                                                             6763 
##                                                      Diarrhée et gastro-entérite 
##                                                                             5815 
##                                      Lésions traumatique autre et sans précision 
##                                                                             5270 
##                                 Douleur oculaire, conjonctivites, autre ophtalmo 
##                                                                             5261 
##                                          Arthralgie, arthrites, tendinites,  ... 
##                                                                             5128 
##                                     Douleur de membre, contracture, myalgie, ... 
##                                                                             5031 
##                                      Lombalgie, lombo-sciatique, rachis lombaire 
##                                                                             4744 
##                                               Malaises sans PC ou sans précision 
##                                                                             4562 
##                                                    Infection des voies urinaires 
##                                                                             4182 
##                    Douleurs aiguës et chroniques non précisées, soins palliatifs 
##                                                                             4114 
##                                   Douleur précordiale ou thoracique non élucidée 
##                                                                             3975 
##                                                                     Pneumopathie 
##                                                                             3691 
##                             Constipation et autre trouble fonctionnel intestinal 
##                                                                             3561 
##                                                    Abcès, phlegmons, furoncles,… 
##                                                                             3249 
##                                 Otalgie, otites et autre pathologies otologiques 
##                                                                             3005 
##                                                            Migraine et céphalées 
##                                                                             2922 
##                                         Colique néphrétique et lithiase urinaire 
##                                                                             2837 
##                                     AVC, AIT, hémiplégie et syndrômes apparentés 
##                                                                             2562 
##                                             Vertiges et sensations vertigineuses 
##                                                                             2468 
##                                                                           Fièvre 
##                                                                             2297 
##                              Angoisse, stress, trouble névrotique ou somatoforme 
##                                                                             2287 
##                                        AEG, asthénie, syndrôme de glissement, .. 
##                                                                             2166 
##                                                         Epilepsie et convulsions 
##                                                                             2141 
##                                                  Bronchite aiguë et bronchiolite 
##                                                                             2069 
##                                                 Lésions de l'oeil ou de l'orbite 
##                                                                             1909 
## Lésion prof des tissus (tendons, vx, nerfs,..) ou d'organes internes  (hors TC)  
##                                                                             1852 
##                                                           Insuffisance cardiaque 
##                                                                             1831 
##                                                                           Asthme 
##                                                                             1776 
##                                            Trouble du rythme et de la conduction 
##                                                                             1730 
##                                            autres pathologies et signes généraux 
##                                                                             1640 
##                                                     Douleur thoracique pariétale 
##                                                                             1614 
##                            Agitation, trouble de personnalité et du comportement 
##                                                                             1611 
##                                    autres pathologies digestives et alimentaires 
##                                                                             1511 
##                                                   Douleur dentaire, stomatologie 
##                                                                             1508 
##                                                     Dyspnée et gène respiratoire 
##                                                                             1487 
##                                                                        Urticaire 
##                                                                             1463 
##                                    Anémie, aplasie, autre atteinte hématologique 
##                                                                             1440 
##                          Entorses, luxations et fractures du rachis ou du bassin 
##                                                                             1420 
##                                  autres infectiologie générale et sans précision 
##                                                                             1367 
##                                Gastrite, Ulcère Gastro-duodénal non hémorragique 
##                                                                             1290 
##                                                                      Proctologie 
##                                                                             1279 
##                                                            Nausées, vomissements 
##                                                                             1266 
##                                                                        Epistaxis 
##                                                                             1259 
##                                                                           Grippe 
##                                                                             1215 
##                                       autre rhumato et syst nerveux périphérique 
##                                                                             1195 
##                        Lithiase, infection et autre atteinte des voies biliaires 
##                                                                             1168 
##                                      Dorsalgie et pathologie rachidienne dorsale 
##                                                                             1065 
##                                         Rétention urinaire, pb de sonde, dysurie 
##                                                                             1061 
##                               Cervicalgie, névralgie et autre atteinte cervicale 
##                                                                             1057 
##                                  Laryngite, trachéite et autre atteinte laryngée 
##                                                                             1037 
##                                  Déshydratation et trouble hydro-électrolytiques 
##                                                                             1024 
##                                                   autre affection dermatologique 
##                                                                             1019 
##                                   Troubles sensitifs, moteurs et toniques autres 
##                                                                             1016 
##                                               Diabète et troubles de la glycémie 
##                                                                              979 
##                                      BPCO et insuffisance respiratoire chronique 
##                                                                              951 
##                                                                        Érysipèle 
##                                                                              920 
##                                               Dépression et troubles de l'humeur 
##                                                                              906 
##                                            Schizophrénie, délire, hallucinations 
##                                                                              873 
##                                   Entorses, fractures et lésions costo-sternales 
##                                                                              859 
##                                  Fractures OPN, dents et lésions de la mâchoire  
##                                                                              857 
##                                                        Viroses cutanéo-muqueuses 
##                                                                              832 
##                                                     Erythème et autres éruptions 
##                                                                              830 
##                                         Douleur testiculaire et autre andrologie 
##                                                                              777 
##                                   Appendicite et autre pathologie appendiculaire 
##                                                                              756 
##                                             Dermite atopique, de contact, prurit 
##                                                                              738 
##                                                          Occlusion toute origine 
##                                                                              738 
##                                                  Insuffisance respiratoire aiguë 
##                                                                              632 
##                                             Désorientation et troubles cognitifs 
##                                                                              628 
##                                                    HTA et poussées tensionnelles 
##                                                                              607 
##                                        Syncopes, lipothymies et malaises avec PC 
##                                                                              602 
##                                Vulvo-vaginites, salpingites et autre gynécologie 
##                                                                              599 
##                        Comas, tumeurs, encéphalopathies et autre atteinte du SNC 
##                                                                              586 
##                                                   Ascite, ictère et hépatopathie 
##                                                                              571 
##                                            Piqûres d'arthropode, d'insectes, ... 
##                                                                              568 
##                                                  Oedeme et tuméfaction localisés 
##                                                                              560 
##                                                    Prostatite, orchi-épididymite 
##                                                                              558 
##                                         Oesophagite et reflux gastro-oesophagien 
##                                                                              535 
##                                                              Insuffisance rénale 
##                                                                              513 
##                                           Angor et autre cardiopathie ischémique 
##                                                                              509 
##                                                                        Hématurie 
##                                                                              488 
##                                  Hémorragie digestive sans mention de péritonite 
##                                                                              488 
##                                  Pancréatite aiguë et autre atteinte du pancréas 
##                                                                              474 
##                                                               Embolie pulmonaire 
##                                                                              470 
##                                  Sujet en contact avec une maladie transmissible 
##                                                                              457 
##                                                            Phlébite périphérique 
##                                                                              448 
##                                                  autres patho cardio-vasculaires 
##                                                                              442 
##                                                   Sinusites aiguës et chroniques 
##                                                                              406 
##                                                            Infarctus du myocarde 
##                                                                              392 
##                                                            Septicémies et sepsis 
##                                                                              366 
##                                                      Atteintes de nerfs crâniens 
##                                                                              301 
##                                                         Choc cardio-circulatoire 
##                                                                              299 
##                                                                          (Other) 
##                                                                             3011 
##                                                                             NA's 
##                                                                              296
```

```r
tapply(merge2015$TYPE_URGENCES, list(merge2015$FINESS, merge2015$TYPE_URGENCES), length)
```

```
##     Autre recours Médico-chirurgical Psychiatrique Toxicologique
## 3Fr           514               4684           152            68
## Alk           163               1134            49            16
## Ane            NA                 NA            NA            NA
## Col          2243              25717          1367           915
## Dia           489               5923           109             3
## Dts            NA               1618            NA            NA
## Geb           530               6062           122           111
## Hag           738              17936           461           468
## Hus            NA                 NA            NA            NA
## Mul          1056              18671          1416           696
## Odi            97               6833            55             2
## Ros            NA                 NA            NA            NA
## Sav           149               2640           133            76
## Sel           785              11274           242           355
## Wis           409               5398           207            94
## HTP           450              22884           506           493
## NHC           138              10008           268           564
## Emr           324               4812           565           286
## Hsr            60               2225            25            33
## Ccm            NA                 NA            NA            NA
##     Traumatologique
## 3Fr            3525
## Alk            1315
## Ane              NA
## Col           19205
## Dia            4012
## Dts            6080
## Geb            6659
## Hag           10948
## Hus              NA
## Mul            7819
## Odi            3048
## Ros             502
## Sav            2724
## Sel           10863
## Wis            3901
## HTP           15133
## NHC             602
## Emr            3215
## Hsr               7
## Ccm              NA
```


Commentaires
------------
Au moment du merging on veut que toute la colonne DP soit prise en compte. Il faut donc préciser _all.x = TRUE_ 
![img](326775.image0.jpg). 

Explications: [How to Use the merge() Function with Data Sets in R](http://www.dummies.com/how-to/content/how-to-use-the-merge-function-with-data-sets-in-r.html). Les codes n'ayant pas de correspondance FEDORU sont marqués NA. 

