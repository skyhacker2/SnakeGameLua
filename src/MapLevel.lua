local MapLevel = {
    grass = {
        {
            heartNum = 4,
            heartBg = "res/heart_bar_grass.png",
            background = "res/map_grass_bg.png",
            barriers = {
                {direction = 2, x = 13, y = 5},
            },
            snake = {
                size = 1,
                x = 5, 
                y = 0,
                direction = "right"
            },
            foods = {
                num = 1
            }
        },
        {
            heartNum = 4,
            heartBg = "res/heart_bar_grass.png",
            background = "res/map_grass_bg.png",
            barriers = {
                {direction = 2, x = 8, y = 5},
                {direction = 2, x = 17, y = 5},
            },
            snake = {
                size = 1,
                x = 5, 
                y = 0,
                direction = "right"
            },
            foods = {
                num = 1
            }
        },
    },
    stone = {
        {
            heartNum = 4,
            heartBg = "res/heart_bar_stone.png",
            background = "res/map_stone_bg.png",
            barriers = {
                {direction = 1, x = 18, y = 6},
                {direction = 2, x = 18, y = 2},
                {direction = 1, x = 4, y = 6},
                {direction = 2, x = 7, y = 2},
            },
            snake = {
                size = 1,
                x = 23, 
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
                {direction = 2, x = 6, y = 11},
                {direction = 2, x = 6, y = 0},
                {direction = 2, x = 18, y = 0},
                {direction = 2, x = 18, y = 11},
            },
            snake = {
                size = 1,
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