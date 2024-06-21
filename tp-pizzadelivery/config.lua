Config = {}

Config.JobName = 'pizzadelivery'

Config.PizzaDeliveryNPC = {
    model = 's_m_y_chef_01',
    coords = vector3(176.52, -1438.68, 28.24),
    targetLabel = 'Pizza Delivery Job',
    interactionDistance = 2.0
}

Config.DeliveryPoints = {
    vector3(159.64, -253.72, 50.4),
    vector3(-80.44, -1442.0, 30.8),
    vector3(197.32, -1493.56, 28.2),
    vector3(504.4, -1844.36, 26.44),
    vector3(-186.36, -1701.36, 31.84),
    vector3(-697.84, -1042.32, 15.12),
    vector3(-415.68, -1706.36, 18.48),
    vector3(977.24, -1488.4, 30.44),
    vector3(191.64, -1884.68, 23.72),
    vector3(446.8, -2047.24, 22.76),
}

Config.VehicleModel = 'vwcaddy'
Config.DeliveryReward = math.random(300, 600)
Config.DeliveryPedModel = 'a_m_y_business_01'
Config.DeliveryPedAnimDict = 'amb@world_human_stand_mobile@male@text@base'
Config.DeliveryPedAnimName = 'base'

Config.PizzaItem = 'pizza'
