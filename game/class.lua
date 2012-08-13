
require "lux.object"
require "attributes"

class = lux.object.new{
   name = "Soldier",
   weapons = {"lance"},
   caps = nil,
   defaultgrowths = nil,
   defaultattributes = nil,
   defaultextendedattributes = nil,
   exptierbonus = 0,
   expclasspower = 3,
   expclassbonus = 0
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
      lck = 40
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
   },
  defaultextendedattributes = extendedattributes:new{
    mv = 5,
    con = 8
  }
}
