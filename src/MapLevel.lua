local MapLevel = {
    grass = {
        {
            heartNum = 4,
            heartBg = "res/heart_bar_grass.png",
            background = "res/map_grass_bg.jpg",
            barriers = {
                {direction = 2, x = 6, y = 1},
                {direction = 2, x = 13, y = 5},
                {direction = 2, x = 20, y = 10},
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
            background = "res/map_grass_bg.jpg",
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
        {
            heartNum = 4,
            heartBg = "res/heart_bar_grass.png",
            background = "res/map_grass_bg.jpg",
            barriers = {
                {direction = 2, x = 0, y = 5},
                {direction = 1, x = 5, y = 0},
                {direction = 1, x = 17, y = 0},
                {direction = 2, x = 25, y = 5},
                {direction = 1, x = 17, y = 14},
                {direction = 1, x = 5, y = 14},
                {direction = 2, x = 13, y = 6},
            },
            snake = {
                size = 1,
                x = 5, 
                y = 1,
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
            background = "res/map_stone_bg.jpg",
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
        },
        {
            heartNum = 4,
            heartBg = "res/heart_bar_stone.png",
            background = "res/map_stone_bg.jpg",
            barriers = {
                {direction = 2, x = 6, y = 5},
                {direction = 2, x = 19, y = 5},
                {direction = 1, x = 7, y = 10},
                {direction = 1, x = 15, y = 10},
                {direction = 1, x = 15, y = 3},
                {direction = 1, x = 7, y = 3},
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
        },
        {
            heartNum = 4,
            heartBg = "res/heart_bar_stone.png",
            background = "res/map_stone_bg.jpg",
            barriers = {
                {direction = 2, x = 0, y = 5},
                {direction = 1, x = 5, y = 0},
                {direction = 1, x = 17, y = 0},
                {direction = 2, x = 25, y = 5},
                {direction = 1, x = 17, y = 14},
                {direction = 1, x = 5, y = 14},
                {direction = 2, x = 13, y = 6},
            },
            snake = {
                size = 1,
                x = 23, 
                y = 10,
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
            background = "res/map_snow_bg.jpg",
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
        },
        {
            heartNum = 4,
            heartBg = "res/heart_bar_snow.png",
            background = "res/map_snow_bg.jpg",
            barriers = {
                {direction = 1, x = 6, y = 11},
                {direction = 1, x = 1, y = 11},
                {direction = 1, x = 15, y = 2},
                {direction = 1, x = 20, y = 2},
                {direction = 2, x = 12, y = 5},
                {direction = 2, x = 13, y = 5},
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
        },
        {
            heartNum = 4,
            heartBg = "res/heart_bar_snow.png",
            background = "res/map_snow_bg.jpg",
            barriers = {
                {direction = 2, x = 6, y = 5},
                {direction = 2, x = 19, y = 5},
                {direction = 1, x = 7, y = 10},
                {direction = 1, x = 15, y = 10},
                {direction = 1, x = 15, y = 3},
                {direction = 1, x = 7, y = 3},
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
        },
    }
}

return MapLevel