local LevelConfig = {}

LevelConfig.Level1 = {
    enemyMax = 6,
    enemies = {
        {
            showType = "Repeate",
            showTime = "00:02",
            types = {1,2,3}
        },
        {
            showType = "Repeate",
            showTime = "00:05",
            types = {4, 5, 6}
        }
    }
}

return LevelConfig