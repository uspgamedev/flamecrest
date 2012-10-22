
local print = print

module "combat" do

  function rescue(rescuer, rescuee)
    if rescuer:canrescue(rescuee) then
      print ("Looks like it can rescue")
      rescuer:rescue(rescuee)
      if rescuer:getrescuedunit() == rescuee then
        print("success!")
      else
        print("oh no")
      end
    else
      print ("no can rescue")
    end
    print("")
  end

  function dropunit(rescuer)
    rescuer:dropunit()
    print("dropped")
    print("")
  end

end
