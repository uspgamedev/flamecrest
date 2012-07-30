
require "unit"

function heal (healer, healee)
  local healamount = healer:mt()
  healee:heal(healamount)
end