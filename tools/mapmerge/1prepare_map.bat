SET z_levels=6
cd ../../maps

FOR /L %%i IN (1,1,%z_levels%) DO (
  copy Sol-England_2.dmm Sol-England_2.dmm.backup
  copy TauCeti-Biezel.dmm TauCeti-Biezel.dmm.backup
  copy centi2.dmm centi2.dmm.backup
)

pause
