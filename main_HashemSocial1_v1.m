%% basic setup ====================================================
clear

maindir     = '/Users/hashem/Documents/University_Stuffs/Projects/2_Social_Decision_Making/061_Social_Fall2015/061_Analyze';
fundir      = [maindir '/v2/'];
addpath(fundir)

% datasets
i=0;

% data
% i=i+1; gp{i} = group_siyu([maindir '/Data061/Part1/']);
i=i+1; gp{i} = group_siyu(['~/Box Sync/Data 061/Part 1/']);
% i=i+1; gp{i} = group_siyu(['~/Box Sync/Data 061/Part 2/']);
% i=i+1; gp{i} = group_siyu([maindir '/Data061/Part2/']);

defaultPlotParameters
cd(fundir)

for i = 1:length(gp)
    gp{i}.load;
end

% NOTE TO HASHEM - EXCLUDE SUBJECTS WHO ARE UNDER 18

%%
figure('Name','fCorrect','NumberTitle','off'); clf; hold on;
fCorrect = [gp{1}.sub(:).fCorrect];
hist(fCorrect);
xlabel('fraction correct')
ylabel('number of subjects')

%% remove bad subjects
count = 1;
thresh = 0.01;
for i = 1:length(gp)
    clear pout
    for sn = 1:length(gp{i}.sub)
        co = [gp{i}.sub(sn).game.correct];
        n = length(co);
        s = nansum(co);
        pout(sn)=myBinomTest(s,n,0.5,'Greater');
        count = count + 1;
    end
    ind_bad = pout > thresh;
    gp{i}.bad_sub = gp{i}.sub(ind_bad);
    gp{i}.sub = gp{i}.sub(~ind_bad);
end
% for i = 1:length(gp)
%     ind_bad = [gp{i}.sub.fCorrect] < 0.8;
%     gp{i}.bad_sub = gp{i}.sub(ind_bad);
%     gp{i}.sub = gp{i}.sub(~ind_bad);
%     
% end

%% MAXIMUM LIKELIHOOD FITS ================================================
%% fit everyone!
clear fit
priorFlag = 1;
for i = 1:length(gp)
    for sn = 1:length(gp{i}.sub)
        fit{i}(sn) = fit_biasNoiseBonusSocial_v1(gp{i}.sub(sn).game, priorFlag);
    end
end

%%




%% hacky - get the spatial bias (and other parameters) in for the 
%% different social conditions
clear social_bias13 social_bias22 bonus noise13 noise22 spatial_bias13 spatial_bias22
for i = 1:length(gp);
    for sn = 1:length(gp{i}.sub)
        spatial_bias13(:,sn) = fit{i}(sn).x(1,:);
        noise13(:,sn) = fit{i}(sn).x(2,:);
        bonus(:,sn) = fit{i}(sn).x(3,:);
        social_bias13(:,sn) = fit{i}(sn).x(4,:);
        spatial_bias22(:,sn) = fit{i}(sn).x(5,:);
        noise22(:,sn) = fit{i}(sn).x(6,:);
        social_bias22(:,sn) = fit{i}(sn).x(7,:);
    end
end

%% spatial bias
% figure('Name','spatial_bias_13','NumberTitle','off'); 
figure(1); clf;
ax = easy_gridOfEqualFigures([0.1 0.15 0.1], [0.1 0.15 0.03]);
plot_results_socialBandits(ax, spatial_bias13, spatial_bias22)
addABCs(ax)

%% noise 
figure(1); clf;
ax = easy_gridOfEqualFigures([0.1 0.15 0.1], [0.1 0.15 0.03]);
plot_results_socialBandits(ax, noise13, noise22)
addABCs(ax)
set(ax([2 4]), 'ylim', [ 0 50])

%% social bias
figure(1); clf;
ax = easy_gridOfEqualFigures([0.1 0.15 0.1], [0.1 0.15 0.03]);
plot_results_socialBandits(ax, social_bias13, social_bias22)
axes(ax(1)); ylabel('social bias')
axes(ax(3)); ylabel('social bias')
addABCs(ax)
% set(ax([2 4]), 'ylim', [ 0 50])

