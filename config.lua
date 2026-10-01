Config = {}

-- Job settings
Config.JobName = 'trucker'
Config.JobLabel = 'Trucker'
Config.JobBlip = { id = 67, color = 5, scale = 1.0 }

-- Freight settings
Config.Freights = {
    {
        name = 'Wood',
        label = 'Wood Delivery',
        model = 'prop_logpile_01',
        payment = 500,
        locations = {
            { x = 1202.24, y = -1251.38, z = 35.22 },
            { x = 1202.24, y = -1251.38, z = 35.22 }
        }
    },
    {
        name = 'Electronics',
        label = 'Electronics Delivery',
        model = 'prop_box_wood02a',
        payment = 700,
        locations = {
            { x = 1202.24, y = -1251.38, z = 35.22 },
            { x = 1202.24, y = -1251.38, z = 35.22 }
        }
    }
}

-- UI settings
Config.UI = {
    title = 'Trucker Job',
    subtitle = 'Select a freight to deliver',
    buttonText = 'Start Delivery'
}