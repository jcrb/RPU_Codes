#==========================================================================
#
#   groupe.pathologique
#
#==========================================================================
#
# Analyse la colonne CHAPITRE. Il y a 5 goupes possibles: Médico-chirurgical,
# Traumatologique, Psychiatrique, Toxicologique et Autre. A partir du dataframe
# d on isole les lignes correspondantes à l'un des 5 groupes.
#' @return Sont retournés: le nombre de lignes, une table contenant le décompte des items
# du groupe, la table sous forme de pourcentage, un dataframe formé par les lignes
# sélectionnées.
#' @usage: f <- pathologie.medicochir(d3, "autre")
#' @param d dataframe source. Doit contenir au moins une colonne CHAPITRE. 
#'Dans l'exemple d3 correspond à tous les enregistrement, d3g pour la gériatrie,
#'d3p pour la pédiatrie, etc.
#' @param groupe: une des 5 valeurs autorisées: "medic", "trau", "psy", "toxico", "autre"
#' @usage f <- pathologie.medicochir(d3, "autre"); f$n; f$table; f$prop; f$data;
#'tab1(f$data, cex.names = 0.5, cex = 0.8, 
#   sort.group = "decreasing", main = "Médico-chir adultes", bar.values = "percent")

groupe.pathologique <- function(d, groupe){
    if(groupe == "medchir")
        medic <- d[d$TYPE.URGENCES == "Médico-chirurgical", "CHAPITRE"]
    else if(groupe == "trau")
        medic <- d[d$TYPE.URGENCES == "Traumatologique", "CHAPITRE"]
    else if(groupe == "psy")
        medic <- d[d$TYPE.URGENCES == "Psychiatrique", "CHAPITRE"]
    else if(groupe == "toxico")
        medic <- d[d$TYPE.URGENCES == "Toxicologique", "CHAPITRE"]
    else if(groupe == "autre")
        medic <- d[d$TYPE.URGENCES == "Autre recours", "CHAPITRE"]
    
    medic <- factor(medic)
    n.medic <- length(medic)
    s.medic <- sort(table(factor(medic), dnn = "n"), decreasing = TRUE)
    p.medic <- prop.table(s.medic)*100
#     t <- tab1(factor(medic), cex.names = 0.5, cex = 0.8, 
#          sort.group = "decreasing", main = "Médico-chir adultes", bar.values = "percent")
    medic.list <- list(n.medic, s.medic, p.medic, medic)
    names(medic.list) <- c("n","table","prop","data")
    return(medic.list)
}

#==========================================================================
#
#   summary.type.urgence
#
#==========================================================================
#' @description
#' @param vx vecteur char des types d'urgence (éventuellement limité à un établissement de santé 
#'          ou groupe d'établissements)
#' @return
#' @usage   d3.smur <- d3[d3$FINESS %in% c("Wis","Hag","Sav","Sel","Col"), ] # ES SMUR non siège SAMU
#'          type.urgence(d3.smur$TYPE.URGENCES)
#' 
summary.type.urgence <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    t <- table(vx)
    
    n.autres.recours <- t['Autre recours']
    n.medico.chir <- t['Médico-chirurgical']
    n.psy <- t['Psychiatrique']
    n.tox <- t['Toxicologique']
    n.traumato <- t['Traumatologique']
    
    p.autres.recours <- n.autres.recours / n.rens
    p.medico.chir <- n.medico.chir / n.rens
    p.psy <- n.psy / n.rens
    p.tox <- n.tox / n.rens
    p.traumato <- n.traumato / n.rens
    
    a <- c(n, n.na, p.na, n.rens, p.rens,
           n.autres.recours, n.medico.chir, n.psy, n.tox, n.traumato,
           p.autres.recours, p.medico.chir, p.psy, p.tox, p.traumato)
    
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens",
                  "n.autres.recours", "n.medico.chir", "n.psy", "n.tox", "n.traumato",
                  "p.autres.recours", "p.medico.chir", "p.psy", "p.tox", "p.traumato")
    
    return(a)
}

#==========================================================================
#
#   summary.medico.chir
#
#==========================================================================
#' @description analyse de la colonne TYPE.URGENCES
#' @param dx vecteur = dataframe type d3 ou vecteur colonne TYPE.URGENCES
#' @usage summary.medico.chir(d3)
#' @usage  summary.medico.chir(d3$TYPE.URGENCES)

summary.medico.chir <- function(dx){
    if(class(dx) == "data.frame")
        medic <- dx[dx$TYPE.URGENCES == "Médico-chirurgical", "CHAPITRE"]
    t <- summary(factor(medic))
    n <- sum(t)
    
    return(t)
}

#==========================================================================
#
#   summary.toxicologie
#
#==========================================================================
#' @description analyse de la colonne TYPE.URGENCES
#' @param dx vecteur = dataframe type d3 ou vecteur colonne TYPE.URGENCES
#' @usage summary.medico.chir(d3)
#' @usage  summary.medico.chir(d3$TYPE.URGENCES)

summary.toxicologie <- function(dx){
    if(class(dx) == "data.frame")
        medic <- dx[dx$TYPE.URGENCES == "Toxicologique", "CHAPITRE"]
    t <- summary(factor(medic))
    n <- sum(t)
    
    return(t)
}