%%
figure('Name','bonus','NumberTitle','off'); clf; hold on;
b22 = mean(bonus,2);
bs22 = std(bonus, [], 2) / sqrt(size(bonus,2));
[b,e] = barErrorbar([1:2], b22, bs22);
xlabel('horizon')
ylabel('bonus')
title('[2 2] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
% legend({'social = 1' 'social = 2'})


figure('Name','noise22','NumberTitle','off'); clf; hold on;
n22 = mean(noise22,2);
ns22 = std(noise22, [], 2) / sqrt(size(noise22,2));
[b,e] = barErrorbar([1:2], n22, ns22);
xlabel('horizon')
ylabel('noise22')
title('[2 2] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
% legend({'social = 1' 'social = 2'})

figure('Name','noise13','NumberTitle','off'); clf; hold on;
n13 = mean(noise13,2);
ns13 = std(noise13, [], 2) / sqrt(size(noise13,2));
[b,e] = barErrorbar([1:2], n13, ns13);
xlabel('horizon')
ylabel('noise13')
title('[1 3] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
% legend({'social = 1' 'social = 2'})


ms13 = mean(social_bias13,2);
ss13 = std(social_bias13, [], 2) / sqrt(size(social_bias13,2));

figure('Name','social_bias_13','NumberTitle','off'); clf; hold on;
[b,e] = barErrorbar([1:2], ms13, ss13);
xlabel('horizon')
ylabel('social bias')
title('[1 3] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])

ms22 = mean(social_bias22,2);
ss22 = std(social_bias22, [], 2) / sqrt(size(social_bias22,2));

figure('Name','social_bias_22','NumberTitle','off'); clf; hold on;
[b,e] = barErrorbar([1:2], ms22, ss22);
xlabel('horizon')
ylabel('social bias')
title('[2 2] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])


figure('Name','social_bias','NumberTitle','off'); clf; hold on;
plot (1:sn, squeeze(social_bias13(1,2,:)), 'yellow', 1:sn, squeeze(social_bias13(2,2,:)), 'red',  1:sn, squeeze(social_bias22(1,2,:)), 'blue', 1:sn, squeeze(social_bias22(2,2,:)), 'green'); 
legend ('13_h1', '13_h6', '22_h1', '22_h6')

figure('Name','social_bias_plus','NumberTitle','off'); clf; hold on;
plot (1:sn, squeeze(social_bias13(1,2,:)) + squeeze(social_bias13(2,2,:)) + squeeze(social_bias22(1,2,:)) + squeeze(social_bias22(2,2,:))); 





%% OLD VERSION ============================================================
%% fit everyone!
clear fit
priorFlag = 1;
for i = 1:length(gp)
    for sn = 1:length(gp{i}.sub)
        for j = 1:2
            ind = [gp{i}.sub(sn).game.smallbanditchoice] == j;
            fit{i,j}(sn) = fit_biasNoiseBonus_v1(gp{i}.sub(sn).game(ind), priorFlag);
        end
    end
    
end

%% hacky - get the spatial bias (and other parameters) in for the 
%% different social conditions
clear bias13 bias22 bonus noise13 noise22
i = 1;
for j = 1:2
    for sn = 1:length(gp{i}.sub)
        bias13(:,j,sn) = fit{i,j}(sn).x(1,:);
        noise13(:,j,sn) = fit{i,j}(sn).x(2,:);
        bonus(:,j,sn) = fit{i,j}(sn).x(3,:);
        bias22(:,j,sn) = fit{i,j}(sn).x(4,:);
        noise22(:,j,sn) = fit{i,j}(sn).x(5,:);
    end
end

m13 = mean(bias13,3);
s13 = std(bias13, [], 3) / sqrt(size(bias13,3));
figure(1); clf; hold on;
[b,e] = barErrorbar([1:2], m13, s13);
xlabel('horizon')
ylabel('spatial bias')
title('[1 3] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
legend({'social = 1' 'social = 2'})
m22 = mean(bias22,3);
s22 = std(bias22, [], 3) / sqrt(size(bias22,3));
%%
figure(2); clf; hold on;
[b,e] = barErrorbar([1:2], m22, s22);
xlabel('horizon')
ylabel('spatial bias')
title('[2 2] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
legend({'social = 1' 'social = 2'})

%%
figure(5); clf; hold on;
b22 = mean(bonus,3);
bs22 = std(bonus, [], 3) / sqrt(size(bonus,3));
[b,e] = barErrorbar([1:2], b22, bs22);
xlabel('horizon')
ylabel('bonus')
title('[2 2] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
legend({'social = 1' 'social = 2'})

%%
figure(3); clf; hold on;
n22 = mean(noise22,3);
ns22 = std(noise22, [], 3) / sqrt(size(noise22,3));
[b,e] = barErrorbar([1:2], n22, ns22);
xlabel('horizon')
ylabel('bonus')
title('[2 2] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
legend({'social = 1' 'social = 2'})
%%
figure(3); clf; hold on;
n13 = mean(noise13,3);
ns13 = std(noise13, [], 3) / sqrt(size(noise13,3));
[b,e] = barErrorbar([1:2], n13, ns13);
xlabel('horizon')
ylabel('bonus')
title('[1 3] condition')
set(b(1), 'facecolor', AZred)
set(b(2), 'facecolor', AZblue)
set(gca ,'xtick', [1 2], 'xticklabel', [1 6])
legend({'social = 1' 'social = 2'})
