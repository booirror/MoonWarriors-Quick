-- 敌人类型
local GameConfig = require("src.app.GameConfig")
local EnemyType = {
    {
        type = 0,                               -- 类型ID
        textureName = "E0.png",                 -- 战机图片
        bulletType = "W2.png",                  -- 子弹图片
        HP = 1,                                 -- 生命值
        moveType = GameConfig.enemyMoveType.attack,   -- 移动类型(attack、VERTICAL、horizontal、overlap)(攻击、垂直、水平、重叠)
        attackMode = GameConfig.enemyMoveType.normal, -- 攻击模式(normal、tsuihikidan)
        scoreValue = 15                         -- 成绩值
    },
    {
        type = 1,
        textureName = "E1.png",
        bulletType = "W2.png",
        HP = 2,
        moveType = GameConfig.enemyMoveType.attack,
        attackMode = GameConfig.enemyMoveType.normal,
        scoreValue = 40
    },
    {
        type = 2,
        textureName = "E2.png",
        bulletType = "W2.png",
        HP = 4,
        moveType = GameConfig.enemyMoveType.horizontal,
        attackMode = GameConfig.enemyAttackMode.tsuihikidan,
        scoreValue = 60
    },
    {
        type = 3,
        textureName = "E3.png",
        bulletType = "W2.png",
        HP = 6,
        moveType = GameConfig.enemyMoveType.overlap,
        attackMode = GameConfig.enemyMoveType.normal,
        scoreValue = 80
    },
    {
        type = 4,
        textureName = "E4.png",
        bulletType = "W2.png",
        HP = 10,
        moveType = GameConfig.enemyMoveType.horizontal,
        attackMode = GameConfig.enemyAttackMode.tsuihikidan,
        scoreValue = 150
    },
    {
        type = 5,
        textureName = "E5.png",
        bulletType = "W2.png",
        HP = 15,
        moveType = GameConfig.enemyMoveType.horizontal,
        attackMode = GameConfig.enemyMoveType.normal,
        scoreValue = 200
    }
}

return EnemyType