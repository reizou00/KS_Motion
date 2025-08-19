#> 
#
# 
#
# @input score $MotionPower KS_Motion.Temp
#   どれだけ吹っ飛ばすかを設定する値

# MotionPowerがNullなら初期値に。
execute \
unless score $MotionPower KS_Motion.Temp matches -2147483648..2147483647 run \
scoreboard players set $MotionPower KS_Motion.Temp 125

#> Posを取得するためのAECを召喚
    # AttackerのRotation対象に、座標0.0 0.0 0.0からローカル座標zから0.4離れた場所にAECを召喚。
    execute \
    positioned 0.0 0.0 0.0 \
    rotated as @s run \
    summon area_effect_cloud ^ ^ ^0.4 {Tags:["KS_Motion.PosGetAEC"]}
    # PosGetAECのPosを取得
    data modify storage ks_motion:_ Args.Pos set from entity @n[type=area_effect_cloud,tag=KS_Motion.PosGetAEC] Pos

#> AECのPosを補正計算させるために、スコアに反映しなければならない。
    # X座標
    execute \
    store result score $VectorX KS_Motion.Temp run \
    data get storage ks_motion:_ Args.Pos[0] 1000
    # Z座標
    execute \
    store result score $VectorZ KS_Motion.Temp run \
    data get storage ks_motion:_ Args.Pos[2] 1000

#> ベクトルの補正計算
    # X座標
    scoreboard players operation $VectorX KS_Motion.Temp *= $MotionPower KS_Motion.Temp
    # Z座標
    scoreboard players operation $VectorZ KS_Motion.Temp *= $MotionPower KS_Motion.Temp

#> 補正計算は終了したので、値をstorageに移行、EntityにMotionを代入。
#> 計算のために1000倍したのでそれを0.00001倍して元の値に戻す。
    # X座標
    execute \
    store result storage ks_motion:_ Args.Pos[0] double 0.00001 run \
    scoreboard players get $VectorX KS_Motion.Temp
    # Z座標
    execute \
    store result storage ks_motion:_ Args.Pos[2] double 0.00001 run \
    scoreboard players get $VectorZ KS_Motion.Temp
    # Motion代入
    data modify entity @s Motion set from storage ks_motion:_ Args.Pos
