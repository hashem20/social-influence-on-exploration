clear all;   
clc
                                                                                          
% directories                                                  
mainpath = [pwd '/'];
addpath('./functions');
savepath = [mainpath 'data/'];
                               
time = datestr(now,30);

projectname = 'P061';
                           
% parameters            
text.textSize = 40;                                            
text.textColor = [1 1 1]*1;
text.textWrapat = 70;
text.textFont = 'Arial';
colour{1} = [ 97    67    67 ]/255;                           
colour{2} = [ 55    85    55 ]/255;
colour{3} = [ 71    71   101 ]/255;
colour{4} = [ 91    71    41 ]/255;
textColour = [255 255 255]/255;                                                          
% bgColour = [75 75 75]/255;
bgColour = [1 1 1]/255;
          
subjectID = input('Please input the subjectID: ');

% eyetracker setup
eyetribedir  = [mainpath '/functions/python_source'];
eyetribeSourcedir = [mainpath '/functions/EyeTribe_for_Matlab/'];
eye = eyetracker(eyetribedir,eyetribeSourcedir);
filename = [projectname, 'eye_raw_sub', num2str(subjectID), '_',time];
eye.setup(savepath,filename);
eye.open;
eye.calibrate;
eye.startmatlabserver;
eye.connect;

cd(mainpath);
  
Screen('Preference', 'SkipSyncTests',1); 
% execute the AssertOpenGL command
% execute KbName('UnifyKeyNames')
% execute Screen('ColorRange', window, 1, [], 1)
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens); 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0]);

eye.startaquiring;

% subjectID & demographic information

% eye.marker('getsubjectID');
% sub = getsubjectI                                                            D(w      indow,subjectID);
% save([savepath projectname 'subjectinfo_sub' num2str(sub.subjectID),'_',time(1:8)],'sub');
% subjectinfo = importdata([savepath 'subjectinfo.mat']);
% subjectinfo.ID = [subjectinfo.ID; sub.subjectID]; 
% subjectinfo.session = [subjectinfo.session; sub.session]; 
% subjectinfo.calibrationquality = [subjectinfo.calibrationquality; sub.calibrationquality]; 
% save([savepath 'subjectinfo'],'subjectinfo');    
% eye.marker('getdemographic');
% % subdemo = demographic(window);
% % save([savepath  projectname 'demographicinfo_sub' num2str(sub.subjectID),'_',time],'subdemo','sub');

sub.subjectID = subjectID;    
sub.session = 2; 

HideCursor;
% 
% introduction
i = 0;
i=i+1; iStr{i} = 'Welcome! Thank you for volunteering for this experiment.';
i=i+1; iStr{i} = 'In this experiment you will do three things.  \n1. Baseline eye measurement. This will take about 5 minutes. \n2. Fill in a short questionnaire. This will take about 5 minutes.\n3. Play a gambling task in which you will make choices between two options. This will take about 20 to 40 minutes, depending on how well you do in the gambling task. \nWhen you''re done please return to the experimenter for debriefing.';

 
% baseline eye measurement
i = 0;
i=i+1; iStr{i} = 'Now we are going to get a baseline measurement of your eyes using the eye tracker. \n\nPress space to continue';
i=i+1; iStr{i} = 'To do this we need you to stare at the screen for 5 minutes.  Feel free to relax and daydream, but please stay in the chin rest.\n\nPress space to continue';
i=i+1; iStr{i} = 'Press space to start the eye-measurement.';
insbase = instructions(window);
insbase.setup(text);
insbase.update(iStr);
eye.marker('instructionsbaseline');
insbase.run(1);
Screen('FillRect',window,[0 0 0]);
Screen('Flip',window);
eye.marker('startbaseline');

WaitSecs(300);

eye.marker('endbaseline');

% survey
% sur = surveys(window,sub.subjectID);
% i = 0;
% i=i+1; iStr{i} = 'Now we would like you to complete the following survey with a total of 10 questions. \n\nPress space to continue';
% switch sub.session
%     case 1
%         sur.legalkey = [KbName('1'):KbName('4'),KbName('1!'):KbName('4$')];
%         sur.setupsurvey('./survey/','./survey/','ID_Scale','ID_Scale_ans');
%         num = 4;
%         savename = [savepath, projectname,'survey_ID_Scale_sub' num2str(sub.subjectID),'_',time]; 
%     case 2
%         sur.legalkey = [KbName('1'):KbName('5'),KbName('1!'):KbName('5%')];
%         sur.setupsurvey('./survey/','./survey/','CEIII','CEIII_ans');
%         num = 5;        
%         savename = [savepath, projectname,'survey_CEIII_sub' num2str(sub.subjectID),'_',time]; 
% end        
% i=i+1; iStr{i} = ['Please respond to the questions by pressing number keys 1 to ' ,num2str(num), '.\n\nPress space to continue'];
% inssur = instructions(w                  indow);
% inssur.setup(text);                  
% inssur.update(iStr);
% inssur.run(1);  
    % sur.setup(savename,text);                                                                                                   
% eye.marker('surveystart ');
                                                    
                           
% sur.run; 

% eye.marker('surveyend');
                                                                
% horizon task    
savename = [savepath, projectname,'horizontask_sub' num2str(sub. subjectID),'_',time];
                                     tsk = task_horizon(window,savename,bgColour);
 tsk.setup(sub.subjectID,eye,textColour);
eye.marker('taskstart')  ;  
 tsk.run (window);
eye.marker('taskend');                               
                                                                                     
ShowCursor;
                                                                                                       
%   exit screen      
  
tstring= 'Thank you for participating in this task! \n\n Now it''s time for the second part of the experiment. \n You will be directed to a new page for taking the survey.\n\nPress anything to exit and continue';

%   tstring= 'Thank you for participating in this task! \n\n Now we have a few post-experiment questions for you.\n\nPress anything to exit and continue';
Screen('TextSize',window,40);                                                                                                            
  DrawFormattedText(window,tstring,'center','center',[1 1 1]);
Screen('Flip',window);
KbStrokeWait;

DrawFormattedText(window,['***IMPORTANT***\n\n\nThis is your subjectID = ' num2str(sub.subjectID) '\n\n Please enter it at the first page of survey, then proceed to other questions. Thanks!\n You can also find your subjectID at a piece of paper in front of you.'],'center','center',[1 1 1]);
Screen('Flip',window);
KbStrokeWait;
sca;
                                         
eye.endaquiring;
eye.disconnect;                                                                      
eye.close;

subjectID
web('https://uarizona.co1.qualtrics.com/SE/?SID=SV_0pODwgkwP9HMHAN')

% cd(mainpath); 
% cd('./IntrospectionQues'); 
% savename = [savepath  projectname 'PostQues_sub' num2str(sub.subjectID),'_',time(1:8)];
% eval(['!cp PostExperimentQs.txt' savename '.txt']);
% cd(savepath);                                           
% eval(['!open -a TextEdit' savename '.txt']);
  
