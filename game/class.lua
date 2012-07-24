
require "nova.object"

class = nova.object:new{
   name = "Soldier",
   weapons = {"lance"},
   caps = {
      maxhp = 40,
      str = 20,
      mag = 20,
      spd = 20,
      skl = 20,
      def = 20,
      res = 20,
      lck = 40
   },
   defaultgrowths = {
      maxhp = 50,
      str = 20,
      mag = 20,
      spd = 20,
      skl = 20,
      def = 20,
      res = 20,
      lck = 20
   },
   defaultstats = {
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
   exptierbonus = 0,
   expclasspower = 3,
   expclassbonus = 0
}