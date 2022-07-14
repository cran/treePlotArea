setwd(file.path("H:", "FVA-Projekte", "P01544_BWI4", "Programme", "Eigenentwicklung", "BWI22"))
load(file.path("Grundberechnungen", "Ergebnis", "bwi22_gr_tabellen.R"))
t7 <- subset(baeume.4, tnr == 166 & enr == 2 & bnr == 7)

dyn.load("H:/FVA-Projekte/P01544_BWI4/Programme/Eigenentwicklung/Plausitest/GrenzkreisDll.dll")

G_Kreisflaeche_BWI <- function(Entf, Azi, fGrenz1, fGrenz2, Radius) {
  # Funktion G_Kreisfläche_BWI berechnet die Fläche des Kreises mit Mittelpunkt
  # Entf, Azimut mit den Grenzen fGrenz1, fGrenz2.Grenzen BWI konform!
  # Die Sektorspitze liegt im zweiten Feld fGrenz1(2,.) bzw. fGrenz2(2,.).
  # Dieses Feld  bleibt frei, wenn es sich um eine Gerade handelt.

  iErr <- as.integer(-99)
  Kfaktor <- 0
  Kflaeche <- 0 # damit R signed int zuweist
  tmp <- .C("R_G_Kreisflaeche_BWI", as.single(Entf), as.single(Azi), as.single(fGrenz1),
    as.single(fGrenz2), as.single(Radius),
    Kfaktor = as.single(Kfaktor),
    Kflaeche = as.single(Kflaeche), iErr = as.integer(iErr)
  )[6:8]
  return <- list(
    Kfaktor = as.numeric(tmp$Kfaktor), Kflaeche = as.numeric(tmp$Kflaeche),
    iErr = as.integer(tmp$iErr)
  )
}

#
export <- bwi4orga::read_csv_export(bwi4orga::get_export_file())

# This is it:

grenzen.te <- subset(export[["b3v_wrand"]], tnr == 166 & enr == 2 & rk == 1)
(grz.koord <- grenz.koord.te.auslesen(grenzen.te))
wzp.te <- subset(export[["b3v_wzp"]], tnr == 166 & enr == 2 & pk %in% c(0,1))
wzp.te$entf <- wzp.te$hori/100
  wzp.te[,c("gkrad","in")] <- wzp4.grz.kreis(wzp.te$m_bhd/10,wzp.te$entf)
i <- 3 # bnr 7
f <- G_Kreisflaeche_BWI(Entf = wzp.te[i,"entf"],Azi = wzp.te[i,"azi"],
                        fGrenz1 = grz.koord$f.grz.1,fGrenz2 = grz.koord$f.grz.2,
                        Radius =  wzp.te[i,"gkrad"])
f$Kfaktor
t7$kf2

# Trakt 166, Ecke 2, Baum 7, Werte BWI3.

fGrenz1 <- matrix(c(377, 56, 81, 1100, 1360, 1800), ncol = 2)
fGrenz2 <- matrix(c(141, 154, 270, 1460, 600, 1025), ncol = 2)
fGrenz1[, 2] <- fGrenz1[, 2] / 100
fGrenz2[, 2] <- fGrenz2[, 2] / 100
Radius <- t7$bhd2
hori <- t7$entf
azi <- t7$azi
# Radius / 4 is what you would get
# for treePlotArea::get_boundary_radius(t7$bhd2 * 10) # needs dbh in mm!
print(f <- G_Kreisflaeche_BWI(hori, azi, fGrenz1, fGrenz2, Radius / 4))
print(t7$kf2)
dput(f)
