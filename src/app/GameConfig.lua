
local GameConfig = {}

GameConfig.order_effect = 9999
GameConfig.order_spark = 10000

GameConfig.gameState = {
    home = 0,
    play = 1,
    over = 2,
}

GameConfig.keys = {}

GameConfig.level = {
    stage1 = 1,
    stage2 = 2,
    stage3 = 3,
}

GameConfig.life = 5

GameConfig.score = 0

GameConfig.sound = true

GameConfig.enemyMoveType = {
    attack = 0,
    vertical = 1,
    horizontal = 2,
    overlap = 3,
}

GameConfig.deltaX = -100
GameConfig.offsetX = -24
GameConfig.rot = -5.625

GameConfig.bulletType = {
    player = 1,
    enemy = 2,
}

GameConfig.weaponType = {
    one = 1,
}

GameConfig.unitTag = {
    enemyBullet = 900,
    playerBullet = 901,
    enemy = 1000,
    player = 1000,
}

GameConfig.enemyAttackMode = {
    normal = 1,
    tsuihikidan = 2 
}

GameConfig.lifeUpScore = {50000, 100000, 150000, 200000, 250000, 300000}

GameConfig.container = {
    enemies = {},
    enemyBullets = {},
    playerBullets = {},
    explosions = {},
    sparks = {},
    hits = {},
    backSkys = {},
    backitlemaps = {}
}

GameConfig.bulletSpeed = {
    enemy = -200,
    ship = 900,
}

GameConfig.activeEnemies = 0

return GameConfig
