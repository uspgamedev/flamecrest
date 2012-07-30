
require "unit"

function heal (healer, healee)
  local healamount = healer:mt()
  print("Healer will heal healee for "..healamount)
  healee:heal(healamount)
end