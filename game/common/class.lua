
require 'common.attributes'
require 'common.terraincosts'

class = require 'lux.oo.prototype' :new {
   name = "Soldier",
   weapons = {"lance"},
   traits = {},
   caps = nil,
   defaultgrowths = nil,
   defaultattributes = nil,
   promotionbonus = nil,
   exptierbonus = 0,
   expclasspower = 3,
   expclassbonus = 0,
   movecosts = movecosts.infantry
}

class.__init = {
  caps = attributes:new{
      maxhp = 40,
      str = 20,
      mag = 20,
      spd = 20,
      skl = 20,
      def = 20,
      res = 20,
      lck = 40,
      mv  = 99, -- lol
      con = 60  -- lol
   },
  defaultgrowths = attributes:new{
      maxhp = 50,
      str = 20,
      mag = 20,
      spd = 20,
      skl = 20,
      def = 20,
      res = 20,
      lck = 20
   },
  defaultattributes = attributes:new{
      maxhp = 20,
      str = 10,
      mag = 10,
      spd = 10,
      skl = 10,
      def = 10,
      res = 10,
      lck = 10,
      mv = 5,
      con = 8
   },
  promotionbonus = attributes:new{
    maxhp = 4,
    str = 2,
    mag = 2,
    spd = 2,
    skl = 2,
    def = 2,
    res = 2,
    lck = 2,
    mv = 1,
    con = 2
  }
}
