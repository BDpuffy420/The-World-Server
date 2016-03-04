SET z_levels=6
cd 

FOR /L %%i IN (1,1,%z_levels%) DO (
  java -jar MapPatcher.jar -clean ../../maps/Sol-England_2.dmm.backup ../../maps/Sol-England_2.dmm ../../maps/Sol-England_2.dmm
  java -jar MapPatcher.jar -clean ../../maps/TauCeti-Biezel.dmm.backup ../../maps/TauCeti-Biezel.dmm ../../maps/TauCeti-Biezel.dmm
  java -jar MapPatcher.jar -clean ../../maps/centi2.dmm.backup ../../maps/centi2.dmm ../../maps/centi2.dmm
)

pause