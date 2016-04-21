function [] = plot_data_angle_rod1( all_analysis,plot_individuals,save_fig )
%PLOT_DATA_ROD1
% plot_data_angle_rod1( all_analysis,plot_individuals,save_fig ) - function
% definition
%
% all_analysis = analysis; %file in your workspace
% plot_individuals = 0 or 1; %plot a single figure per indivdual -carefull,
% this opens A LOT of new figures
% save_fig = 0 or 1; % to save figures. Not yet implemented.
%
% Have the ANALYSIS file in your workspace and simply run
%the function like in example 1.
% If you would like to plot all analysis at the same time, create a cell
% with the analysis file inside - see example 2.
% EXAMPLES:
%  1-> plot_data_rod1( {analysis},0,1 ) - example
%  2-> plot_data_rod1( {analysis_v1, analysis_v2, analysis_v3},1,1 ) - example
%

block={'Train','Test','After'};

save_path = 'C:\Users\Rodrigo\Documents\INDP2015\Motor Week\Data\motor-data\PerTargetFigures';

for file=1:length(all_analysis)
    
    analysis=all_analysis{file};
    n_subjects = length(analysis);

    for i=1:n_subjects
        name{i}=analysis{1,i}.name(4:(end-6));
    end
    
    
    for i=1:3
        angleError.(block{i})=[];
        angleTarget.(block{i})=[];
            n_trials(i) = length(analysis{1,1}.(block{i}).TargetAngle);
    end
    trials2plot = {1:n_trials(1); n_trials(1)+1:n_trials(1)+n_trials(2); n_trials(1)+n_trials(2)+1:n_trials(1)+n_trials(2)+n_trials(3)};
    for j=1:3
        for i=1:n_subjects
            angleError.(block{j}) =  cat(2,angleError.(block{j}),analysis{1,i}.(block{j}).ErrAngss);
            angleTarget.(block{j}) = cat(2,angleTarget.(block{j}),analysis{1,i}.(block{j}).TargetAngle);
        end
    end
    
    for j=1:3
        angleTarget.(block{j})(angleTarget.(block{j})==2*pi)=0;
    end
    target=unique(angleTarget.(block{1}));
    for j=1:3
        mean_angleError.(block{j})=[];%zeros(n_trials(j),length(target));
        error_perAngle.(block{j})=NaN*ones(n_trials(j),n_subjects,length(target));
    end
    
    
    for j=1:3
        for i=1:length(target)
            meanAbs_angleError.(block{j})(i) = mean(abs(angleError.(block{j})(angleTarget.(block{j})==repmat(target(i),size(angleTarget.(block{j}))))),1);
            seAbs_angleError.(block{j})(i) = std(abs(angleError.(block{j})(angleTarget.(block{j})==repmat(target(i),size(angleTarget.(block{j}))))),1)/sqrt(n_subjects);
        end
    end
    
    %getting the time profile of the error split by angle
    for j=1:3
        for sub=1:n_subjects
            for t=1:n_trials(j)
                for i=1:length(target)
                    if angleTarget.(block{j})(t,sub)==target(i)
                        error_perAngle.(block{j})(t,sub,i) = angleError.(block{j})(t,sub);
                    end
                end
            end
        end
    end
    
    for j=1:3
        mean_error_perAngle.(block{j})=squeeze(nanmean(error_perAngle.(block{j}),2));
        se_error_perAngle.(block{j})=squeeze(nanstd(error_perAngle.(block{j}),1,2))/sqrt(n_subjects);
    end
    
    figure
    for j=1:3
        h(j)=subplot(3,1,j);
        hold on
        errorbar(target(1:2:end),meanAbs_angleError.(block{j})(1:2:end),seAbs_angleError.(block{j})(1:2:end),'s-','Color', [0.0 0.667 1.0],'LineWidth',2)
        errorbar(target(2:2:end),meanAbs_angleError.(block{j})(2:2:end),seAbs_angleError.(block{j})(2:2:end),'s-','Color', [1.0 0.667 0.0],'LineWidth',2)
        ylabel('Mean absolute angle error')
        xlabel('Target Angle (rad)')
    end
    title(h(1),['Mean absolute angle error - ',analysis{1,1}.task_version])
    
    if save_fig
        saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'mean_error_perTarget' analysis{1,1}.task_version ],'png')
        saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'mean_error_perTarget' analysis{1,1}.task_version ],'fig')
    end
    
    vert_limits = [-70 70];
    figure
    for j=1:3
        for i=1:2:length(target)
            h1(i)=subplot(4,2,i);
            hold on
            plot(trials2plot{j}, smooth(mean_error_perAngle.(block{j})(:,i)),'Color', [0.0 0.667 1.0],'LineWidth',2)
            plot([0 trials2plot{3}(end)],[0 0],'--k','LineWidth',0.5)
            plot([trials2plot{1}(end) trials2plot{1}(end) ],vert_limits,'--k','LineWidth',0.5)
            plot([trials2plot{2}(end) trials2plot{2}(end) ],vert_limits,'--k','LineWidth',0.5)
            xlabel('Trials')
            ylabel([num2str(target(i)/pi),'\pi'],'FontSize',14)
            ylim(vert_limits)
        end
        for i=2:2:length(target)
            h2(i)=subplot(4,2,i);
            hold on
            plot(trials2plot{j}, smooth(mean_error_perAngle.(block{j})(:,i)),'Color', [1.0 0.667 0.0],'LineWidth',2)
            plot([0 trials2plot{3}(end)],[0 0],'--k','LineWidth',0.5)
            plot([trials2plot{1}(end) trials2plot{1}(end) ],vert_limits,'--k','LineWidth',0.5)
            plot([trials2plot{2}(end) trials2plot{2}(end) ],vert_limits,'--k','LineWidth',0.5)
            xlabel('Trials')
            ylabel([num2str(target(i)/pi),'\pi'],'FontSize',14)
            ylim(vert_limits)
        end
        title(h1(1),['Cardinal Orientation - ',analysis{1,1}.task_version])
        title(h2(2),['Diagonal Orientation - ',analysis{1,1}.task_version])
        
        if save_fig
            saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'error_perTarget_' analysis{1,1}.task_version],'png')
            saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'error_perTarget_' analysis{1,1}.task_version],'fig')
        end
    end
    
    vert_limits2=[-45 45];
    %plot mean of diag and mean of cardinal
    figure
    for j=1:3
        %          h(j)=subplot(3,1,j);
        hold on
        plot(trials2plot{j}, smooth(nanmean(mean_error_perAngle.(block{j})(:,1:2:end),2)),'Color', [0.0 0.667 1.0],'LineWidth',2)       
        plot(trials2plot{j}, smooth(nanmean(mean_error_perAngle.(block{j})(:,2:2:end),2)),'Color', [1.0 0.667 0.0],'LineWidth',2)
    end
    plot([trials2plot{1}(end) trials2plot{1}(end) ],vert_limits2,'--k','LineWidth',0.5)
    plot([trials2plot{2}(end) trials2plot{2}(end) ],vert_limits2,'--k','LineWidth',0.5)
    plot([0 trials2plot{3}(end)],[0 0],'--k','LineWidth',0.5)
    xlabel('Trials')
    ylabel(['Angle Error - ',block{j}])
    ylim(vert_limits2)
    title([analysis{1,1}.task_version])
    if save_fig
        saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'meanerror_diagVScard_' analysis{1,1}.task_version ],'png')
        saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'meanerror_diagVScard_' analysis{1,1}.task_version ],'fig')
    end
end
end

