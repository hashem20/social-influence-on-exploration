classdef task_horizon < handle
%horizon task    
    properties
        %subject
        subjectID
        savename
        %task parameter
        sig_risk
        nBlocks
        ShowForced
        game
        %bandit
        ban_L5
        ban_R5
        ban_L10
        ban_R10
        
        sban_L5
        sban_R5
        sban_L10
        sban_R10
        
        cross
        crosscenter
        %window
        window
        bgColor
        screenHeight
        screenWidth
        screenCenter
        %font
        text
        textSize
        textColor
        textWrapat
        %Beep
        repetitions
        startCue
        waitForDeviceStart
        beepLengthSecs
        pahandle
        myBeep
        starttime
        startclock
        endtime
        instime
        mtime
        eye
        iStr
        iEv
    end
    methods
        function obj = task_horizon(window,savename,bgColour)
            obj.setwindow(window,bgColour);
            obj.savename = savename;
        end
        function setup(obj,subjectID,eye,textColour)            
            obj.subjectID = subjectID;
            rand('seed',GetSecs());
            obj.setTextParameters(40,textColour, 70);
            obj.makebandit;
            obj.makecross;
            obj.taskparameter;
            obj.setupsound;
            obj.eye = eye;
        end
        function setwindow(obj,window,bgColour)
%             screens = Screen('Screens');
%             screenNumber = max(screens);
            colorscale = 1;
            obj.bgColor = bgColour;
%             [window, windowRect] = PsychImaging('OpenWindow', screenNumber, obj.bgColor);
            obj.window = window;
            [sw, sh] = Screen('WindowSize', window);
            windowRect = [0 0 sw sh];
            obj.screenWidth = sw;
            obj.screenHeight = sh;
            [xCenter, yCenter] = RectCenter(windowRect);
            obj.screenCenter = [xCenter, yCenter];
        end
        function makebandit(obj)
            window = obj.window;
            w = 80;
            h = 60;
            w_lever = 80;
            h_lever = 60;
            
            w2 = 40;
            h2 = 30;
            w_lever2 = 40;
            h_lever2 = 30;
            
            colorscale = 1;
%             color_highlight = [ 55    85    55 ]/255;
            horizon = 5;
%             color_l = [ 71    71   101 ]/255;
%             color_r = [91    71    41]/255;
            
            color_l = [ 28 134 238 ]/255; 
            color_r = [ 138 43 226 ]/255;
            color_highlight = [ 0 150 0 ]/255;
            color_highlight2 = [255 193 37] /255;



            ban_L5 = bandit(window,obj.textSize,obj.textColor,obj.textWrapat, 30, 5);
            ban_L5.setup(w,h,w_lever,h_lever,horizon,color_l,color_highlight,'left');
            ban_R5 = bandit(window,obj.textSize,obj.textColor,obj.textWrapat, 30, 5);
            ban_R5.setup(w,h,w_lever,h_lever,horizon,color_r,color_highlight,'right');
            
          
            textSize2 = 20;
            
            sban_L5 = bandit(window,textSize2,obj.textColor,obj.textWrapat, 15, 2);
            sban_L5.setup(w2,h2,w_lever2,h_lever2,horizon,color_l,color_highlight2,'left');
            sban_R5 = bandit(window,textSize2,obj.textColor,obj.textWrapat, 15, 2);
            sban_R5.setup(w2,h2,w_lever2,h_lever2,horizon,color_r,color_highlight2,'right');
            
            horizon = 10;
            ban_L10 = bandit(window,obj.textSize,obj.textColor,obj.textWrapat, 30, 5);
            ban_L10.setup(w,h,w_lever,h_lever,horizon,color_l,color_highlight,'left');
            ban_R10 = bandit(window,obj.textSize,obj.textColor,obj.textWrapat, 30, 5);
            ban_R10.setup(w,h,w_lever,h_lever,horizon,color_r,color_highlight,'right');
            
            sban_L10 = bandit(window,textSize2,obj.textColor,obj.textWrapat, 15, 2);
            sban_L10.setup(w2,h2,w_lever2,h_lever2,horizon,color_l,color_highlight2,'left');
            sban_R10 = bandit(window,textSize2,obj.textColor,obj.textWrapat, 15, 2);
            sban_R10.setup(w2,h2,w_lever2,h_lever2,horizon,color_r,color_highlight2,'right');
            
            sw = obj.screenWidth;
            sh = obj.screenHeight;
            top = 240;
            bgaplen = 80;
            
            top2 = 290;
            bgaplen2 = 40;
            
            ban_L5.settppos(sw/2 - bgaplen,top);
            ban_L10.settppos(sw/2 - bgaplen,top);
            ban_R5.settppos(sw/2 + bgaplen,top);
            ban_R10.settppos(sw/2 + bgaplen,top);
            
            sban_L5.settppos((sw-250) - bgaplen2,top2);
            sban_R5.settppos((sw-250) + bgaplen2,top2);
            sban_L10.settppos((sw-250) - bgaplen2,top2);
            sban_R10.settppos((sw-250) + bgaplen2,top2);
                       
            obj.ban_L5 = ban_L5;
            obj.ban_L10 = ban_L10;
            obj.ban_R5 = ban_R5;
            obj.ban_R10 = ban_R10;
            
            obj.sban_L5 = sban_L5;
            obj.sban_R5 = sban_R5;
            obj.sban_L10 = sban_L10;
            obj.sban_R10 = sban_R10;
            
        end
        function taskparameter(obj)
            obj.sig_risk = 8;
            obj.nBlocks = 4;
            obj.ShowForced = 4;
            % \mu
            var(1).x = [40 60];            % two options for mean of reward of one bandit
            var(1).type = 2;
            % main bandit number
            var(2).x = [1 2];
            var(2).type = 2;
            % \delta \mu
