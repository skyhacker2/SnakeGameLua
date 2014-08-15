local MapLevel = {
    grass = {
        {
            heartNum = 4,
            heartBg = "res/heart_bar_grass.png",
            background = "res/map_grass_bg.png",
            barriers = {
                {direction = 2, x = 6, y = 5},
                {direction = 2, x = 6, y = 0},
                {direction = 2, x = 6, y = 10},
                {direction = 2, x = 18, y = 11},
                {direction = 2, x = 18, y = 6},
                {direction = 2, x = 18, y = 1},
            },
            snake = {
                size = 4,
                x = 9, 
                y = 9,
                direction = "left"
            },
            foods = {
                num = 1
            }
        }
    },
    stone = {
        {
            heartNum = 4,
            heartBg = "res/heart_bar_stone.png",
            background = "res/map_stone_bg.png",
            barriers = {
                {direction = 2, x = 6, y = 5},
                {direction = 2, x = 6, y = 0},
                {direction = 2, x = 6, y = 10},
                {direction = 2, x = 18, y = 11},
                {direction = 2, x = 18, y = 6},
                {direction = 2, x = 18, y = 1},
            },
            snake = {
                size = 4,
                x = 9, 
                y = 9,
                direction = "left"
            },
            foods = {
                num = 1
            }
        }
    },
    snow = {
        {
            heartNum = 4,
            heartBg = "res/heart_bar_snow.png",
            background = "res/map_snow_bg.png",
            barriers = {
                {direction = 2, x = 6, y = 5},
                {direction = 2, x = 6, y = 0},
                {direction = 2, x = 6, y = 10},
                {direction = 2, x = 18, y = 11},
                {direction = 2, x = 18, y = 6},
                {direction = 2, x = 18, y = 1},
            },
            snake = {
                size = 4,
                x = 9, 
                y = 9,
                direction = "left"
            },
            foods = {
                num = 1
            }
        }
    }
}

return MapLevel