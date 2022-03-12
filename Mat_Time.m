%MATLAB project, WiSe 2020/2021
%Student: Tomaso Zanardi
%Immatricultion number: 615433
%Timing file for fMRI experiment. This programme is supposed to allow the
%user to create a timing file for the epxeriment run by Irene Sophia
%Planck. It allows to extract timing information from a .log file created
%via the 'Presentation' software. 

%TABLE CREATION
%my intention here is to import the log file as a table variable first of
%all I ask the user to input the name of the .log file which needs to be
%timed. 
file = input ('Please copy and paste the name of the .log file you want the timing file for. Remember: it MUST be in your current working directory!\n','s');
opts = detectImportOptions(file);
%unfortunately the .log file has the ',' character set in its delimiter
%properties but tabulations are what is actually used. This leads matlab to
%think that all of the information is crammed in the first column (the same
%happens with Excel), making indexing pretty much impossible.
%Thefore, a change in the delimiter variable was necessary. This updates the
%'Delimiter' voice in the 'DelimitedTextimportOptions' class object and...
opts.Delimiter = '\t'; 
%... allows me to easily create a table.
data = readtable(file,opts);
%just a neat addition: I wanted indexing to be more understandable to the
%end-user by changing the automatically set header names (ExtraVar 1,2,3,4,
%etc...) to what they represent. Such a thing is already done in line 2. I
%had to change the name of the 10th header simply because it is the same as
%the the one of the 8th, not allowing me to rename the columns because
%MATLAB does not accept the same char array for more than one header name.
data.ExtraVar9{2} = 'Uncertainty ';
data.Properties.VariableNames = data{2,:};
%CONDITIONS 
%Conditions unfortunately have been hard-coded. But to be very
%frank I did not see very many ways around that. It is part of the
%experiment setup after all.
fprintf ('Conditions:\n')
conditions {1,1} = 'child + pain';
conditions {1,2} = 'child + nopain';
conditions {1,3} = 'adult + pain';
conditions {1,4} = 'adult + nopain';
disp (conditions {1,1})
disp (conditions {1,2})
disp (conditions {1,3})
disp (conditions {1,4})
fprintf ('\n')
%DURATIONS
%discr stands for "discriminants", as it allows the programme to
%understand through the 'contains' function whether we've encountered the
%condition of interest.
discr = {'ki_pain', 'ki_nopa', 'er_pain', 'er_nopa'};
% -- instances counter --
%soft coding! Here I created a little script which finds out how many of
%each of the occurences occur. This is in case that the amount of runs
%could were to be changed in the future. Or some happen more than the other ones.
k = 1;%counter variable 
instances = 0;%The number of instances for that specific condition we're currently looking for
inst = []; %array which'll hold all the instances for every condition.
i = 1;
for j = 1:4
    while i ==1
        a = data.Code{k};%Index the code assigned to the stimulus
        if contains(a,discr{j}) %the contains function allows me to see if that condition happens
            instances = instances + 1; %increase the counter for amount of times that condition has happened. 
        end
        %I assumed that 'break' in the .log file stands for the end of the
        %first run. Thus, I check if the value that 'a' has taken is a string
        %called break...
        if ischar(a)
            b = strcmp (a, 'break');
        end
        %... so I can break from the while cycle and...
        if b == 1
            break
        end
        k=k+1;
    end
     %... add the amount of instances to an array which'll be used later
     %for indexing
    inst (1,end+1) = instances;
    instances = 0;
    %here I assign the k variable on the final iteration of the for-loop to
    %a second variable which will be used to cycle from the 'break'
    %variable onwards during the second run. 
    if j == 4
        l = k+1; %the +1 is because we want to start from the line AFTER 'break'
    end
    k = 1; %k here is reset so it can be used to cycle through the table again but
    %acquiring info for the other conditions. 
end

%actual 'durations' cell array creation. We can let the experimenter set
%what was the duration for each of the condtions. In case they happened to
%be different for whatever reason. This step could be avoided.
for i = 1:4
    fprintf ('Please insert the durations that you would like for the "%s" condition:\n',conditions {1,i})
    duration = input('');
    for k = 1:inst(i)
        dur (1, k) = duration;
    end
durations {1, i} = dur;
end
%ONSETS
fprintf ('Calculating onsets for stimuli...\n')
%variable to insert the timing in which the conditions happen
times = [];
%array in which the onsets will be inserted
onsets = {};
k = 1;
i = 1;
%The indexing for t_start might seem hard coded (the '{3}'). But I rest on the
%assumption that all the .log files from this experiment will be identical
%in formatting. Thus, the third row - with my import settings - is where the
%starting time is always to be found.
t_start = str2double(data.Time{3});
for j = 1:4
    while i == 1
        a = data.Code{k};
        if contains(a,discr{j})
            times (1, end+1) = (str2double(data.Time{k})-t_start)/10000;
        end
        %Same as we've seen above 
        if ischar(a)
            b = strcmp (a, 'break');
        end
        if b == 1
            break
        end
        k=k+1;
    end
    onsets {1,j} = times; 
    times = [];
    %there's no assignment to l as we've see above, we already have the
    %variable.
    k = 1;
end
%here the file is named taking the first 6 characters of the filename given
%by the user and concatenated with the other parts of the
%filenae that we might need. 
subject = file (1:6);
filename = ['sub-',subject,'_run-1.mat'];
save(filename,'conditions','durations','onsets')
fprintf ('%s has been succesfully saved\n', filename)
%%SECOND RUN

fprintf ('SECOND RUN\n')

%CONDITIONS: the conditions cell array is already created and will be used again to
%create the second .mat file. 

%DURATIONS
k = l;%now the counter starts from l
instances = 0;
inst = [];
i = 1;
for j = 1:4
    while i == 1
        a = data.Code{k};
        if contains(a,discr{j})
            instances = instances + 1;
        end
        if ischar(a)
            b = strcmp (a, 'finish'); % I consider 'finish' as the end of the second run.
        end
        if b == 1
            break
        end
        k=k+1;
    end
    inst (1,end+1) = instances;
    instances = 0;
    k = l; 
end
for i = 1:4
    fprintf ('Please insert the durations that you would like for the "%s" condition:\n',conditions {1,i})
    duration = input('');
    for k = 1:inst(i)
        dur (1, k) = duration;
    end
durations {1, i} = dur;
end
%ONSETS
fprintf ('Calculating onsets for stimuli...\n')
times = [];
onsets = {};
k = l;
i = 1;
t_start = str2double(data.Time{l});
for j = 1:4
    while i == 1
        a = data.Code{k};
        if contains(a,discr{j})
            times (1, end+1) = (str2double(data.Time{k})-t_start)/10000;
        end
        if ischar(a)
            b = strcmp (a, 'finish');
        end
        if b == 1
            break
        end
        k=k+1;
    end
    onsets {1,j} = times; 
    times = [];
    k = l;
end
filename = ['sub-',subject,'_run-2.mat'];
save(filename,'conditions','durations','onsets')
fprintf ('%s has been succesfully saved', filename)