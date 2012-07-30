
require "unit"

function heal (healer, healee)
  local healamount = healer:mt()
  print("Healer will heal healee for "..healamount)
  if healer.weapon.useexp then
    local exp = healer.weapon.useexp
    print("Healer gains "..exp.." exp points")
    healer:gainexp(exp)
  end
  healee:heal(healamount)
end