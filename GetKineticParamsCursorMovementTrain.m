%% Function to get kniematic parameters for a certain subject for the Train phase
function [TrajsTang, TargetAngle, Teach, Curl, ErrAng, NT, CutInds, ErrAngss] = GetKineticParamsCursorMovementTrain(subj)
 %our data has an empty first trial for all
subj.TrialDataXYTrain = subj.TrialDataXYTrain(2:end); 
subj.ShotDataXYTrain = subj.ShotDataXYTrain(2:end); 
subj.AngleShotTrain=subj.AngleShotTrain(2:end);
subj.AngleTargetTrain=subj.AngleTargetTrain(2:end);
subj.ForceFieldTrain=subj.ForceFieldTrain(2:end);
subj.TargetDataXYTrain=subj.TargetDataXYTrain(2:end);
%
CurlThr = 1.5;%1000;% Distribution thresholds
TimeThr = 2.3;%10000;% Distribution thresholds
TrajsT = subj.TrialDataXYTrain;

% Calculate error angles
diff = mod(pi-cell2mat(subj.AngleShotTrain),2*pi) - cell2mat(subj.AngleTargetTrain);
ind = find(diff>pi);
diff(ind) = diff(ind)-2*pi;
ind = find(diff<-pi);
diff(ind) = diff(ind)+2*pi;
ErrAngss = 180*diff/pi;
% Calculate cursor trajectories
RealTrajsT = cell(length(TrajsT),1);
X1 = TrajsT{1}(:, 1);
X2 = TrajsT{1}(:, 2);
nT=0;
P = horzcat(X1(nT+1:end), X2(nT+1:end));
RealTrajsT{1} = P;
for i = 2 : length(TrajsT)
    l = length(TrajsT{i-1}(:,1));
    X1 = TrajsT{i}(:, 1);
    X2 = TrajsT{i}(:, 2);
    P = horzcat(X1(l+1:end), X2(l+1:end));
    RealTrajsT{i} = P;
end

% Calculate time, curl, target angle and error angle
% Store variables depending on the target angle
NT = length(TrajsT{end}(:,1));
TargetAngle = cell2mat(subj.AngleTargetTrain);
possiblePos = 0:pi/4:2*pi;
aux = ones(8,1);
CutInds = [];
TrajsTang = [];
Teach = [];
Curl = [];
ErrAng = [];
for i = 1 : length(RealTrajsT)
    for j = 1 : length(possiblePos)-1
       if TargetAngle(i) - possiblePos(j) < 0.01
          TrajsTang{aux(j), j} = RealTrajsT{i};
          Teach{aux(j), j} = length(RealTrajsT{i}(:,1))/60;
          ErrAng{aux(j), j} = ErrAngss(i);
          X = RealTrajsT{i}(:,1);
          Y = RealTrajsT{i}(:,2);
          Disp = sqrt((X(1)-X(end))^2 + (Y(1)-Y(end))^2);
          Dist = 0;
          for k = 2 : length(X) 
            Dist = Dist + sqrt((X(k-1)-X(k))^2 + (Y(k-1)-Y(k))^2);
          end
          Curl{aux(j), j} = Dist/Disp;
          if Curl{aux(j), j} > CurlThr && Teach{aux(j), j} > TimeThr
              CutInds = vertcat(CutInds,i);
          end
          aux(j) = aux(j) + 1;
          break 
       end
    end
end

% Plot Trajectories color coded depending on target position, saturation
% coded depending on trial number, Plot the kinematics per trial (same
% color code) and deviation angle depending on target position (same color
% code)
% c = jet(8);
% figure,
% subplot(2,2,[1 3])
% hold on
% aux = ones(8,1);
% possibleSat = 0.2:0.03:1;
% for x = 1 : size(TrajsTang, 2)
%     for y = 1 : size(TrajsTang,1)
%         if ~isempty(TrajsTang{y,x})
%             if Curl{y,x} < CurlThr && Teach{y,x} < TimeThr
%                 cl1 = rgb2hsv(c(x,:));
%                 cl1(2) = possibleSat(aux(x));
%                 cl = hsv2rgb(cl1);
%                 plot(TrajsTang{y,x}(:,1), TrajsTang{y,x}(:,2), 'linewidth',3, 'color', cl);
%                 aux(x) = aux(x) + 1;
%             end
%         end
%     end
% end
% axis([-500 500 -400 400])
% title('Trajectories')
% subplot(2,2,2)
% hold on
% aux = ones(8,1);
% for x = 1 : size(Teach, 2)
%     for y = 1 : size(Teach,1)
%         if ~isempty(Teach{y,x})
%             cl1 = rgb2hsv(c(x,:));
%             cl1(2) = possibleSat(aux(x));
%             cl = hsv2rgb(cl1);
%             scatter(Teach{y,x}, Curl{y,x}, 100, cl, 'filled');
%             plot(2.3*ones(2,1), [0 2], 'k', 'linewidth', 2);
%             plot([-1 6], 1.5*ones(2,1), 'k', 'linewidth', 2);
%             aux(x) = aux(x) + 1;
%         end
%     end
% end
% axis([0 5 1 1.6])
% title('Trial Dynamics')
% xlabel('Time (s)')
% ylabel('Curlyness')
% subplot(2,2,4)
% hold on
% aux = ones(8,1);
% for x = 1 : size(Teach, 2)
%     for y = 1 : size(Teach,1)
%         if ~isempty(Teach{y,x})
%             if Curl{y,x} < CurlThr && Teach{y,x} < TimeThr
%                 cl1 = rgb2hsv(c(x,:));
%                 cl1(2) = possibleSat(aux(x));
%                 cl = hsv2rgb(cl1);
%                 scatter(x, ErrAng{y,x}, 100, cl, 'filled');
%                 aux(x) = aux(x) + 1;
%             end
%         end
%     end
% end
% axis([1 8 -100 100])
% title('Trial Accuracy')
% xlabel('Target Position')
% ylabel('Error Angle')
% end