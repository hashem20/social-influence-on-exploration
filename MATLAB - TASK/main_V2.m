clear

maindir = 'C:\Users\sadeghiyeh\Desktop\Projects\061_Social_Fall2015\061_bobAnalysis\';
datadir{1} = [maindir 'data_v1\'];
datadir{2} = [maindir 'data_v2\'];
fundir = [maindir 'matlab\'];

addpath(fundir);

for j = 1:length(datadir)
    cd(datadir{j})
    
    d = dir('*.mat');
    for i = 1:length(d)
        L{j}(i) = load(d(i).name);
        COR{j}(i) = mean([L{j}(i).game.correct]);
    end
end

%%% remove bad subjects
%for j = 1:length(L)
%ind_good = COR{j} > 0.52;
%L{j} = L{j}(ind_good);
%end

%% Arizona color palette
AZred = [171,5,32]/256;
AZblue = [12,35,75]/256;
AZcactus = [92, 135, 39]/256;
AZsky = [132, 210, 226]/256;
AZriver = [7, 104, 115]/256;
AZsand = [241, 158, 31]/256;
AZmesa = [183, 85, 39]/256;
AZbrick = [74, 48, 39]/256;

%% do they copy what the example did? very crude
for j = 1:length(L)
    for i = 1:length(L{j})
        if j ==1 && (i == 16 | i == 47)
            L{j}(i).game = L{j}(i).game(1:120);
        else
            L{j}(i).game = L{j}(i).game(1:160);
        end
        
        for g = 1:length(L{j}(i).game)
            L{j}(i).game(g).c5 =  L{j}(i).game(g).key(5);
            L{j}(i).game(g).uc =  sum(L{j}(i).game(g).forced==2);
        end
    end
    
    for i = 1:length(L{j})
        fCopy{j}(i) = mean([L{j}(i).game.smallbanditchoice] == [L{j}(i).game.c5]);
    end
end
figure(1); clf; hold on;
hist(fCopy{1})
figure(2); clf; hold on;
hist(fCopy{2})

for i = 1:length(fCopy)
M(i) = mean(fCopy{i})
S(i) = std(fCopy{i}) / sqrt(length(fCopy{i}));
end

figure(3); clf; hold on;
bar(M, 'basevalue', 0.5);
errorbar(M, S)

%%% evolution over time of MF social measure
%    for sn = 1:length(L{j})
  %      game = L{j}(sn).game;
 %       pCopy{j}(:,sn) = double([game.c5]==[game.smallbanditchoice]);
 %   end
%end
%figure(4); clf; hold on;
%plot(nanmean(pCopy{1},2))
%plot(nanmean(pCopy{2},2))
[~,p] = ttest2(fCopy{1}, fCopy{2});

%% what about horizon 1 and horizon 6 separately?
for j = 1:length(L)
    for i = 1:length(L{j})
        game = L{j}(i).game;
        ind = [game.gameLength] == 5 & ([game.uc] ~= 2);
        fCopyHorizon{j}(i,1) = mean([game(ind).smallbanditchoice] == [game(ind).c5]);
        ind = [game.gameLength] == 10 & ([game.uc] ~= 2);
        fCopyHorizon{j}(i,2) = mean([game(ind).smallbanditchoice] == [game(ind).c5]);
    end
end

clear M S
for i = 1:length(fCopy)
    M(i,:) = mean(fCopyHorizon{i})
    S(i,:) = std(fCopyHorizon{i}) / sqrt(length(fCopy{i}));
end

figure(5); clf; hold on;
bar(M, 'basevalue', 0.5);
% errorbar(M, S)
set(gca, 'xtick', [1:2], 'xticklabel', {'expt 1' 'expt 2'})
legend({'horizon 1' 'horizon 6'})
ylabel('fraction copying')

%% t-test
[~,p] = ttest2(fCopyHorizon{1}(:,1), fCopyHorizon{2}(:,1))
[~,p] = ttest2(fCopyHorizon{1}(:,2), fCopyHorizon{2}(:,2))
[~,p] = ttest(fCopyHorizon{1}(:,1), fCopyHorizon{1}(:,2))
[~,p] = ttest(fCopyHorizon{2}(:,1), fCopyHorizon{2}(:,2))

%% glm analysis
% first off compute the observed means of all options
for j = 1:length(L)
    for i = 1:length(L{j})
        game = L{j}(i).game;
        for g = 1:length(game)
            L{j}(i).game(g).m1 = mean(game(g).reward(game(g).forced==1));
            L{j}(i).game(g).m2 = mean(game(g).reward(game(g).forced==2));
            switch sum(game(g).forced == 2)
                case 1 % option 2 is uncertain
                    L{j}(i).game(g).u = 1;
                case 2 % equal uncertainty
                    L{j}(i).game(g).u = 0;
                case 3 % option 1 is uncertain
                    L{j}(i).game(g).u = -1;
            end
        end
    end
end

%% do a glm
clear beta
for j = 1:length(L)
    for i = 1:length(L{j})
        game = L{j}(i).game;
        c5 = [game.c5]';
        m1 = [game.m1]';
        m2 = [game.m2]';
        u = [game.u]';
        c = [game.smallbanditchoice]';
        gl = [game.gameLength]';
       
        ind = gl == 5 & (u ~= 0);
        beta{j}(i,1,:) = glmfit([m2(ind)-m1(ind) u(ind) c(ind)], c5(ind)==2, 'binomial');
        ind = gl == 10 & (u ~= 0);
        beta{j}(i,2,:) = glmfit([m2(ind)-m1(ind) u(ind) c(ind)], c5(ind)==2, 'binomial');
        
    end
end

%% plot results
iNum = 4;
clear M S
for i = 1:length(beta)
    b = beta{i}(:,:,iNum);%./beta{i}(:,:,2);
    b(abs(b)> 100) = nan;
    
    [~,p] = ttest(b(:,1), b(:,2))
    M(i,:) = nanmean(b);
    S(i,:) = nanstd(b)/ sqrt(size(b,1));
end

figure(6); clf; hold on;
% bar(M)
[b,e] = barErrorbar([1:2], M, S);

set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca, 'xtick', [1:2], 'xticklabel', {'expt 1' 'expt 2'})
legend({'horizon 1' 'horizon 6'})

%% easy grid of figures example
figure(7); clf;
hg = [0.1 0.1 0.1];
wg = [0.1 0.1 0.1 0.1];
ax = easy_gridOfEqualFigures(hg, wg)
axes(ax(1));
plot(rand(100,1))
addABCs(ax, [-0.05 0.05], 50)

%%% load eye data
%i = 2;
%cd(datadir{i})
%d = dir('*.tsv');
%j = 1;
%[eye_data, mess] = load_eye(datadir{i}, d(j).name);


        
