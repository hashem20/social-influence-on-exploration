clear all;  %PsychDebugWindowConfiguration;
clc;
% 061-part-1: Passive No-outcome
d1 = '/Users/hashem/Documents/University_Stuffs/Projects/2_Social_Decision_Making/061_Social_Fall2015/061_Data/Part_1/';
% 061-part-2: Passive Outcome-revealed 
d2 = '/Users/hashem/Documents/University_Stuffs/Projects/2_Social_Decision_Making/061_Social_Fall2015/061_Data/Part_2/';
% 072-version-1: Passive No-outcome
d3 = '/Users/hashem/Documents/University_Stuffs/Projects/2_Social_Decision_Making/072_Spring_2016_Social_decision_making/072_Data/072_Version_1/';
% 072-version-2: Passive Outcome-revealed 
d4 = '/Users/hashem/Documents/University_Stuffs/Projects/2_Social_Decision_Making/072_Spring_2016_Social_decision_making/072_Data/072_Version_2/';
% Active even subIDs --> Outcome-revealed (version 2 of exp 072 was run)
% Active odd subIDs --> N0-outcome (version 1 of exp 072 was run)
d5 = '/Users/hashem/Documents/University_Stuffs/Projects/2_Social_Decision_Making/Fall_2018_Social_Explore_Data/';

% load
for i=1:5
    directory = ['d' num2str(i)];
    directory = eval(directory);
    cd (directory);
    g{i} = (dir([directory, '*.mat']));
    for j = 1:length (g{i})
        sub{i}{j,:} = load (g{i}(j).name);
    end
