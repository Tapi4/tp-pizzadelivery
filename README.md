# tp-pizzadelivery
- pizzadelivery Script
- [QBCORE]


## Features
- Easy editable config file
- If you want to finish the job, you can finish the job from the NPC you received the job from
- NPC gives you random locations


## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)
- [qb-target](https://github.com/qbcore-framework/qb-target)


### Script
- Add the following code to your server.cfg/resouces.cfg
        ensure tp-pizzadelivery
- Add to qb-inventory image in the images file
- Add to qb-core>shared>items> :
    ["pizza"] 	 = {["name"] = "pizza",	["label"] = "Pizza Delivery", 	["weight"] = 5000, 	["type"] = "item", 	 ["image"] = "pizza.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Pizza"},

and enjoy the script !
