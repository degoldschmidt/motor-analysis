function [] = plot_data_rod1( all_analysis,plot_individuals,save_fig )
%PLOT_DATA_ROD1 
% plot_data_rod1( all_analysis,plot_individuals,save_fig ) - function
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

save_path = 'C:\Users\Rodrigo\Documents\INDP2015\Motor Week\Data\motor-data\AngleErrorFigures';

for file=1:length(all_analysis)
    
    analysis=all_analysis{file};
    n_subjects = length(analysis);
    for i=1:n_subjects
        name{i}=analysis{1,i}.name(4:(end-6));
    end
    
    
    for i=1:3
        angleError.(block{i})=[];
    end
    for j=1:3
        for i=1:n_subjects
            angleError.(block{j}) =  cat(2,angleError.(block{j}),analysis{1,i}.(block{j}).ErrAngss);
        end
    end
    
    figure
    for j=1:3
        h(j)=subplot(3,1,j);
        hold on
        plot(smooth(mean(angleError.(block{j}),2)))
        plot([0 length(mean(angleError.(block{j}),2))],[0 0],'--k','LineWidth',0.5)
        ylabel(block{j})
        xlabel('Trials')
        ylim([-50 50])
    end
    title(h(1),[analysis{1,1}.task_version, ' - n=' ,num2str(n_subjects)]);
    
    if save_fig
        saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'mean_angleError_' analysis{1,1}.task_version ],'png')
        saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'mean_angleError_' analysis{1,1}.task_version ],'fig')
    end
    
    if plot_individuals
    for j=1:3
        for i=1:n_subjects
            figure(file*100 +20*j + i-1)
            hold on
            plot(angleError.(block{j})(:,i))
            plot([0 length(mean(angleError.(block{j}),2))],[0 0],'--k','LineWidth',0.5)
            title([analysis{1,i}.task_version, '-' block{j}, '-', analysis{1,i}.name])
            ylabel('AngleError(º)')
            xlabel('Trials')
            if save_fig
                saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'mean_angleError_' analysis{1,1}.task_version,'_',name{i} ],'png')
                saveas(gcf,[save_path filesep analysis{1,1}.task_version filesep 'mean_angleError_' analysis{1,1}.task_version,'_',name{i} ],'fig')
            end
        end
    end
    end
end
end

