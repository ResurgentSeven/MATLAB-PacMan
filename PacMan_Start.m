function PacMan_Start

clc
clear
close all

%screens
startscreen = imread('PacMan_StartScreen.png');
screen = imread('PacMan_Maze.png');
%pellet things
tokens = imread('PacMan_Token.png');
%pacman himself
pacman = imread('PacMan_PacMan.png');
%all the ghosts
blinky = imread('PacMan_Blinky.png');
inky = imread('PacMan_Inky.png');
pinky = imread('PacMan_Pinky.png');
clyde = imread('PacMan_Clyde.png');

%create main figure
fMain = figure('Name', 'PacMan', 'Position', [500, 40, 717, 798], 'NumberTitle', 'off');

%display startscreen
image(startscreen)
axis off

%instructions on how to play
uicontrol('Style', 'text', 'string', 'Start and stop with the spacebar', 'Position', [175, 45, 400, 20])
uicontrol('Style', 'text', 'string', 'Move with WASD', 'Position', [175, 30, 400, 20])
%sets maze that entities will see
maze = [
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 1;
    1 2 1 1 2 1 1 1 2 1 2 1 1 1 2 1 1 2 1;
    1 2 1 1 2 1 1 1 2 1 2 1 1 1 2 1 1 2 1;
    1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1;
    1 2 1 1 2 1 2 1 1 1 1 1 2 1 2 1 1 2 1;
    1 2 2 2 2 1 2 2 2 1 2 2 2 1 2 2 2 2 1;
    1 1 1 1 2 1 1 1 2 1 2 1 1 1 2 1 1 1 1;
    1 1 1 1 2 1 0 0 0 0 0 0 0 1 2 1 1 1 1;
    1 1 1 1 2 1 0 1 1 1 1 1 0 1 2 1 1 1 1;
    3 0 0 0 2 0 0 1 0 0 0 1 0 0 2 0 0 0 3;
    1 1 1 1 2 1 0 1 1 1 1 1 0 1 2 1 1 1 1;
    1 1 1 1 2 1 0 0 0 0 0 0 0 1 2 1 1 1 1;
    1 1 1 1 2 1 0 1 1 1 1 1 0 1 2 1 1 1 1;
    1 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 1;
    1 2 1 1 2 1 1 1 2 1 2 1 1 1 2 1 1 2 1;
    1 2 2 1 2 2 2 2 2 2 2 2 2 2 2 1 2 2 1;
    1 1 2 1 2 1 2 1 1 1 1 1 2 1 2 1 2 1 1;
    1 2 2 2 2 1 2 2 2 1 2 2 2 1 2 2 2 2 1;
    1 2 1 1 1 1 1 1 2 1 2 1 1 1 1 1 1 2 1;
    1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%counts moves
moveCount = 0;

%if player won
playerWin = false;

%starting position for player
pPos = [17, 10];
%starting velocity for player
pVelo = [0, 0];

%starting position for ghosts
%ghost1 (Blinky)
g1Pos = [9, 10];
%ghost2 (Inky)
g2Pos = [11, 10];
%ghost3 (Pinky)
g3Pos = [11, 9];
%ghost4 (Clyde)
g4Pos = [11, 11];
%starting velocity for ghosts
%ghost1
g1Velo = [1, 0];
%ghost2
g2Velo = [0, -1];
%ghost3
g3Velo = [0, 1];
%ghost4
g4Velo = [-1, 0];

%initializes key press
keyPressed = ' ';
spaceCount = 0;
fMain.KeyPressFcn = {@PlayerInput};

    %gets player's key presses
    function PlayerInput(~, h)
        keyPressed = h.Key;
        if spaceCount > 0 && strcmp(keyPressed, 'space')
            GameOver
        elseif strcmp(keyPressed, 'space')
            spaceCount = spaceCount + 1;
            StartGame
        end
    end


    function StartGame(~, ~)
        
        
        while true
            
            %PLAYER
            
            %reseting values
            moveUp = true;
            moveDown = true;
            moveLeft = true;
            moveRight = true;
            
            %determining if the player is next to a wall and in which direction
            if maze(pPos(1)-1, pPos(2)) == 1
                moveUp = false; %doesn't allow player to move up into a wall
            end
            if maze(pPos(1)+1, pPos(2)) == 1
                moveDown = false; %doesn't allow player to move down into a wall
            end
            if maze(pPos(1), pPos(2)-1) == 1
                moveLeft = false; %doesn't allow player to move left into a wall
            end
            if maze(pPos(1), pPos(2)+1) == 1
                moveRight = false; %doesn't allow player to move right into a wall
            end
            
            %stops the player if their velocity will take them into a wall
            if pVelo(1) == -1 && ~moveUp
                pVelo(1) = 0;
            end
            if pVelo(1) == 1 && ~moveDown
                pVelo(1) = 0;
            end
            if pVelo(2) == -1 && ~moveLeft
                pVelo(2) = 0;
            end
            if pVelo(2) == 1 && ~moveRight
                pVelo(2) = 0;
            end
            
            
            %determines velocity based upon that input
            if strcmp(keyPressed, 'w') && moveUp
                pVelo(2) = 0;
                pVelo(1) = -1;
            end
            if strcmp(keyPressed, 's') && moveDown
                pVelo(2) = 0;
                pVelo(1) = 1;
            end
            if strcmp(keyPressed, 'a') && moveLeft
                pVelo(2) = -1;
                pVelo(1) = 0;
            end
            if strcmp(keyPressed, 'd') && moveRight
                pVelo(2) = 1;
                pVelo(1) = 0;
            end
            if strcmp(keyPressed, 'space')
                pVelo = [0, 0];
            end
            
            %GHOSTS
            
            %randomness factor
            g1Rand = rand(1);
            g2Rand = rand(1);
            g3Rand = rand(1);
            g4Rand = rand(1);
            
            
            % g1 characteristics
            %oppisite of ghost 4, meaning he runs away from the player
            
            %randomness
            if g1Rand < .025
                g1Velo(1) = g1Velo(1) * -1;
                g1Velo(2) = g1Velo(2) * -1;
            else
                
                g1sight = false;
                %checks sightline up --------------------------------------------------
                g1kUp = 0;
                g1sightUp = 0;
                while ~(g1sightUp == 1) && ~g1sight %checks if you saw the player or sightline is blocked
                    g1kUp = g1kUp + 1;
                    g1sightUpPos = g1Pos(1) - g1kUp;
                    g1sightUp = maze(g1sightUpPos, g1Pos(2));
                    if g1sightUpPos == pPos(1) && g1Pos(2) == pPos(2)
                        g1Velo = [-1, 0]; %changes his velocity if player is spotted
                        g1sight = true;
                    end
                end
                
                if ~g1sight %if you did not see him in the up direction look down
                    %checks sightline down ------------------------------------------------
                    g1kDown = 0;
                    g1sightDown = 0;
                    while ~(g1sightDown == 1) && ~g1sight %checks if you saw the player or sightline is blocked
                        g1kDown = g1kDown + 1;
                        g1sightDownPos = g1Pos(1) + g1kDown;
                        g1sightDown = maze(g1sightDownPos, g1Pos(2));
                        if g1sightDownPos == pPos(1) && g1Pos(2) == pPos(2)
                            g1Velo = [1, 0]; %changes his velocity if player is spotted
                            g1sight = true;
                        end
                    end
                    
                    if ~g1sight %if you did not see him in the down direction look left
                        %checks sightline left ------------------------------------------------
                        g1kLeft = 0;
                        g1sightLeft = 0;
                        while ~(g1sightLeft == 1 || g1sightLeft == 3) && ~g1sight %checks if you saw the player or sightline is blocked
                            g1kLeft = g1kLeft + 1;
                            g1sightLeftPos = g1Pos(2) - g1kLeft;
                            g1sightLeft = maze(g1Pos(1), g1sightLeftPos);
                            if g1sightLeftPos == pPos(2) && g1Pos(1) == pPos(1)
                                g1Velo = [0, -1]; %changes his velocity if player is spotted
                                g1sight = true;
                            end
                        end
                        
                        if ~g1sight %if you did not see him in the left direction look right
                            %checks sightline right -----------------------------------------------
                            g1kRight = 0;
                            g1sightRight = 0;
                            while ~(g1sightRight == 1 || g1sightRight == 3) && ~g1sight %checks if you saw the player or sightline is blocked
                                g1kRight = g1kRight + 1;
                                g1sightRightPos = g1Pos(2) + g1kRight;
                                g1sightRight = maze(g1Pos(1), g1sightRightPos);
                                if g1sightRightPos == pPos(2) && g1Pos(1) == pPos(1)
                                    g1Velo = [0, 1]; %changes his velocity if player is spotted
                                end
                            end
                        end
                    end
                end
                
                %if g1 will run into a wall it changes it's direction
                if maze(g1Pos(1) + g1Velo(1), g1Pos(2) + g1Velo(2)) == 1
                    if g1Velo(1) ~= 0 %moving vertically
                        if maze(g1Pos(1), g1Pos(2) - 1) ~= 1
                            g1Velo = [0, -1];
                        else
                            g1Velo = [0, 1];
                        end
                    else %moving horizontally
                        if maze(g1Pos(1) - 1, g1Pos(2)) ~= 1
                            g1Velo = [-1, 0];
                        else
                            g1Velo = [1, 0];
                        end
                    end
                end
            end
            
            % g2 movement -------------------------------------------------------------
            %random movement no matter what
            
            %randomness
            if g2Rand < .025
                g2Velo(1) = g2Velo(1) * -1;
                g2Velo(2) = g2Velo(2) * -1;
            else
                
                %randomly choose if it will turn
                g2willTurn = randi([0, 1]);
                %checks to see if it will hit a wall
                if maze(g2Pos(1) + g2Velo(1), g2Pos(2) + g2Velo(2)) == 1
                    g2willTurn = 1;
                end
                
                %if it chooses to turn or needs to turn it will
                if g2willTurn == 1
                    %checks L & R lanes --------------------------------------------------
                    if g2Velo(1) ~= 0
                        %set movement to true
                        g2Right = true;
                        g2Left = true;
                        
                        %checks right
                        if maze(g2Pos(1), g2Pos(2) + 1) == 1
                            g2Right = false;
                        end
                        %checks left
                        if maze(g2Pos(1), g2Pos(2) - 1) == 1
                            g2Left = false;
                        end
                        
                        %if both L & R lanes are open it chooses which one to go down
                        if g2Left && g2Right
                            choose = randi([0, 1]);
                            if choose == 1
                                g2Left = false;
                            end
                        end
                        
                        %changes velocity
                        if g2Left && g2willTurn
                            g2Velo = [0, -1];
                        end
                        if g2Right && g2willTurn
                            g2Velo = [0, 1];
                        end
                        
                        %checks U & D lanes --------------------------------------------------
                    else
                        g2Down = true;
                        g2Up = true;
                        
                        %checks below
                        if maze(g2Pos(1) + 1, g2Pos(2)) == 1
                            g2Down = false;
                        end
                        %checks above
                        if maze(g2Pos(1) - 1, g2Pos(2)) == 1
                            g2Up = false;
                        end
                        
                        %if both U & D lanes are open it chooses which one to go down
                        if g2Down && g2Up
                            choose = randi([0, 1]);
                            if choose == 1
                                g2Up = false;
                            end
                        end
                        
                        %changes velocity
                        if g2Up && g2willTurn
                            g2Velo = [-1, 0];
                        end
                        if g2Down && g2willTurn
                            g2Velo = [1, 0];
                        end
                    end
                end
            end
            
            % g3 characteristics
            %very agro to player constantly tries to attack him
            
            %randomness
            if g3Rand < .025
                g3Velo(1) = g3Velo(1) * -1;
                g3Velo(2) = g3Velo(2) * -1;
            else
                %if it is going in the Y direction only check for X moves
                if g3Velo(1) ~= 0
                    %checks which direction player is in
                    if g3Pos(2) >= pPos(2) %player is left
                        if maze(g3Pos(1), g3Pos(2) - 1) ~= 1
                            g3Velo = [0, -1];
                            %if you cant turn left but are going to run into a
                            %wall turn the other way
                        elseif maze(g3Pos(1) + g3Velo(1), g3Pos(2) + g3Velo(2)) == 1
                            g3Velo = [0, 1];
                        end
                    elseif g3Pos(2) <= pPos(2) %player is right
                        if maze(g3Pos(1), g3Pos(2) + 1) ~= 1
                            g3Velo = [0, 1];
                            %if you cant turn right but are going to run into a
                            %wall turn the other way
                        elseif maze(g3Pos(1) + g3Velo(1), g3Pos(2) + g3Velo(2)) == 1
                            g3Velo = [0, -1];
                        end
                    end
                    
                    %if it is going in the X direction only check Y moves
                else
                    %checks which direction player is in
                    if g3Pos(1) >= pPos(1) %player is up
                        if maze(g3Pos(1) - 1, g3Pos(2)) ~= 1
                            g3Velo = [-1, 0];
                            %if you cant turn up but are going to run into a
                            %wall turn the other way
                        elseif maze(g3Pos(1) + g3Velo(1), g3Pos(2) + g3Velo(2)) == 1
                            g3Velo = [1, 0];
                        end
                    elseif g3Pos(1) <= pPos(1) %player is down
                        if maze(g3Pos(1) + 1, g3Pos(2)) ~= 1
                            g3Velo = [1, 0];
                            %if you cant turn down but are going to run into a
                            %wall turn the other way
                        elseif maze(g3Pos(1) + g3Velo(1), g3Pos(2) + g3Velo(2)) == 1
                            g3Velo = [-1, 0];
                        end
                    end
                end
                
                
            end
            
            %g4 movement -------------------------------------------------------------
            %keeps the same movement until he sees the player or hits a wall
            %maybe a bit more optimization
            
            %randomness
            if g4Rand < .025
                g4Velo(1) = g4Velo(1) * -1;
                g4Velo(2) = g4Velo(2) * -1;
            else
                
                g4sight = false;
                %checks sightline up --------------------------------------------------
                g4kUp = 0;
                g4sightUp = 0;
                while ~(g4sightUp == 1) && ~g4sight %checks if you saw the player or sightline is blocked
                    g4kUp = g4kUp + 1;
                    g4sightUpPos = g4Pos(1) - g4kUp;
                    g4sightUp = maze(g4sightUpPos, g4Pos(2));
                    if g4sightUpPos == pPos(1) && g4Pos(2) == pPos(2)
                        g4Velo = [-1, 0]; %changes his velocity if player is spotted
                        g4sight = true;
                    end
                end
                
                if ~g4sight %if you did not see him in the up direction look down
                    %checks sightline down ------------------------------------------------
                    g4kDown = 0;
                    g4sightDown = 0;
                    while ~(g4sightDown == 1) && ~g4sight %checks if you saw the player or sightline is blocked
                        g4kDown = g4kDown + 1;
                        g4sightDownPos = g4Pos(1) + g4kDown;
                        g4sightDown = maze(g4sightDownPos, g4Pos(2));
                        if g4sightDownPos == pPos(1) && g4Pos(2) == pPos(2)
                            g4Velo = [1, 0]; %changes his velocity if player is spotted
                            g4sight = true;
                        end
                    end
                    
                    if ~g4sight %if you did not see him in the down direction look left
                        %checks sightline left ------------------------------------------------
                        g4kLeft = 0;
                        g4sightLeft = 0;
                        while ~(g4sightLeft == 1 || g4sightLeft == 3) && ~g4sight %checks if you saw the player or sightline is blocked
                            g4kLeft = g4kLeft + 1;
                            g4sightLeftPos = g4Pos(2) - g4kLeft;
                            g4sightLeft = maze(g4Pos(1), g4sightLeftPos);
                            if g4sightLeftPos == pPos(2) && g4Pos(1) == pPos(1)
                                g4Velo = [0, -1]; %changes his velocity if player is spotted
                                g4sight = true;
                            end
                        end
                        
                        if ~g4sight %if you did not see him in the left direction look right
                            %checks sightline right -----------------------------------------------
                            g4kRight = 0;
                            g4sightRight = 0;
                            while ~(g4sightRight == 1 || g4sightRight == 3) && ~g4sight %checks if you saw the player or sightline is blocked
                                g4kRight = g4kRight + 1;
                                g4sightRightPos = g4Pos(2) + g4kRight;
                                g4sightRight = maze(g4Pos(1), g4sightRightPos);
                                if g4sightRightPos == pPos(2) && g4Pos(1) == pPos(1)
                                    g4Velo = [0, 1]; %changes his velocity if player is spotted
                                end
                            end
                        end
                    end
                end
                
                %if g4 will run into a wall it changes it's direction
                if maze(g4Pos(1) + g4Velo(1), g4Pos(2) + g4Velo(2)) == 1
                    if g4Velo(1) ~= 0 %moving vertically
                        if maze(g4Pos(1), g4Pos(2) -1) ~= 1
                            g4Velo = [0, -1];
                        else
                            g4Velo = [0, 1];
                        end
                    else %moving horizontally
                        if maze(g4Pos(1) - 1, g4Pos(2)) ~= 1
                            g4Velo = [-1, 0];
                        else
                            g4Velo = [1, 0];
                        end
                    end
                end
            end
            
            %MOVEMENT
            
            %starting movement
            if moveCount < 14
                moveCount = moveCount + 1;
                if moveCount == 1
                    g1Velo = [0 ,-1];
                    g2Velo = [0, 0];
                    g3Velo = [0, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 2
                    g2Velo = [0, 0];
                    g3Velo = [0, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 3
                    g2Velo = [-1, 0];
                    g3Velo = [0, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 4
                    g2Velo = [-1, 0];
                    g3Velo = [0, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 5
                    g2Velo = [0, 1];
                    g3Velo = [0, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 6
                    g3Velo = [0, 1];
                    g4Velo = [0, 0];
                elseif moveCount == 7
                    g3Velo = [-1, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 8
                    g3Velo = [-1, 0];
                    g4Velo = [0, 0];
                elseif moveCount == 9
                    g3Velo = [0, -1];
                    g4Velo = [0, 0];
                elseif moveCount == 10
                    g4Velo = [0, -1];
                elseif moveCount == 11
                    g4Velo = [-1, 0];
                elseif moveCount == 12
                    g4Velo = [-1, 0];
                elseif moveCount == 13
                    g4Velo = [0, 1];
                end
            end
            
            %update the global maze
            if maze(pPos(1), pPos(2)) == 2
                maze(pPos(1), pPos(2)) = 0;
            end
            
            %get total number of tokens left
            totalTokens = sum(sum(maze == 2));
            
            %get previous positions
            pPrev = pPos;
            g1Prev = g1Pos;
            g2Prev = g2Pos;
            g3Prev = g3Pos;
            g4Prev = g4Pos;
            
            %smooth out the motion
            for k = .20:.20:1
                %update the players position based on their movement
                pPos = pPrev + pVelo*k;
                
                %update the ghost position based on their movement
                g1Pos = g1Prev + g1Velo*k;
                g2Pos = g2Prev + g2Velo*k;
                g3Pos = g3Prev + g3Velo*k;
                g4Pos = g4Prev + g4Velo*k;
                
                %SCREEN
                
                %create temporary screen
                screenTemp = screen;
                
                %find index of tokens
                [tokenPosY, tokenPosX] = (find(maze == 2));
                tokenPosY = 18*tokenPosY - 28;
                tokenPosX = 18*tokenPosX - 28;
                %place tokens in the maze
                for j = 1:totalTokens
                    screenTemp(tokenPosY(j):(tokenPosY(j)+13), tokenPosX(j):(tokenPosX(j)+13), 1:3) = tokens;
                end
                
                %Display PacMan
                pacmanPos = 18*pPos - 28;
                screenTemp(pacmanPos(1):(pacmanPos(1)+13), pacmanPos(2):(pacmanPos(2)+13), 1:3) = pacman;
                
                %Display Ghosts
                %Blinky
                blinkyPos = 18*g1Pos - 28;
                screenTemp(blinkyPos(1):(blinkyPos(1)+13), blinkyPos(2):(blinkyPos(2)+13), 1:3) = blinky;
                
                %Inky
                inkyPos = 18*g2Pos - 28;
                screenTemp(inkyPos(1):(inkyPos(1)+13), inkyPos(2):(inkyPos(2)+13), 1:3) = inky;
                
                %Pinky
                pinkyPos = 18*g3Pos - 28;
                screenTemp(pinkyPos(1):(pinkyPos(1)+13), pinkyPos(2):(pinkyPos(2)+13), 1:3) = pinky;
                
                %Clyde
                clydePos = 18*g4Pos - 28;
                screenTemp(clydePos(1):(clydePos(1)+13), clydePos(2):(clydePos(2)+13), 1:3) = clyde;
                
                %display screen
                image(screenTemp)
                axis off
                
                %timestep for each movement
                pause(.05)
            end
            
            %player through the portal
            if pPos(1) == 11 && pPos(2)== 2
                pPos(2) = 18;
            elseif pPos(1) == 11 && pPos(2)== 18
                pPos(2) = 2;
            end
            
            %ghosts throught the portal
            %g1
            if g1Pos(1) == 11 && g1Pos(2)== 2
                g1Pos(2) = 18;
            elseif g1Pos(1) == 11 && g1Pos(2)== 18
                g1Pos(2) = 2;
            end
            %g2
            if g2Pos(1) == 11 && g2Pos(2)== 2
                g2Pos(2) = 18;
            elseif g2Pos(1) == 11 && g2Pos(2)== 18
                g2Pos(2) = 2;
            end
            %g3
            if g3Pos(1) == 11 && g3Pos(2)== 2
                g3Pos(2) = 18;
            elseif g3Pos(1) == 11 && g3Pos(2)== 18
                g3Pos(2) = 2;
            end
            %g4
            if g4Pos(1) == 11 && g4Pos(2)== 2
                g4Pos(2) = 18;
            elseif g4Pos(1) == 11 && g4Pos(2)== 18
                g4Pos(2) = 2;
            end
            
            %GAMEOVER
            
            %tells if player got killed
            if sum(pPos == g1Pos) == 2 || sum(pPos == g2Pos) == 2 ||...
                    sum(pPos == g3Pos) == 2 || sum(pPos == g4Pos) == 2
                GameOver
            end
            %if player skipped over
            if sum(pPos == g1Prev) == 2 || sum(pPos == g2Prev) == 2 ||...
                    sum(pPos == g3Prev) == 2 || sum(pPos == g4Prev) == 2
                GameOver
            end
            %if there are no tokens left the game ends
            if totalTokens == 0
                playerWin = true;
                GameOver
            end
            clc
        end
    end
    function GameOver
        %last little message for the player
        if playerWin == true
            msgbox('You Won!!!')
            uiwait
        else
            msgbox('You Lost!!!')
            uiwait
        end
        %clear everything
        clc;clear;close all
    end
end