%             var(3).x = [-30 -20 -12 -8 -4 4 8 12 20 30];
            var(3).x = [-20 -12 -8 -4 4 8 12 20];      % the differemce betweem the means
            var(3).type = 1;
            % game length
            var(4).x = [5 10];
            var(4).type = 1;
            % ambiguity condition
            var(5).x = [1 2 2 3];
            var(5).type = 1;
            [var2, T, N] = counterBalancer(var, 1);
            %test_counterBalancing(var);
            mainBanMean = var2(1).x_cb;
            mainBan = var2(2).x_cb;
            deltaMu = var2(3).x_cb;
            gameLength = var2(4).x_cb;
            ambCond = var2(5).x_cb;
            for j = 1:T
                game(j).gameLength = gameLength(j);
                switch ambCond(j)
                    case 1        
                        r = randi(4);
                        switch r
                            case 1
                                nForced = [1 1 1 2];
                            case 2
                                nForced = [1 1 2 1];
                            case 3
                                nForced = [1 2 1 1];
                            case 4
                                nForced = [2 1 1 1];
                        end
                    case 2
                        r = randi(6);
                        switch r
                            case 1
                                nForced = [1 1 2 2];
                            case 2
                                nForced = [1 2 1 2];
                            case 3
                                nForced = [2 1 1 2];
                            case 4
                                nForced = [2 1 2 1];
                            case 5
                                nForced = [2 2 1 1];
                            case 6
                                nForced = [1 2 2 1];
                        end
                    case 3
                        r = randi(4);
                        switch r
                            case 1
                                nForced = [2 2 2 1];
                            case 2
                                nForced = [2 2 1 2];
                            case 3
                                nForced = [2 1 2 2];
                            case 4
                                nForced = [1 2 2 2];
                        end
                end
                game(j).nforced = nForced;
                game(j).forced = nForced;
                game(j).forced(5:gameLength(j)) = 0;
                game(j).nfree = [gameLength(j) - 4];
                if mainBan(j) == 1
                    mu(1) = mainBanMean(j);
                    mu(2) = [mainBanMean(j) + deltaMu(j)];
                elseif mainBan(j) == 2
                    mu(2) = mainBanMean(j);
                    mu(1) = [mainBanMean(j) + deltaMu(j)];
                end
                sig_risk = obj.sig_risk;
                game(j).mean = [mu(1); mu(2)];
                game(j).rewards = ...
                    [(round(randn(gameLength(j),1)*sig_risk + mu(1)))'; ...
                    (round(randn(gameLength(j),1)*sig_risk + mu(2)))'];
                ind99 = game(j).rewards > 99;
                game(j).rewards(ind99) = 99;
                ind01 = game(j).rewards < 1;
                game(j).rewards(ind01) = 1;
                
                game(j).srewards = ...
                    [(round(randn(gameLength(j),1)*sig_risk + mu(1)))'; ...
                    (round(randn(gameLength(j),1)*sig_risk + mu(2)))'];
                sind99 = game(j).srewards > 99;
                game(j).srewards(sind99) = 99;
                sind01 = game(j).srewards < 1;
                game(j).srewards(sind01) = 1;
                
                game(j).gID = j;
                
                tgame(j) = game(j);
                tgame(j).rewards = ...
                    [(round(randn(gameLength(j),1)*sig_risk + mu(1)))'; ...
                    (round(randn(gameLength(j),1)*sig_risk + mu(2)))'];
                ind99 = tgame(j).rewards > 99;
                tgame(j).rewards(ind99) = 99;
                ind01 = tgame(j).rewards < 1;
                tgame(j).rewards(ind01) = 1;
                
                tgame(j) = game(j);
                tgame(j).srewards = ...
                    [(round(randn(gameLength(j),1)*sig_risk + mu(1)))'; ...
                    (round(randn(gameLength(j),1)*sig_risk + mu(2)))'];
                sind99 = tgame(j).srewards > 99;
                tgame(j).srewards(sind99) = 99;
                sind01 = tgame(j).srewards < 1;
                tgame(j).srewards(sind01) = 1;
                
                tgame(j).gID = j;
            end
            % repeat games
            gd = game;
            % resample rewards on later trials - so only the first four are
            % repeated
            for j = 1:length(gd)
                mu = gd(j).mean;
                gd(j).rewards(:,5:end) = ...
                    [(round(randn(gd(j).nfree,1)*sig_risk + mu(1)))'; ...
                    (round(randn(gd(j).nfree,1)*sig_risk + mu(2)))'];
                ind99 = gd(j).rewards > 99;
                gd(j).rewards(ind99) = 99;
                ind01 = gd(j).rewards < 1;
                gd(j).rewards(ind01) = 1;
                
                gd(j).srewards(:,5:end) = ...
                    [(round(randn(gd(j).nfree,1)*sig_risk + mu(1)))'; ...
                    (round(randn(gd(j).nfree,1)*sig_risk + mu(2)))'];
                sind99 = gd(j).srewards > 99;
                gd(j).srewards(sind99) = 99;
                sind01 = gd(j).srewards < 1;
                gd(j).srewards(sind01) = 1;
                
            end
            % duplicate games
            game = [game gd];   
            
            gd = tgame;
            for j = 1:length(gd)
                mu = gd(j).mean;
                gd(j).rewards(:,5:end) = ...
                    [(round(randn(gd(j).nfree,1)*sig_risk + mu(1)))'; ...
                    (round(randn(gd(j).nfree,1)*sig_risk + mu(2)))'];
                ind99 = gd(j).rewards > 99;
                gd(j).rewards(ind99) = 99;
                ind01 = gd(j).rewards < 1;
                gd(j).rewards(ind01) = 1;
                
                gd(j).srewards(:,5:end) = ...
                    [(round(randn(gd(j).nfree,1)*sig_risk + mu(1)))'; ...
                    (round(randn(gd(j).nfree,1)*sig_risk + mu(2)))'];
                sind99 = gd(j).srewards > 99;
                gd(j).srewards(sind99) = 99;
                sind01 = gd(j).srewards < 1;
                gd(j).srewards(sind01) = 1;
                
            end
            tgame = [tgame gd];
            
            flag = true;
            while flag
                % scramble games
                game = game(randperm(length(game)));
                % check to make sure whether no repeats within N trials of each other
                N = 5;
                gp = zeros(N, length(game));
                gID = [game.gID];
                for i = 1:N
                    gp(i,1:length(gID)-i) = gID(i+1:length(gID));
                end
                matchID = sum(repmat(gID, [N 1]) == gp);
                flag = sum(matchID) > 0;
            end
            obj.game = game;
            
            game = tgame;
            flag = true;
            while flag
                % scramble games
                game = game(randperm(length(game)));
                % check to make sure whether no repeats within N trials of each other
                N = 5;
                gp = zeros(N, length(game));
                gID = [game.gID];
                for i = 1:N
                    gp(i,1:length(gID)-i) = gID(i+1:length(gID));
                end
                matchID = sum(repmat(gID, [N 1]) == gp);
                flag = sum(matchID) > 0;
            end
            
            obj.game = [obj.game game];
            for i = 1:size(obj.game,2)
                obj.game(i).smallbanditchoice = randi(2);
            end
        end
        function setTextParameters(obj, textSize, textColor, textWrapat)
            Screen('TextFont', obj.window, 'Arial');
            Screen('TextSize', obj.window, textSize);
            Screen('TextStyle', obj.window, 1);
            obj.textSize = textSize;
            obj.textColor = textColor;
            obj.textWrapat = textWrapat;
            obj.text.textSize = textSize;
            obj.text.textWrapat = textWrapat;
            obj.text.textColor = textColor;
            obj.text.textFont = 'Arial';
        end
        function run(obj, window)
            obj.starttime = datestr(now);
            obj.startclock = clock;
%             ban_L5 = obj.ban_L5;
%             ban_L10 = obj.ban_L10;
%             ban_R5 = obj.ban_R5;
%             ban_R10 = obj.ban_R10;
            sw = obj.screenWidth;
            sh = obj.screenHeight;
            
            top = 240;
            bgaplen = 80;
            
            top2 = 290;
            bgaplen2 = 40;
%             
            obj.ban_L5.settppos(sw/2 - bgaplen,top);
            obj.ban_L10.settppos(sw/2 - bgaplen,top);
            obj.ban_R5.settppos(sw/2 + bgaplen,top);
            obj.ban_R10.settppos(sw/2 + bgaplen,top);  
            
            obj.sban_L5.settppos((sw-250) - bgaplen2,top2);
            obj.sban_R5.settppos((sw-250) + bgaplen2,top2);
            obj.sban_L10.settppos((sw-250) - bgaplen2,top2);
            obj.sban_R10.settppos((sw-250) + bgaplen2,top2);

            obj.cross.center = [obj.screenCenter(1) obj.ban_L5.top + obj.ban_L5.h*5/2];
            obj.eye.marker('taskinstructionsstart');
            obj.instructions;
            obj.eye.marker('taskinstructionsend');
            top = 240;
            bgaplen = 80;
            
            top2 = 290;
            bgaplen2 = 40;
            
            obj.ban_L5.settppos(sw/2 - bgaplen,top);
            obj.ban_L10.settppos(sw/2 - bgaplen,top);
            obj.ban_R5.settppos(sw/2 + bgaplen,top);
            obj.ban_R10.settppos(sw/2 + bgaplen,top);  
            
            obj.sban_L5.settppos((sw-250) - bgaplen2,top2);
            obj.sban_R5.settppos((sw-250) + bgaplen2,top2);
            obj.sban_L10.settppos((sw-250) - bgaplen2,top2);
            obj.sban_R10.settppos((sw-250) + bgaplen2,top2);
            
            obj.cross.center = [obj.screenCenter(1) obj.ban_L5.top + obj.ban_L5.h*5/2];
            obj.instime = etime(clock,obj.startclock);
            obj.startclock = clock;

            nBlocks = obj.nBlocks;
            gameLength = length(obj.game);
            
            gameStandard = 160;
            
            gamesPerBlock = gameStandard/nBlocks;
            finishtrial = gameStandard * 75/100 + 1;
            reward = zeros(gameLength,1);
            sreward = zeros (1,1);
            
            g = 1
            correct = 0;
            nchoice = 0;
            obj.save;
            startblock = 1;
            b = 0;
            totalpoints = 0;
            flag = 0;
            mtime = etime(clock,obj.startclock)/60;
            while (b < nBlocks || correct < finishtrial || flag) && g <= gameStandard && mtime < 40
                if g == startblock
                    Screen('TextSize',obj.window,obj.text.textSize);
                    b = b + 1;
                    obj.talk(['Beginning block ' num2str(b) '\n\nPress anykey to begin']);
                    Screen('Flip',obj.window);
                    KbStrokeWait;
                    obj.eye.marker('startblock');
                    endblock = startblock + gamesPerBlock - 1;
                    flag = 1;
                end
                obj.eye.marker('startgame');
                obj.run_game(g, window);
                obj.eye.marker('endgame');
                
                reward(g) = mean(obj.game(g).reward);   
                sreward (g) = mean(obj.game(g).sreward);
                
                totalpoints = totalpoints + sum(obj.game(g).reward);
                nchoice = nchoice + obj.game(g).nfree;
                correct = correct + obj.game(g).accuracy;
                if g == endblock
                    obj.eye.marker('endblock');
%                     obj.talk(['Well done! You averaged ' num2str(round(mean(reward(index)))) 'points!']);
%                     obj.talk(['Ending block ' num2str(b) '. You have earned ' num2str(round(100*correct/max(correct,finishtrial),1)) '% of the points in order to finish the task, congratulations!\n\nPress space to continue']);
                    obj.talk(['Ending block ' num2str(b) '. You have finished ' num2str(b*25) '% of the task.\nYou have earned a total point of ' num2str(totalpoints) '!' '\n\nPress space to continue']);
                    Screen('Flip',obj.window);
                    Pressed = 0;
                    while ~Pressed
                        [Pressed, t1, tKeyNum, t2] = KbCheck;
                        tKeyNum = find(tKeyNum,1);
                        if (tKeyNum ~= KbName('space'))
                            Pressed = 0;
                        end
                    end
                    WaitSecs(0.1);
                    startblock = g + 1;
                    flag = 0;
                end
                g = g + 1;
                mtime = etime(clock,obj.startclock)/60;
            end % I changed gamelength to gamestandard to eliminate the punishment
            obj.mtime = mtime;
            if 0%correct < finishtrial
                obj.talk('Times up! \n\nPress anykey to continue.')
               Screen('Flip',obj.window);
               KbStrokeWait();
            else%' num2str(round(40 - mtime,1)) 'minutes  early!
            obj.talk(['Congratulations! You have finished the task!\n\nPress anykey to continue.']);
            Screen('Flip',obj.window);
            KbStrokeWait();
            end
%             money = round(mean(reward) * 3);
            PsychPortAudio('Stop', obj.pahandle);
            PsychPortAudio('Close', obj.pahandle);
            obj.save;
%             KbStrokeWait();
        end
        function run_game(obj,g, window)
            glen = obj.game(g).gameLength;
            switch glen
                case 5
                    ban_L = obj.ban_L5;
                    ban_R = obj.ban_R5;
                    
                    sban_L = obj.sban_L5;
                    sban_R = obj.sban_R5;
                    
                case 10
                    ban_L = obj.ban_L10;
                    ban_R = obj.ban_R10;
                    
                    sban_L = obj.sban_L10;
                    sban_R = obj.sban_R10;
                    
            end
            ban_L.flush;
            ban_R.flush;
            
            sban_L.flush;
            sban_R.flush;
            
            obj.cross.draw;
            Screen('Flip',obj.window);
            obj.eye.marker('startcross');
            WaitSecs(3.0);
            obj.eye.marker('endcross');
            for i = 1:glen
                forced = obj.game(g).forced(i);
                rL = obj.game(g).rewards(1,i);
                rR = obj.game(g).rewards(2,i);
                
                srL = obj.game(g).srewards(1,i);
                srR = obj.game(g).srewards(2,i);
                
                if i < obj.ShowForced
                    situation = 1;
                elseif i == obj.ShowForced
                    situation = 2;
                else
                    situation = 0;
                end
                obj.eye.marker('starttrial');
                socialchoice = obj.game(g).smallbanditchoice;
                [key,reward,sreward,timeBanditOn,timePressKey,timeRewardOn,deltatimePressKey] = obj.run_trial(i,rL,rR,srL,srR,forced,ban_L,ban_R,sban_L,sban_R,socialchoice,window,situation);
                
                if i == glen
                WaitSecs(1);
                end
                
                obj.game(g).key(i) = key;
                
                obj.game(g).reward(i) = reward;
                obj.game(g).sreward(i) = sreward;
                
                obj.game(g).timeBanditOn(i) = timeBanditOn;
                obj.game(g).timePressKey(i) = timePressKey;
                obj.game(g).timeRewardOn(i) = timeRewardOn;
                obj.game(g).deltatimePressKey(i) = deltatimePressKey;
                obj.game(g).RT(i) = timePressKey - timeBanditOn;
                obj.game(g).correct(i) = reward == max(rL,rR);
                obj.eye.marker('endtrial');
                
            end
            obj.game(g).correcttot = sum(obj.game(g).correct(obj.ShowForced + 1:end));
            obj.game(g).accuracy = obj.game(g).correcttot/ obj.game(g).nfree;
            obj.save;
        end
        function [key,reward,sreward,timeBanditOn,timePressKey,timeRewardOn,deltatimePressKey] = run_trial(obj,ii,rL,rR,srL,srR,forced,ban_L,ban_R,sban_L,sban_R,socialchoice,window,situation)
            
            if (situation && ~forced)
                situation = 0;
            end
                leftkey = KbName('leftarrow');
                rightkey = KbName('rightarrow');
           if ~situation 
                switch forced
                    case 1
                        ban_L.draw(0);
                        ban_R.draw(0,'forbid');
                        
                        sban_L.draw(1);
                        sban_R.draw(0,'forbid');
                        
                    case 2
                        ban_L.draw(0,'forbid');
                        ban_R.draw(0);
                        
                        sban_L.draw(0,'forbid');
                        sban_R.draw(1);
                        
                    case 0
                        ban_L.draw(0);
                        ban_R.draw(0);
                        
                    textSize2 = 20;
                    OldtextSize = Screen('TextSize', window, textSize2);
           
                    if ii == 5
                    switch socialchoice
                        case 1
                            
                    sban_L.draw(1);
                    sban_R.draw(0,'forbid');
                    
                        case 2
                            
                    sban_L.draw(0,'forbid');
                    sban_R.draw(1);
                    
                        end
                    else
                        switch socialchoice
                        case 1
                            
                    sban_L.draw(0,'forbid');
                    sban_R.draw(0,'forbid');
                    
                        case 2
                            
                    sban_L.draw(0,'forbid');
                    sban_R.draw(0,'forbid');
                    
                        end
                    end
                    Screen('TextSize', window, OldtextSize);
                        
                end
                obj.gocue;
                timeBanditOn = Screen('Flip',obj.window);
                obj.eye.marker('banditon');
                 switch forced
                    case 1 % forced left
                        [KeyNum, timePressKey, deltatimePressKey] = obj.waitForInput([leftkey], GetSecs +Inf);
                    case 2 % forced right
                        [KeyNum, timePressKey, deltatimePressKey] = obj.waitForInput([rightkey], GetSecs +Inf);
                    case 0 % free
                        [KeyNum, timePressKey, deltatimePressKey] = obj.waitForInput([leftkey,rightkey], GetSecs +Inf);
                end
            else
                timeBanditOn = 0;
                timePressKey = 0;
                deltatimePressKey = 0;
                switch forced
                    case 1 % forced left
                        KeyNum = leftkey;
                    case 2 % forced right
                        KeyNum = rightkey;
                end
            end
            switch KeyNum
                case leftkey % left
                    reward = rL;
                    sreward = srL;
                    
                    ban_L.addreward(num2str(reward));
                    ban_R.addreward('XX');
                    
                    
                    if ~situation
                        ban_L.draw(1,'forbid');
                        ban_R.draw(0,'forbid');
                        
                    textSize2 = 20;
                    OldtextSize = Screen('TextSize', obj.window, textSize2);    
                    
                    if ii==5
                    if socialchoice == 1
                        
                        sban_L.addreward(num2str(sreward));
                        sban_R.addreward('XX');
                        
                        sban_L.draw(1,'forbid');
                        sban_R.draw(0,'forbid');
                  
                    else
                        sban_L.addreward('XX');
                        sban_R.addreward(num2str(sreward));
                        
                        sban_L.draw(0,'forbid');
                        sban_R.draw(1,'forbid');
                        
                    end    
                    end
                    
                    Screen('TextSize', obj.window, OldtextSize); 
                    
                    else
                        
                        sban_L.addreward(num2str(reward));
                        sban_R.addreward('XX');
                    end
                    key = 1;
                case rightkey % right
                    reward = rR;
                    sreward = srR;
                    
                    ban_L.addreward('XX');
                    ban_R.addreward(num2str(reward));
                    
                    if ~situation
                        ban_L.draw(0,'forbid');
                        ban_R.draw(1,'forbid');
                        
                     textSize2 = 20;
                     OldtextSize = Screen('TextSize', obj.window, textSize2);   
                     
                     
                     if ii==5
                     if socialchoice == 1
                        
                        sban_L.addreward(num2str(sreward));
                        sban_R.addreward('XX');
                        
                        sban_L.draw(1,'forbid');
                        sban_R.draw(0,'forbid');
                  
                    else
                        sban_L.addreward('XX');
                        sban_R.addreward(num2str(sreward));
                        
                        sban_L.draw(0,'forbid');
                        sban_R.draw(1,'forbid');
                        
                     end    
                     end
                     Screen('TextSize', obj.window, OldtextSize); 
                    
                      else
                        
                        sban_L.addreward('XX');
                        sban_R.addreward(num2str(reward));                     
                    end
                    key = 2;
            end
            switch situation
                case 0 % free choice
                    obj.gocue;
                    textSize2 = 20;
                    OldtextSize = Screen('TextSize', window, textSize2);
           
                    if ii ~= 5
                     tstring = 'forbid';
                    switch socialchoice
                        
                        case 1
                            
                    sban_L.draw(0,tstring);
                    sban_R.draw(0,tstring);
                    
                        case 2
                            
                    sban_L.draw(0,tstring);
                    sban_R.draw(0,tstring);
                    end
                    end
                    
                    Screen('TextSize', window, OldtextSize);
                    timeRewardOn = Screen('Flip', obj.window);
                    obj.eye.marker('rewardon');
                    WaitSecs(0.3);
                case 1 % exampleplay
                    timeRewardOn = 0;
                case 2 %last one of the example play
                    ban_L.draw(0,'forbid');
                    ban_R.draw(0,'forbid');
                    
                    textSize2 = 20;
                    OldtextSize = Screen('TextSize', window, textSize2);
           
                    switch socialchoice
                        
                        case 1
                            
                    sban_L.draw(1);
                    sban_R.draw(0,'forbid');
                    
                        case 2
                            
                    sban_L.draw(0,'forbid');
                    sban_R.draw(1);
                    
                    end
                    
                    Screen('TextSize', window, OldtextSize);
%                     obj.cross.draw;
                    timeRewardOn = Screen('Flip', obj.window);
                    obj.eye.marker('exampleplayon');
                    WaitSecs(3.0);
                    obj.eye.marker('beep');
                    obj.Beep;
                    obj.eye.marker('gocue');
                    obj.gocue;
            end
        end
        function [KeyNum, when, deltawhen] = waitForInput(obj, validKeys, timeOut)
            % wait for a keypress for TimeOut seconds
            Pressed = 0;
            while ~Pressed && (GetSecs < timeOut)
                [Pressed, when, KeyNum, deltawhen] = KbCheck;
                KeyNum = find(KeyNum,1);
                if ~ismember(KeyNum,validKeys)
                    Pressed = 0;
                end
            end
            obj.eye.marker('keypress');
            if Pressed == 0
                KeyNum = [];
                when = [];
            end
        end
        function talk(obj, str, tp, colorfont,winRect)
            if exist('colorfont') == 0 || length(colorfont) == 0
                colorfont = obj.textColor;
            end
            if exist('winRect') == 0
                winRect = [0 0 obj.screenWidth obj.screenHeight];
            end
            if exist('tp') == 0 || length(tp) == 0
                DrawFormattedText(obj.window, str,'center','center', colorfont, obj.textWrapat, 0,0,1,0, winRect);
            else
                DrawFormattedText(obj.window, str, tp{1},tp{2}, colorfont, obj.textWrapat, 0,0,1,0, winRect);
            end
        end
        function save(obj)
            subjectID   = obj.subjectID;
            game        = obj.game;
            starttime = obj.starttime;
            obj.endtime = datestr(now);
            endtime = obj.endtime;
            instime = obj.instime;
            tasktime = obj.mtime;
            save(obj.savename, 'subjectID', 'game', 'starttime', 'endtime','instime','tasktime');  
        end
        function makecross(obj)
            lineWidthPix = 4;
            fixCrossDimPix = 20;
            colorscale = 1;
%             color = [ 97    67    67 ]/255;
            color  = [1 1 1];
            top = obj.ban_L5.top;
            h = obj.ban_L5.h;
            sw = obj.screenCenter(1);
            crosscenter = [sw top + h*5/2];
            smooth = 0;
            cross = fixedcross(obj.window);
            cross.setup(fixCrossDimPix, lineWidthPix, color, crosscenter, smooth);
            obj.cross = cross;
            obj.crosscenter = crosscenter;
        end
        function gocue(obj)
            colorscale = 1;
%             color = [ 97    67    67 ]/255;
            color = [0 204 0] / 255;
            sw = obj.screenCenter(1);
            top = obj.ban_L5.top;
            w = obj.ban_L5.w;
            h = obj.ban_L5.h;
            crosscenter = [sw top + h*5/2];
            x = crosscenter(1);
            y = crosscenter(2);
            crosscenter = [x - w, y - h/2, x + w,y + h/2];    
            Screen('Textsize',obj.window,obj.textSize);
            obj.talk('GO',{'center',y-h/2},color,crosscenter); 
            Screen('Textsize',obj.window,obj.textSize);
        end
        function setupsound(obj)
            InitializePsychSound(1);% Initialize Sounddriver
            nrchannels = 2;% Number of channels and Frequency of the sound
            freq = 48000;
            obj.repetitions = 1;% How many times to we wish to play the sound
            obj.beepLengthSecs = 0.2;% Length of the beep
            beepPauseTime = 1;% Length of the pause between beeps
            obj.startCue = 0;% Start immediately (0 = immediately)
            obj.waitForDeviceStart = 1;
            % Open Psych-Audio port, with the follow arguements
            % (1) [] = default sound device
            % (2) 1 = sound playback only
            % (3) 1 = default level of latency
            % (4) Requested frequency in samples per second
            % (5) 2 = stereo putput
            obj.pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);
            % Set the volume to half for this demo
            PsychPortAudio('Volume', obj.pahandle, 0.5);
            obj.myBeep = MakeBeep(500, obj.beepLengthSecs, freq);
        end
        function Beep(obj)
            myBeep = obj.myBeep;
            % Fill the audio playback buffer with the audio data, doubled for stereo
            % presentation
            PsychPortAudio('FillBuffer', obj.pahandle, [myBeep; myBeep]);
            % Start audio playback
            PsychPortAudio('Start', obj.pahandle, obj.repetitions, obj.startCue, obj.waitForDeviceStart);
%             WaitSecs(obj.beepLengthSecs);
        end
        function instructions(obj)
            obj.instructionList;
            iStr = obj.iStr;
            ev = obj.iEv;
            endFlag = false;
            count = 1;
            
                ban_L10 = obj.ban_L10;
                ban_R10 = obj.ban_R10;
                ban_L5 = obj.ban_L5;
                ban_R5 = obj.ban_R5;
              
                sban_L5 = obj.sban_L5;
                sban_R5 = obj.sban_R5;
                sban_L10 = obj.sban_L10;
                sban_R10 = obj.sban_R10;
            
            while ~endFlag
                [A, B] = Screen('WindowSize', obj.window);
                
                DrawFormattedText(obj.window, ...
                    ['        Page ' num2str(count) ' of ' num2str(length(iStr))], ...
                    [],[B*0.91], [1 1 1], obj.textWrapat);
                
                ef = false;
                switch ev{count}
                    
                    case 'blank' % blank screen
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'bandits' % bandits example
                        
                        ban_L10.flush;
                        ban_R10.flush;
                  
                        ban_L10.draw(0);
                        ban_R10.draw(0);
                 
                        obj.talkAndFlip(iStr{count});
                        
                    case 'realBandits' % bandits example
                        
                        obj.talkAndFlip(iStr{count});
             
                    case 'bandits_lever'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        ban_L10.draw(1);
                        ban_R10.draw(0);
               
                        obj.talkAndFlip(iStr{count});
                        
                    case 'L_77'
                        
                        ban_L10.flush;
                        ban_R10.flush;                     
                        ban_L10.addreward('77');
                        
                        ban_L10.draw(1);
                        ban_R10.draw(0);
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'L_77beep'
                        
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        ban_L10.addreward('77');
                        
                        ban_L10.draw(1);
                        ban_R10.draw(0);
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'L_85beep'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        ban_L10.addreward('85');
                        
                        ban_L10.draw(1);
                        ban_R10.draw(0);
                        
                        obj.talkAndFlip(iStr{count});
                     
                    case 'L_20beep'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        ban_L10.addreward('20');
                        
                        ban_L10.draw(1);
                        ban_R10.draw(0);
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'R_52'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        ban_R10.addreward('52');
                        
                        ban_L10.draw(0);
                        ban_R10.draw(1);
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'R_56'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        ban_R10.addreward('52');
                        ban_R10.addreward('56');
                        
                        ban_L10.draw(0);
                        ban_R10.draw(1);
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'R_45'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        ban_R10.addreward('52');
                        ban_R10.addreward('56');
                        ban_R10.addreward('45');
                        
                        ban_L10.draw(0);
                        ban_R10.draw(1);
                        
                        obj.talkAndFlip(iStr{count});

                        
                    case 'R_all'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        ban_R10.addreward('52');
                        ban_R10.addreward('56');
                        ban_R10.addreward('45');
                        ban_R10.addreward('39');
                        ban_R10.addreward('51');
                        ban_R10.addreward('50');
                        ban_R10.addreward('43');
                        ban_R10.addreward('60');
                        ban_R10.addreward('55');
                        ban_R10.addreward('45');
                        
                        ban_L10.draw(0);
                        ban_R10.draw(1);
                        
                        obj.talkAndFlip(iStr{count});
                      
                    case 'bandits5' 
                        
                        ban_L5.flush;
                        ban_R5.flush;
                        
                        ban_L5.draw(0);
                        ban_R5.draw(0);
                     
                        obj.talkAndFlip(iStr{count});
                        
                    case 'forcedL1'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        ban_L10.draw(0);
                        ban_R10.draw(0,'forbid');
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'forcedR2'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        ban_L10.addreward('77');
                        ban_R10.addreward('XX');
                        
                        ban_L10.draw(0,'forbid');
                        ban_R10.draw(0);
                        
                        obj.talkAndFlip(iStr{count});
                        
                    case 'cross'
                        
                        obj.cross.draw;
                        obj.talkAndFlip(iStr{count});
                    
                    case 'sbandit5'
                        
                        ban_L5.flush;
                        ban_R5.flush;
                        
                        sban_L5.flush;
                        sban_R5.flush;
                        
                        
                        sban_L5.addreward('77');
                        sban_L5.addreward('XX');
                        sban_L5.addreward('65');
                        sban_L5.addreward('67');
                        
                        sban_R5.addreward('XX');
                        sban_R5.addreward('52');
                        sban_R5.addreward('XX');
                        sban_R5.addreward('XX');
                        
                        
                        ban_L5.addreward('77');
                        ban_L5.addreward('XX');
                        ban_L5.addreward('65');
                        ban_L5.addreward('67');
                        
                        ban_R5.addreward('XX');
                        ban_R5.addreward('52');
                        ban_R5.addreward('XX');
                        ban_R5.addreward('XX');                     


                        ban_L5.draw(0);
                        ban_R5.draw(0);
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                     
                        sban_L5.draw(1);
                        sban_R5.draw(0, 'forbid');
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.talkAndFlip(iStr{count});    
                        
                    case 'sbandit10'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        sban_L10.flush;
                        sban_R10.flush;
                       
                        sban_L10.addreward('77');
                        sban_L10.addreward('XX');
                        sban_L10.addreward('65');
                        sban_L10.addreward('67');
                        
                        sban_R10.addreward('XX');
                        sban_R10.addreward('52');
                        sban_R10.addreward('XX');
                        sban_R10.addreward('XX');
                       
                        ban_L10.addreward('77');
                        ban_L10.addreward('XX');
                        ban_L10.addreward('65');
                        ban_L10.addreward('67');
                        
                        ban_R10.addreward('XX');
                        ban_R10.addreward('52');
                        ban_R10.addreward('XX');
                        ban_R10.addreward('XX');                     

                        ban_L10.draw(0);
                        ban_R10.draw(0);
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                        
                        sban_L10.draw(0, 'forbid');
                        sban_R10.draw(1);
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.talkAndFlip(iStr{count});   
                        
                    case 'sbandit10aftersame'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        sban_L10.flush;
                        sban_R10.flush;
                       
                        sban_L10.addreward('77');
                        sban_L10.addreward('XX');
                        sban_L10.addreward('65');
                        sban_L10.addreward('67');
                        sban_L10.addreward('XX');
                        
                        sban_R10.addreward('XX');
                        sban_R10.addreward('52');
                        sban_R10.addreward('XX');
                        sban_R10.addreward('XX');
                        sban_R10.addreward('68');
                       
                        ban_L10.addreward('77');
                        ban_L10.addreward('XX');
                        ban_L10.addreward('65');
                        ban_L10.addreward('67');
                        ban_L10.addreward('XX');
                        
                        ban_R10.addreward('XX');
                        ban_R10.addreward('52');
                        ban_R10.addreward('XX');
                        ban_R10.addreward('XX'); 
                        ban_R10.addreward('75'); 

                        ban_L10.draw(0,'forbid');
                        ban_R10.draw(0,'forbid');
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                        
                        sban_L10.draw(0,'forbid');
                        sban_R10.draw(0,'forbid');
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.talkAndFlip(iStr{count});    
                        
                    case 'sbandit10afterdifferent'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        sban_L10.flush;
                        sban_R10.flush;
                       
                        sban_L10.addreward('77');
                        sban_L10.addreward('XX');
                        sban_L10.addreward('65');
                        sban_L10.addreward('XX');
                        sban_L10.addreward('XX');
                        
                        sban_R10.addreward('XX');
                        sban_R10.addreward('52');
                        sban_R10.addreward('XX');
                        sban_R10.addreward('XX');
                        sban_R10.addreward('68');
                       
                        ban_L10.addreward('77');
                        ban_L10.addreward('XX');
                        ban_L10.addreward('65');
                        ban_L10.addreward('67');
                        ban_L10.addreward('60');
                        
                        ban_R10.addreward('XX');
                        ban_R10.addreward('52');
                        ban_R10.addreward('XX');
                        ban_R10.addreward('XX');
                        ban_R10.addreward('XX');

                        ban_L10.draw(0,'forbid');
                        ban_R10.draw(0,'forbid');
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                        
                        sban_L10.draw(0,'forbid');
                        sban_R10.draw(0,'forbid');
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.talkAndFlip(iStr{count});        
                
                    case 'sbandit5aftersame'
                        
                        ban_L5.flush;
                        ban_R5.flush;
                        
                        sban_L5.flush;
                        sban_R5.flush;
                        
                        
                        sban_L5.addreward('77');
                        sban_L5.addreward('XX');
                        sban_L5.addreward('65');
                        sban_L5.addreward('67');
                        sban_L5.addreward('70');
                        
                        sban_R5.addreward('XX');
                        sban_R5.addreward('52');
                        sban_R5.addreward('XX');
                        sban_R5.addreward('XX');
                        sban_R5.addreward('XX');
                        
                        
                        ban_L5.addreward('77');
                        ban_L5.addreward('XX');
                        ban_L5.addreward('65');
                        ban_L5.addreward('67');
                        ban_L5.addreward('72');
                        
                        ban_R5.addreward('XX');
                        ban_R5.addreward('52');
                        ban_R5.addreward('XX');
                        ban_R5.addreward('XX'); 
                        ban_R5.addreward('XX');  


                        ban_L5.draw(0);
                        ban_R5.draw(0);
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                     
                        sban_L5.draw(0);
                        sban_R5.draw(0);
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.talkAndFlip(iStr{count});    
                
                    case 'sbandit5afterdifferent'
                        
                        ban_L5.flush;
                        ban_R5.flush;
                        
                        sban_L5.flush;
                        sban_R5.flush;
                        
                        
                        sban_L5.addreward('77');
                        sban_L5.addreward('XX');
                        sban_L5.addreward('65');
                        sban_L5.addreward('67');
                        sban_L5.addreward('70');
                        
                        sban_R5.addreward('XX');
                        sban_R5.addreward('52');
                        sban_R5.addreward('XX');
                        sban_R5.addreward('XX');
                        sban_R5.addreward('XX');
                        
                        
                        ban_L5.addreward('77');
                        ban_L5.addreward('XX');
                        ban_L5.addreward('65');
                        ban_L5.addreward('67');
                        ban_L5.addreward('XX');
                        
                        ban_R5.addreward('XX');
                        ban_R5.addreward('52');
                        ban_R5.addreward('XX');
                        ban_R5.addreward('XX'); 
                        ban_R5.addreward('80');  


                        ban_L5.draw(0);
                        ban_R5.draw(0);
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                     
                        sban_L5.draw(0);
                        sban_R5.draw(0);
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.talkAndFlip(iStr{count});    
                      
                    case '4t'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        ban_L10.addreward('77');
                        ban_L10.addreward('XX');
                        ban_L10.addreward('65');
                        ban_L10.addreward('67');
                        
                        ban_R10.addreward('XX');
                        ban_R10.addreward('52');
                        ban_R10.addreward('XX');
                        ban_R10.addreward('XX');
                        
                        ban_L10.draw(0);
                        ban_R10.draw(0);
                        obj.talkAndFlip(iStr{count});
                        
                    case 'free'
                        
                        ban_L10.flush;
                        ban_R10.flush;
                        
                        sban_L10.flush;
                        sban_R10.flush;
                    
                        sban_L10.addreward('77');
                        sban_L10.addreward('XX');
                        sban_L10.addreward('65');
                        sban_L10.addreward('67');
                        
                        sban_R10.addreward('XX');
                        sban_R10.addreward('52');
                        sban_R10.addreward('XX');
                        sban_R10.addreward('XX');
                        
                        ban_L10.addreward('77');
                        ban_L10.addreward('XX');
                        ban_L10.addreward('65');
                        ban_L10.addreward('67');
                        
                        ban_R10.addreward('XX');
                        ban_R10.addreward('52');
                        ban_R10.addreward('XX');
                        ban_R10.addreward('XX');                     

                        ban_L10.draw(0);
                        ban_R10.draw(0);
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                        
                        sban_L10.draw(0, 'forbid');
                        sban_R10.draw(1);
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        obj.Beep;
                        obj.gocue;
                        obj.talkAndFlip(iStr{count});
                        
                    case 'exampleplay'
                        
                        Screen('FillRect',obj.window,obj.bgColor);
                        Screen('Flip',obj.window);
                        ban_L10.flush;
                        ban_R10.flush;
                        sban_L10.flush;
                        sban_R10.flush;
                        
                        a = {'62', '66','55','49','61','60','53','70','65','55'};
                        b = {'52','56','45','39','51','50','43','60','55','45'};
                        
                        ra = {'62', '66','55','49','55','60','53','70','65','61'};
                        rb = {'52','56','45','39','60','50','43','51','55','45'};
                        
                        tf = [1,1,2,1,0,0,0,0,0,0];
                        ban_L = ban_L10;
                        ban_R = ban_R10;
                        window = obj.window;
                        
                        sban_L = sban_L10;
                        sban_R = sban_R10;
                        socialchoice = 1;
                        
                        obj.cross.draw;
                        Screen('Flip',obj.window);
                        WaitSecs(3.0);
                          for i = 1:10
                                rL = a{i};
                                rR = b{i};
                                
                                srL = ra{i};
                                srR = rb{i};
                                
                                if i < obj.ShowForced
                                    situation = 1;
                                elseif i == obj.ShowForced
                                    situation = 2;
                                else
                                    situation = 0;
                                end
                                obj.run_trial(i,rL,rR,srL,srR,tf(i),ban_L,ban_R,sban_L,sban_R,socialchoice,window,situation);                     
                          end
                            
                        ban_L10.draw(0);
                        ban_R10.draw(0);
                        
                        textSize2 = 20;
                        OldtextSize = Screen('TextSize', obj.window, textSize2);
                        
                        sban_L10.draw(0, 'forbid');
                        sban_R10.draw(0, 'forbid');
                        
                        Screen('TextSize', obj.window, OldtextSize);
                        
                        DrawFormattedText(obj.window, ...
                    ['        Page ' num2str(count) ' of ' num2str(length(iStr))], ...
                    [],[B*0.91], [1 1 1], obj.textWrapat);
                        obj.talkAndFlip(iStr{count});
                end
                
                keyspace = KbName('space');
                keybackspace =  KbName('delete');
                % press button to move on or not
                
                if ~ef
                    
                    [KeyNum, when] = obj.waitForInput([keyspace,keybackspace], Inf);
                    
                    switch KeyNum
                        
                        case keyspace % go forwards
                            count = count + 1;
                            if count > length(iStr)
                                endFlag = true;
                            end
                            
                        case keybackspace % go backwards
                            ef = true;
                            count = count - 1;
                            if count < 1
                                count = 1;
                            end
                            endFlag = false;
                            
%                         case 5 % skip through
%                             endFlag = true;
%                             
%                         case 6 % quit
%                             sca
%                             error('User requested escape!  Bye-bye!');
                            
                    end
                    
                end
            end
            WaitSecs(0.1);
        end
        % instructions ====================================================
        function instructionList(obj)
            
            i = 0;
            
               % instructions without sound
                i=i+1; ev{i} = 'blank';      iStr{i} = 'Welcome! Thank you for volunteering for this experiment.';
%                 i=i+1; ev{i} = 'blank';      iStr{i} = 'In this experiment you will do two things.  First you will play a gambling task in which you will make choices between two options. This will take about 30 minutes.  Next you will fill in a personality questionnaire.  This will take about 10 minutes.  When you''re done please return to the main lab for debriefing.';
                i=i+1; ev{i} = 'realBandits';iStr{i} = 'In this experiment - the gambling task - we would like you to choose between two one-armed bandits of the sort you might find in a casino.';
                i=i+1; ev{i} = 'bandits';    iStr{i} = 'The one-armed bandits will be represented like this';
                i=i+1; ev{i} = 'bandits_lever';iStr{i} = 'Every time you choose to play a particular bandit, the lever will be pulled like this ...';
                i=i+1; ev{i} = 'L_77';       iStr{i} = '... and the payoff will be shown like this.  For example, in this case, the left bandit has been played and is paying out 77 points. ';
                %i=i+1; ev{i} = 'L_77';       iStr{i} = 'The points you earn by playing the bandits will be converted into REAL money at the end of the experiment, so the more points you get, the more money you will earn.';
%                 i=i+1; ev{i} = 'L_77';       iStr{i} = 'The points you earn by playing the bandits will be converted into a reward of time during of the experiment, so the more points you get, the faster you will get out of this room and get your credits.';
%                 i=i+1; ev{i} = 'L_77';       iStr{i} = 'If you play this gampling wisely and earn enough points, you will be able to finish the task within 20 minutes. However, if you just choose randomly, your task will last about 40 minutes. Try your best to get as many points as you can!';
                
               
                i=i+1; ev{i} = 'bandits';    iStr{i} = 'Each bandit tends to pay out about the same amount of reward on average, but there is variability in the reward on any given play.  ';
                i=i+1; ev{i} = 'R_52';       iStr{i} = 'For example, the average reward for the bandit on the right might be 50 points, but on the first play we might see a reward of 52 points because of the variability ...';
                i=i+1; ev{i} = 'R_56';       iStr{i} = '... on the second play we might get 56 points ... ';
                i=i+1; ev{i} = 'R_45';       iStr{i} = '... if we open a third box on the right we might get 45 points this time ... ';
                i=i+1; ev{i} = 'R_all';      iStr{i} = '... and so on, such that if we were to play the right bandit 10 times in a row we might see these rewards ...';
                i=i+1; ev{i} = 'R_all';      iStr{i} = 'Both bandits will have the same kind of variability and this variability will stay constant throughout the experiment.';
                i=i+1; ev{i} = 'bandits';    iStr{i} = 'In each game, one of the bandits will have a higher average reward and hence is the better option to choose on average in that game.'
                i=i+1; ev{i} = 'bandits';    iStr{i} = 'To make your choice:\n Press <- to play the left bandit \n Press -> to play the right bandit';
                i=i+1; ev{i} = 'bandits';    iStr{i} = 'On any trial you can only play one bandit and the number of trials in each game is determined by the height of the bandits.  For example, when the bandits are 10 boxes high, there are 10 trials in each game ... ';
                i=i+1; ev{i} = 'bandits5';   iStr{i} = '... when the stacks are 5 boxes high there are only 5 trials in the game.';
                i=i+1; ev{i} = '4t';    iStr{i} = 'In addition, the first 4 choices in each game are instructed trials where we will choose an option for you.  This will give you some experience with each option before you make your first choice.';
                i=i+1; ev{i} = '4t';       iStr{i} = 'There are four blocks of games. Each block contains 40 games. Each game is either 5-trial or 10-trial of which you have one trial or 6 trials to play, respectively.';
                
                i=i+1; ev{i} = 'sbandit5';   iStr{i} = 'In each game, you will also see a smaller picture of the current task. It shows you the choice made by a previous subject. It doesn''t show the output of that choice at first. Here it shows you that a previous subject chose the left bandit.'; 
                i=i+1; ev{i} = 'sbandit10';   iStr{i} = 'For the 10-trial games, you will only see their choice on the first trial. We won''t tell you about their choices on other trials in that game. Here you see that a previous subject chose the right bandit on their first trial, but you don''t know what she/he did on the other five trials.'; 
%                 i=i+1; ev{i} = 'forcedL1';   iStr{i} = 'These instructed trials will be indicated by a green square inside the box we want you to open and you must press the button to choose this option in order to move on to see the reward and move on the next trial. For example, if you are instructed to choose the left box on the first trial, you will see this:';
%                 i=i+1; ev{i} = 'forcedR2';   iStr{i} = 'If you are instructed to choose the right box on the second trial, you will see this:';
%                 i=i+1; ev{i} = 'free';       iStr{i} =  'Once these instructed trials are complete there will be a go-cue and a beep, and then you will have a free choice between the two stacks that is indicated by two green squares inside the two boxes you are choosing between.';
                
                i = i+1; ev{i} = 'sbandit5'; iStr{i} = 'After you made your choice, you see the outcome of the other subject''s choice in addition to yours. Here if you choose the left bandit, like the other subject...';
                i = i+1; ev{i} = 'sbandit5aftersame'; iStr{i} = '... you will see new rewards on your left bandit and the left small bandit of the other subject.';
                i = i+1; ev{i} = 'sbandit5'; iStr{i} = 'If you choose the right bandit, while the other subject chose the left one...';
                i = i+1; ev{i} = 'sbandit5afterdifferent'; iStr{i} = '... you will see new rewards on your right bandit and the left small bandit of the other subject.';
                i=i+1; ev{i} = 'sbandit10';   iStr{i} = 'The same goes for the 10-trial cases, but it only shows for the first trial. Here if you choose the right one, like the other subject,...';
                i=i+1; ev{i} = 'sbandit10aftersame';   iStr{i} = '... you will see new rewards on your right bandit and the right small bandit of the other subject.';
                i=i+1; ev{i} = 'sbandit10';   iStr{i} = 'If you choose the left bandit, while the other subject chose the right one...';
                i=i+1; ev{i} = 'sbandit10afterdifferent';   iStr{i} = '... you will see new rewards on your left bandit and the right small bandit of the other subject.';
                
                
                i = i+1; ev{i} = 'cross';       iStr{i} = 'Throughout the task we will be tracking your eyes. To help us better track your eyes, the timing of the task is quite slow.  Each game begins with the presentation of a fixation cross like this for three seconds ... please try to stare at this cross while it is displayed.';
                i = i+1; ev{i} = 'sbandit10';     iStr{i} = 'After 3 seconds, the fixation cross will disappear and the bandits will appear along with the outcomes of the example plays - like this ... during this period feel free to look where you want to.';
                i = i+1; ev{i} = 'free';        iStr{i} = 'After 3 more seconds a GO cue will appear and a sound will play at which point you are free to choose between the two options';
%                 i = i+1; ev{i} = '4t';     iStr{i} = 'In a 10-trials game, the remaining 5 choices can be made quickly.';
                i=i+1; ev{i} = 'blank';      iStr{i} = 'So ... to be sure that everything makes sense let''s work through an example game ... \n Press <- to play the left bandit \n Press -> to play the right bandit';
                i=i+1; ev{i} = 'exampleplay';iStr{i} = 'Good job! Now you know how to play this game.';
                i=i+1; ev{i} = 'blank';      iStr{i} = 'Press space when you are ready to begin. Earn as many points as you can! Good luck!';
          
            obj.iStr = iStr;
            obj.iEv = ev;
            
        end
        function talkAndFlip(obj, str, pTime)
            
            Screen('TextFont', obj.window, 'Arial');
            Screen('TextSize', obj.window, obj.textSize);
           
            [A, B] = Screen('WindowSize', obj.window);
            
            if exist('pTime') ~= 1
                pTime = 0.3;
            end
            [nx, ny] = DrawFormattedText(obj.window, ...
                ['' str], ...
                0.05*A,[B*0.033], [1 1 1], obj.textWrapat);
            Screen('TextSize', obj.window,round(obj.textSize));
            DrawFormattedText(obj.window, ...
                ['' ...
                'Press space to continue or delete to go back'], ...
                'center', [B*0.91], [1 1 1], obj.textWrapat);
            Screen('TextSize', obj.window,obj.textSize);
            Screen(obj.window, 'Flip');
            WaitSecs(pTime);
            
        end
    end
end