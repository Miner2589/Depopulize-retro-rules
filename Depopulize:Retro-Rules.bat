@echo off
setlocal EnableDelayedExpansion

rem Initialize variables
set "player=[=O=]"
set "zombie1=[Z1]"
set "zombie2=[Z2]"
set "bullet=."

set "playerPos=10"
set "zombiePos1=20"
set "zombiePos2=15"
set "bulletPos=-1"

set "score=0"
set "gameOver=0"
set "ammo=5"
set "health=3"

rem Game loop
:gameLoop
cls

rem Display game state
echo Score: !score! Ammo: !ammo! Health: !health!
call :displayGame

rem Player input
set /p "action=Move (W/A/S/D), Shoot (Space), Reload (R): "
if /i !action! equ W (
    if !playerPos! gtr 0 (
        set /A playerPos-=1
    )
) else if /i !action! equ S (
    if !playerPos! lss 20 (
        set /A playerPos+=1
    )
) else if /i !action! equ A (
    if !playerPos! gtr 0 (
        set /A playerPos-=1
    )
) else if /i !action! equ D (
    if !playerPos! lss 20 (
        set /A playerPos+=1
    )
) else if /i !action! equ Space (
    if !ammo! gtr 0 (
        set "bulletPos=!playerPos!"
        set /A ammo-=1
    )
) else if /i !action! equ R (
    set "ammo=5"
)

rem Update game state
set /A zombiePos1-=1
set /A zombiePos2-=2

if !zombiePos1! lss 0 (
    set /A zombiePos1=20
    set /A score+=1
)

if !zombiePos2! lss 0 (
    set /A zombiePos2=20
    set /A score+=2
)

rem Check collision
if !playerPos! equ !zombiePos1! (
    set /A health-=1
    if !health! leq 0 (
        set "gameOver=1"
    )
) else if !playerPos! equ !zombiePos2! (
    set /A health-=2
    if !health! leq 0 (
        set "gameOver=1"
    )
) else if !bulletPos! geq 0 (
    if !bulletPos! equ !zombiePos1! (
        set /A zombiePos1=20
        set /A score+=1
        set "bulletPos=-1"
    ) else if !bulletPos! equ !zombiePos2! (
        set /A zombiePos2=20
        set /A score+=2
        set "bulletPos=-1"
    )
)

rem Refill ammo
if %random% LSS 5 set "ammo=5"

rem Delay for better visibility
timeout /nobreak /t 1 >nul

if !gameOver! equ 0 goto gameLoop

echo Game over! Your score is: !score!
pause
exit /B

:displayGame
echo Player:  %playerPos% - !player!
echo Zombie1: %zombiePos1% - !zombie1!
echo Zombie2: %zombiePos2% - !zombie2!
echo Bullet:  %bulletPos% - !bullet!
for /L %%A in (0,1,20) do (
    if %%A equ !playerPos! (
        echo|set /p=!player!
    ) else if %%A equ !zombiePos1! (
        echo|set /p=!zombie1!
    ) else if %%A equ !zombiePos2! (
        echo|set /p=!zombie2!
    ) else if %%A equ !bulletPos! (
        echo|set /p=!bullet!
    ) else (
        echo|set /p=.
    )
}
echo.
exit /B
