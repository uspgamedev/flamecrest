
local weaponspec = require 'lux.oo.prototype' :new {
  mt = 5,
  hit = 60,
  wgt = 3,
  crt = 0,
  maxdur = 40,
  typename = "sword",
  atkattr = "Str",
  defattr = "Def",
  bonusagainst = {},
  useexp = nil, --for staves
  minrange = 1,
  maxrange = 1
}

return weaponspec