end
%% separating two conditions in Active group (group5 : active_no-coucome; group6: Active_outcome-reveales
t=0; tt=0;
for i=1:length(sub{5})
    if (mod(sub{5}{i}.subjectID, 2) == 0)
        t=t+1;
        sub{6}{t,:} = sub{5}{i}; 
        if t ~= i
            sub{5}{i} = [];
        end
    else
        tt=tt+1;
        sub{5}{tt,:} = sub{5}{i}; 
        if tt ~= i
            sub{5}{i} = [];
        end
    end
end
emptycell = cellfun(@isempty, sub{5});  %find empty columns of cell array    
sub{5}(emptycell) = []; 
%% removing 999 IDs & adjisting IDs
sub{1}{16}.subjectID = 117; % it was put 117000
for g = 1:length(sub)
    for i = 1:length(sub{g})
         if sub{g}{i}.subjectID > 400
             sub{g}{i} = [];
         end
    end
    emptycell = cellfun(@isempty, sub{g});     
    sub{g}(emptycell) = []; 
end
%% looking for identical IDs *BAD CODING*
% extracting subjectIDs
for g = 1:length(sub)
    for i = 1:length(sub{g})
       eval (['ID' num2str(g) '(i)=sub{g}{i}.subjectID;'])
    end
    eval ([['ff{g} = ID' num2str(g)] ';'])
end
% checking duplicates
for g=1:length(ff)
    count=0;
    fff{g} = sort(ff{g});
    for i=2:length(fff{g})
        if fff{g}(i) == fff{g}(i-1)
            count = count +1;
            note{g}(count, 1) = fff{g}(i);
            note{g}(count, 2:3) = find(ff{g} == fff{g}(i));
        end
    end
end
%% manually adjusting duplicates
sub{3}{67}.subjectID = 247; % RA wrongly put 147 instead of 247
sub{3}{69}.subjectID = 251; % RA wrongly put 151 instead of 251
sub{3}{92}.subjectID = 71; % RA wrongly put 271 while it was used before, I made the second one 71
sub{3}{89}.subjectID = 292; % RA wrongly put 293 instead of 292

sub{4}{66}.subjectID = 250; % RA wrongly put 150 instead of 250
sub{4}{91}.subjectID = 72; % RA wrongly put 272 while it was used before, I made the second one 72

%% task parameters for each game
g = 1; % group #
i = 1; % subject #
j = 1; % game #
x=0; y=0; %counting h1 and h6 games

for g = 1:length(sub)
    for i = 1:length(sub{g})
        while size(sub{g}{i}.game(j).key) == [1 10] | size(sub{g}{i}.game(j).key) == [1 5]
            
            task{g}{i,:}.subID = sub{g}{i}.subjectID;
            task{g}{i,:}.g(j).h = sub{g}{i}.game(j).gameLength - 4; %horizon 1 or 6
            
            if task{g}{i,:}.g(j).h == 1
                x=x+1;
            elseif task{g}{i,:}.g(j).h == 6
                y=y+1;
            end

            if sum(sub{g}{i}.game(j).nforced ==1) == 1         % uncertainty = 0,1,2  
                task{g}{i}.g(j).uc = 1; % option 1 is uncertain
            elseif sum(sub{g}{i}.game(j).nforced ==1) == 3
                task{g}{i}.g(j).uc = 2; % option 2 is uncertain
            else
                task{g}{i}.g(j).uc = 0;
            end
       if task{g}{i}.g(j).uc ~= 0
            task{g}{i}.g(j).hi = (sub{g}{i}.game(j).key(5) == task{g}{i}.g(j).uc);    % high info choice, yes =1, no =0
            task{g}{i}.g(j).smhi = (sub{g}{i}.game(j).smallbanditchoice == task{g}{i}.g(j).uc); % whether model chose high info choice, yes =1, no =0
       else
           task{g}{i}.g(j).hi = NaN;
           task{g}{i}.g(j).smhi = NaN;
       end
            task{g}{i}.g(j).copy = (sub{g}{i}.game(j).smallbanditchoice == sub{g}{i}.game(j).key(5)); % copy, yes =1, no =0

            task{g}{i}.g(j).rt5 = sub{g}{i}.game(j).RT(5); %reaction time at trial 5
            
            av1 = sum((2 - sub{g}{i}.game(j).nforced).*sub{g}{i}.game(j).rewards(1, 1:4));
            av2 = sum((sub{g}{i}.game(j).nforced - 1).*sub{g}{i}.game(j).rewards(2, 1:4));
         
            task{g}{i}.g(j).lm = ((av1 < av2) & (sub{g}{i}.game(j).key(5) == 1)) | ((av1 > av2) & (sub{g}{i}.game(j).key(5) == 2)); % low mean choice, yes =1, no =0
            task{g}{i}.g(j).smlm = ((av1 < av2) & (sub{g}{i}.game(j).smallbanditchoice == 1)) | ((av1 > av2) & (sub{g}{i}.game(j).smallbanditchoice == 2)); % whether model chose low mean choice, yes =1, no =0

            if task{g}{i}.g(j).h == 6
                task{g}{i}.g(j).rt_h6(1:6) = sub{g}{i}.game(j).RT(5:10);
            end

            task{g}{i}.g(j).ac = sub{g}{i}.game(j).accuracy;
            j = j+1;
        end
        task{g}{i}.ngame = j-1; j=1;
        task{g}{i}.h1game = x; x=0;
        task{g}{i}.h6game = y; y=0;
    end
end
%% average task parameters for each subject
x=0; y=0; xx=0; yy=0; z=0; zz=0; zzz=0; xy=0; uc1 =0; uc6 = 0;
for g = 1:length(sub)
    for i = 1:length(sub{g})
        for j = 1:task{g}{i}.ngame
            if (task{g}{i}.g(j).h == 1) && ~isnan(task{g}{i}.g(j).hi) && task{g}{i}.g(j).hi 
                x=x+1;
            end
            if task{g}{i}.g(j).uc ~=0 && task{g}{i}.g(j).h ==1
               uc1 = uc1 +1;
            end
            if (task{g}{i}.g(j).h == 6) && ~isnan(task{g}{i}.g(j).hi)&& task{g}{i}.g(j).hi
                y=y+1;
            end
             if task{g}{i}.g(j).uc ~=0 && task{g}{i}.g(j).h ==6
               uc6 = uc6 +1;
            end
            if (task{g}{i}.g(j).h == 1) && task{g}{i}.g(j).lm && task{g}{i}.g(j).uc ==0
                xx=xx+1;
            end
            if (task{g}{i}.g(j).h == 6) && task{g}{i}.g(j).lm && task{g}{i}.g(j).uc ==0
                yy=yy+1;
            end
            if task{g}{i}.g(j).copy
                z=z+1;
            end 
            if task{g}{i}.g(j).copy & (task{g}{i}.g(j).h == 1)
                zz=zz+1;
            end 
            if task{g}{i}.g(j).copy & (task{g}{i}.g(j).h == 6)
                zzz=zzz+1;
            end 
            xy = xy + task{g}{i}.g(j).ac;
        end
        task{g}{i}.phi1 = x/uc1;
        task{g}{i}.phi6 = y/uc6;
        task{g}{i}.plm1 = xx/(task{g}{i}.h1game - uc1);
        task{g}{i}.plm6 = yy/(task{g}{i}.h6game- uc6);
        task{g}{i}.direct = task{g}{i}.phi6 - task{g}{i}.phi1;
        task{g}{i}.random = task{g}{i}.plm6 - task{g}{i}.plm1;
        task{g}{i}.fCopy = z/task{g}{i}.ngame;
        task{g}{i}.fCopy1 = zz/task{g}{i}.h1game;
        task{g}{i}.fCopy6 = zzz/task{g}{i}.h6game;
        task{g}{i}.fCorrect = xy/task{g}{i}.ngame;
        x=0; y=0; xx=0; yy=0; z=0; zz=0; zzz=0; xy=0; uc1 =0; uc6 = 0;
    end
end
%% STATS %%%%%%
%% fCopy
for i = 1:length(task{1})             % exp1 no_oucome
    fp1no (i, 1) = task{1}{i}.fCopy1;   
    fp1no (i, 2) = task{1}{i}.fCopy6;
    fp1no (i, 3) = task{1}{i}.fCopy;
end
for i = 1:length(task{2})             % exp1 outcome_revealed
    fp1out (i, 1) = task{2}{i}.fCopy1;   
    fp1out (i, 2) = task{2}{i}.fCopy6;
    fp1out (i, 3) = task{2}{i}.fCopy;
end

for i = 1:length(task{3})             % exp2 no_oucome
    fp2no (i, 1) = task{3}{i}.fCopy1;   
    fp2no (i, 2) = task{3}{i}.fCopy6;
    fp2no (i, 3) = task{3}{i}.fCopy;
end
for i = 1:length(task{4})             % exp2 outcome_revealed
    fp2out (i, 1) = task{4}{i}.fCopy1;   
    fp2out (i, 2) = task{4}{i}.fCopy6;
    fp2out (i, 3) = task{4}{i}.fCopy;
end

fpno = fp1no;                         % all passive no_outcome
[a,~] = size (fpno);
[b,~] = size (fp2no);
fpno(a+1:a+b, :) = fp2no;
fpout = fp1out;                       % all passive outcome_revealed
[a,~] = size (fpout);
[b,~] = size (fp2out);
fpout(a+1:a+b, :) = fp2out;

for i = 1:length(task{5})             % active no_oucome
    fano (i, 1) = task{5}{i}.fCopy1;   
    fano (i, 2) = task{5}{i}.fCopy6;
    fano (i, 3) = task{5}{i}.fCopy;
end
for i = 1:length(task{6})             % active outcome_revealed
    faout (i, 1) = task{6}{i}.fCopy1;   
    faout (i, 2) = task{6}{i}.fCopy6;
    faout (i, 3) = task{6}{i}.fCopy;
end
%% 061
[~,p1,~,d] = ttest (fp1out(:,1), fp1out(:,2));
[~,p2,~,d] = ttest (fp1no(:,1), fp1no(:,2));
[~,p3,~,d] = ttest2 (fp1no(:,1), fp1out(:,1));
[~,p4,~,d] = ttest2 (fp1no(:,2), fp1out(:,2));
[~,p5,~,d] = ttest2 (fp1no(:,3), fp1out(:,3));
[p1 p2 p3 p4 p5]
%% 072
[~,p1,~,d] = ttest (fp2out(:,1), fp2out(:,2));
[~,p2,~,d] = ttest (fp2no(:,1), fp2no(:,2));
[~,p3,~,d] = ttest2 (fp2no(:,1), fp2out(:,1));
[~,p4,~,d] = ttest2 (fp2no(:,2), fp2out(:,2));
[~,p5,~,d] = ttest2 (fp2no(:,3), fp2out(:,3));
[p1 p2 p3 p4 p5]
%% all passive
[~,p1,~,d] = ttest (fpout(:,1), fpout(:,2));
[~,p2,~,d] = ttest (fpno(:,1), fpno(:,2));
[~,p3,~,d] = ttest2 (fpno(:,1), fpout(:,1));
[~,p4,~,d] = ttest2 (fpno(:,2), fpout(:,2));
[~,p5,~,d] = ttest2 (fpno(:,3), fpout(:,3));
[p1 p2 p3 p4 p5]
%% all active
[~,p1,~,d] = ttest (faout(:,1), faout(:,2));
[~,p2,~,d] = ttest (fano(:,1), fano(:,2));
[~,p3,~,d] = ttest2 (fano(:,1), faout(:,1));
[~,p4,~,d] = ttest2 (fano(:,2), faout(:,2));
[~,p5,~,d] = ttest2 (fano(:,3), faout(:,3));
[p1 p2 p3 p4 p5]

%% cell fun phi 1, 6
clear phi;
phi(:,1) = cellfun(@(x)x.phi1, task{5});
phi(:,2) = cellfun(@(x)x.phi6, task{5});

%% exclude
indx = any (isnan (phi),2);
phi = phi(~indx, :); % == phi (find (~indx), :)
%% PLOTS phi & direct
m = mean (phi)
st = std (phi) / sqrt (size (phi, 1))
figure (1);
eb = errorbar ( [1, 2], m, st)  ; hold on;
%%
bar ([1, 2], m)
eb.LineWidth = 3
eb.CapSize = 8
xlim ([.5 2.5])
set (gca, 'XTick', [1 2], 'XTickLabel', [1 6])
ylim ([.4 .6])
set (gca, 'YTick', [.5 .6])
set (gca, 'FontSize', 20)
xlabel ('horizon')
ylabel ('ggggtg')
title ('SAMPLE')
legend ('ee', 'tt')
