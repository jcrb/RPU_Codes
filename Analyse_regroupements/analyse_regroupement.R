# Préparation du fichier des DP de l'année
# dx = dataframe RPU

dpr <- function(dx){
  # On ne garde que les RPU avec un DP
  dpr2 <- dx[!is.na(dx$DP), ]
  # supression des caractères anormaux
  Encoding(dpr2$DP) <- "latin1"
  Encoding(dpr2$MOTIF) <- "latin1"
  # suppression des points décimaux
  dpr2$DP <- gsub(".", "", dpr2$DP, fixed=TRUE)
  # suppression des minuscules
  dpr2$DP <- toupper(dpr2$DP)
  dpr2
}









