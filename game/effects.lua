
require "unit"

function heal (healer, healee)
  if not healer.weapon or not healer.weapon:hasdurability() then return end
  local healamount = healer:mt()
  print("Healer will heal healee for "..healamount)
  if healer.weapon.useexp then
    local exp = healer.weapon.useexp
    print("Healer gains "..exp.." exp points")
    healer:gainexp(exp)
  end
  healee:heal(healamount)
  healer.weapon:weardown()
end